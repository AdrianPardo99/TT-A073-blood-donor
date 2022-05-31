SELECT
    center.id,
    center.name,
    center.address,
    center.city,
    center.latitude,
    center.longitude,
    center.type
FROM center
WHERE
    {{center}}
    AND {{city}}
    AND deleted_at is null