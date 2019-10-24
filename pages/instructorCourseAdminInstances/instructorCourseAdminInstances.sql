-- BLOCK select_course_instances
SELECT
    ci.short_name,
    ci.long_name,
    ci.id,
    count(e.user_id) AS number
FROM
    course_instances AS ci
    LEFT JOIN enrollments AS e ON (e.course_instance_id = ci.id) AND (e.role = 'Student')
    LEFT JOIN LATERAL authz_course_instance($user_id, ci.id, $is_administrator, $req_date) AS aci ON TRUE
WHERE
    ci.course_id = $course_id
    AND ci.deleted_at IS NULL
    AND (aci->>'has_instructor_view')::BOOLEAN
GROUP BY
    ci.id
ORDER BY
    ci.number DESC, ci.id;
