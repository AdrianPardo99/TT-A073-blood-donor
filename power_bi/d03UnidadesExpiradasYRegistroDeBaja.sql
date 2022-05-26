WITH reasons_for_expired AS (
    SELECT 
        id,
        history_change_reason,
        history_date at time zone 'America/Mexico_City' as expired_date,
        history_user_id
    FROM unit_history 
    WHERE 
        history_change_reason is not null
)
SELECT
    center.id as center_id,
    center.name as center_name,
    unit.type as type_unit,
    blood_type,
    history_change_reason,
    expired_date,
    public.user.first_name || ' '||public.user.last_name as full_name_user,
    public.user.email as email_user
    
FROM unit
LEFT JOIN center ON center.id=unit.center_id
LEFT JOIN reasons_for_expired rfe ON rfe.id=unit.id
LEFT JOIN public.user ON public.user.id=rfe.history_user_id
WHERE
    is_expired
    AND unit.deleted_at is null