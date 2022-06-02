SELECT
    ctu.transfer_id,
    ctui.incident,
    ctui.created_at at time zone 'America/Mexico_City' as incident_created_date,
    unit.type,
    unit.blood_type
FROM center_transfer_unit_incident ctui
LEFT JOIN center_transfer_unit ctu ON ctu.id=ctui.id
LEFT JOIN unit ON unit.id=ctu.unit_id
LEFT JOIN center ON center.id=unit.center_id
WHERE 
    {{center}}
    AND {{city}}
    AND {{blood_type}}
    AND {{unit_id}}
    AND {{unit_type}}