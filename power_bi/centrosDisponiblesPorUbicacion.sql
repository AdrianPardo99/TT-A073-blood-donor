SELECT*FROM center
WHERE
    {{center}}
    AND deleted_at is null