-- Dev Kshitij Patel_DBS311_ZRAL_lab3
SELECT s.s_last, COUNT(e.grade) AS num_grades
FROM enrollment e
JOIN student s ON e.s_id = s.s_id
GROUP BY s.s_last;