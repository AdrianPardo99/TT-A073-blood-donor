SELECT
    unit.type||' Expirado '||unit.blood_type as type_unit,
    count(*) as qty_units
FROM unit
LEFT JOIN center ON center.id=unit.center_id
WHERE 
    unit.deleted_at is null
    AND unit.is_expired
    AND {{center}}
    AND {{city}}
    AND {{unit_type}}
    AND {{blood_type}}
    [[ AND (unit.created_at at time zone 'America/Mexico_City')::timestamp::date BETWEEN {{start_date}} AND {{end_date}} ]]
GROUP BY type_unit
UNION
SELECT
    unit.type||' Disponible sin transferencia '||unit.blood_type as type_unit,
    count(*) as qty_units
FROM unit
LEFT JOIN center ON center.id=unit.center_id
WHERE 
    unit.deleted_at is null
    AND unit.is_available
    AND NOT unit.can_transfer
    AND {{center}}
    AND {{city}}
    AND {{unit_type}}
    AND {{blood_type}}
    [[ AND (unit.created_at at time zone 'America/Mexico_City')::timestamp::date BETWEEN {{start_date}} AND {{end_date}} ]]
GROUP BY type_unit
UNION
SELECT
    unit.type||' Disponible con transferencia '||unit.blood_type as type_unit,
    count(*) as qty_units
FROM unit
LEFT JOIN center ON center.id=unit.center_id
WHERE 
    unit.deleted_at is null
    AND unit.is_available
    AND unit.can_transfer
    AND {{center}}
    AND {{city}}
    AND {{unit_type}}
    AND {{blood_type}}
    [[ AND (unit.created_at at time zone 'America/Mexico_City')::timestamp::date BETWEEN {{start_date}} AND {{end_date}} ]]
GROUP BY type_unit
