SELECT
    center.name as center_name,
    count(CASE WHEN status='created' THEN 1 END) as qty_petitions_received,
    count(CASE WHEN status='finished' THEN 1 END) as qty_petitions_on_site,
    count(CASE WHEN status not in ('created','finished') THEN 1 END) as qty_total_transfers_in_progress,
    count(*) as qty_total_transfers,
    sum(center_transfer.qty) as qty_units_on_petitions_received,
    sum(
        CASE WHEN status='finished' THEN
            center_transfer.qty
        ELSE 
            0
        END
    ) as qty_units_transfered,
    avg(
        CASE WHEN status='finished' THEN
            (EXTRACT (EPOCH FROM (center_transfer.updated_at-center_transfer.created_at))/60)
        END
    ) as avg_minutes_per_petitions_from_created_to_finished
FROM center_transfer
LEFT JOIN center ON center.id=center_transfer.origin_id
WHERE
    center_transfer.deleted_at is null
    AND center_transfer.status not in ('cancelled')
    AND {{center}}
    AND {{city}}
    [[ AND (center_transfer.created_at at time zone 'America/Mexico_City')::timestamp::date BETWEEN {{start_date}} AND {{end_date}} ]]
GROUP BY center_name