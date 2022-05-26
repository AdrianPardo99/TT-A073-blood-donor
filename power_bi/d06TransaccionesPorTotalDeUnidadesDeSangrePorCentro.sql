WITH movimientos_de_sangre AS(
    SELECT
        unit_history.history_date at time zone 'America/Mexico_City' as history_date,
        unit_history.id,
        unit_history.type as unit_type,
        LAG(unit_history.center_id)OVER(PARTITION BY unit_history.id ORDER BY unit_history.history_date) as last_center_id,
        unit_history.blood_type,
        coalesce(unit_history.history_change_reason,CASE WHEN unit_history.history_type='+' THEN 'Create unit' WHEN not unit_history.is_available THEN 'In transfer' ELSE 'Changed center' END ) as history_change_reason,
        center.name as center_name,
        center.id as center_id,
        public.user.email as changed_by
    FROM unit_history
    LEFT JOIN unit ON unit.id=unit_history.id
    LEFT JOIN center ON center.id=unit_history.center_id
    LEFT JOIN public.user ON public.user.id=unit_history.history_user_id
    WHERE 
        unit.deleted_at is null
        AND {{center}}
    ORDER BY unit_history.id , unit_history.history_date
), ultimos_movimientos AS (
    SELECT 
        DISTINCT ON(id)id,
        FIRST_VALUE(history_change_reason)OVER(PARTITION BY id ORDER BY history_date desc) as history_change_reason,
        FIRST_VALUE(unit_type)OVER(PARTITION BY id ORDER BY history_date desc) as unit_type,
        FIRST_VALUE(blood_type)OVER(PARTITION BY id ORDER BY history_date desc) as blood_type,
        FIRST_VALUE(center_name)OVER(PARTITION BY id ORDER BY history_date desc) as center_name
    FROM movimientos_de_sangre 
    WHERE 
        1=1
        [[ AND (history_date)::timestamp::date BETWEEN {{start_date}} AND {{end_date}} ]]
)

SELECT
    um.center_name,
    (
        SELECT
            count(*)
        FROM ultimos_movimientos um1
        WHERE 
            um1.center_name=um.center_name
            AND um1.history_change_reason not in ('Changed center','In transfer', 'Create unit')
    )as qty_units_used,
    (
        SELECT
            count(*)
        FROM ultimos_movimientos um1
        WHERE 
            um1.center_name=um.center_name
            AND um1.history_change_reason in ('In transfer')
    )as qty_units_in_transfer,
    (
        SELECT
            count(*)
        FROM ultimos_movimientos um1
        WHERE 
            um1.center_name=um.center_name
            AND um1.history_change_reason in ('Changed center')
    )as qty_units_transfered,
    (
        SELECT
            count(*)
        FROM ultimos_movimientos um1
        WHERE 
            um1.center_name=um.center_name
            AND um1.history_change_reason in ('Create unit')
    )as qty_units_center
FROM ultimos_movimientos um
GROUP BY um.center_name