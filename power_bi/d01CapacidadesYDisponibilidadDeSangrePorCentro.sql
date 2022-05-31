WITH cantidad_de_unidades_disponibles AS (
    SELECT
        center_id,
        type,
        count(CASE WHEN is_available THEN 1 END) as qty_units,
        count(*) as total_units
    FROM unit
    WHERE 
        deleted_at is null
    GROUP BY center_id,type
)

SELECT
    center.id as center_id,
    center.name as center_name,
    cc.type as blood_unit_type,
    COALESCE((
        SELECT
            qty_units
        FROM cantidad_de_unidades_disponibles cdud
        WHERE
            cdud.center_id=center.id
            AND cdud.type=cc.type
    ),0) as qty_units,
    cc.min_qty,
    cc.max_qty
FROM center
LEFT JOIN center_capacity cc ON cc.center_id=center.id 
WHERE
    cc.deleted_at is null
    AND {{center}}
    AND {{city}}
ORDER BY center_id