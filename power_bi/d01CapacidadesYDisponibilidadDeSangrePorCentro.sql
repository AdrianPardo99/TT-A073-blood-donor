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
    cdud.type as type_unit,
    cdud.qty_units,
    cc.min_qty,
    cc.max_qty
FROM center
LEFT JOIN cantidad_de_unidades_disponibles cdud ON cdud.center_id=center.id
LEFT JOIN center_capacity cc ON cc.center_id=center.id AND cc.type=cdud.type
WHERE
    cc.deleted_at is null
    AND {{center}}