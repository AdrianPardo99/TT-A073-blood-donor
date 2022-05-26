SELECT
    unit.type||' Expirado' as type_unit,
    count(*) as qty_units
FROM unit
LEFT JOIN center ON center.id=unit.center_id
WHERE 
    unit.deleted_at is null
    AND unit.is_expired
    AND {{center}}
GROUP BY unit.type
UNION
SELECT
    unit.type||' Disponible sin transferencia',
    count(*) as qty_units
FROM unit
LEFT JOIN center ON center.id=unit.center_id
WHERE 
    unit.deleted_at is null
    AND unit.is_available
    AND NOT unit.can_transfer
    AND {{center}}
GROUP BY unit.type 
UNION
SELECT
    unit.type||' Disponible con transferencia',
    count(*) as qty_units
FROM unit
LEFT JOIN center ON center.id=unit.center_id
WHERE 
    unit.deleted_at is null
    AND unit.is_available
    AND unit.can_transfer
    AND {{center}}
GROUP BY unit.type 
