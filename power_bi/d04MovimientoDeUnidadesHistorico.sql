SELECT
    unit_history.history_date at time zone 'America/Mexico_City' as history_date,
    unit_history.id,
    unit_history.type as unit_type,
    unit_history.blood_type,
    coalesce(unit_history.history_change_reason,CASE WHEN unit_history.history_type='+' THEN 'Create unit' WHEN not unit_history.is_available THEN 'In transfer' WHEN LAG(center.name)OVER(PARTITION BY unit_history.id ORDER BY history_date)=center.name THEN 'Cancelled transfer'  ELSE 'Changed center' END ) as history_change_reason,
    center.name as center_name,
    center.id as center_id,
    public.user.email as changed_by
    
FROM unit_history
JOIN unit ON unit.id=unit_history.id
LEFT JOIN center ON center.id=unit_history.center_id
LEFT JOIN public.user ON public.user.id=unit_history.history_user_id
WHERE 
    unit.deleted_at is null
    AND {{center}}
    AND {{city}}
    AND {{blood_type}}
    AND {{unit_id}}
    AND {{unit_type}}
ORDER BY unit_history.id , unit_history.history_date