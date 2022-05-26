SELECT
    unit.id as unit_id,
    center.name as center_name,
    unit.type as unit_type,
    unit.blood_type,
    unit.donor_age,
    unit.donor_gender,
    unit.expired_at
FROM unit
LEFT JOIN center ON center.id=unit.center_id
WHERE
    unit.deleted_at is null
    AND unit.expired_at-interval '1 week'<=(current_timestamp at time zone 'America/Bogota')::timestamp::date
    AND not unit.is_expired