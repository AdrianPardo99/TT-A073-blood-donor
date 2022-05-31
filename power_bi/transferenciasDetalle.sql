SELECT
    center.name as center_name,
    count(CASE WHEN status='created' THEN 1 END) as qty_petitions_received,
    count(CASE WHEN status='finished' THEN 1 END) as qty_petitions_on_site,
    sum(center_transfer.qty) as qty_units_transfered,
    avg((EXTRACT (EPOCH FROM (center_transfer.updated_at-center_transfer.created_at))/60)) as avg_minutes_per_petitions_from_created_to_finished
FROM center_transfer
LEFT JOIN center ON center.id=center_transfer.origin_id
WHERE
    center_transfer.deleted_at is null
    AND {{center}}
    AND {{city}}
GROUP BY center_name