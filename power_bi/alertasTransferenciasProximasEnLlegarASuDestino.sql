SELECT
    center_transfer.id as transfaction_id,
    center_transfer.updated_at at time zone 'America/Mexico_City' as updated_at,
    origin.name as origin_center_name,
    destination.name as destination_center_name,
    unit_type,
    receptor_blood_type,
    qty,
    u.id as unit_transfer_id,
    u.blood_type
FROM center_transfer
LEFT JOIN center_transfer_unit ctu ON ctu.transfer_id=center_transfer.id
LEFT JOIN unit u ON u.id=ctu.unit_id
LEFT JOIN center origin ON origin.id=center_transfer.origin_id
LEFT JOIn center destination ON destination.id=center_transfer.destination_id
WHERE 
    status in ('in_transit')
    AND center_transfer.deleted_at is null