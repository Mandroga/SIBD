-- 2.4 Simple SQL Queries

-- A. The name of all boats that are used in some trip.
SELECT b.name, b.cni
FROM Boat AS b
JOIN Trip AS t ON b.cni = t.cni;

-- B. The name of all boats that are not used in any trip.
SELECT b.name, b.cni
FROM Boat AS b
EXCEPT
SELECT b.name, b.cni
FROM Boat AS b
JOIN Trip AS t ON b.cni = t.cni;

-- C. The name of all boats registered in 'PRT' (ISO code) for which at least one responsible for a
-- reservation has a surname that ends with 'Santos'.
SELECT b_filtered.name, b_filtered.cni
FROM
(
SELECT b.name, b.cni, b.registered_iso
FROM Boat AS b
JOIN responsible_for AS rf ON  b.cni = rf.cni
JOIN  Sailor AS s ON rf.responsible_sid = s.sid
WHERE s.surname = 'Santos'
) AS b_filtered
WHERE b_filtered.registered_iso = 'PRT';

-- D. The full name of all skippers without any certificate corresponding to the class of the trip’s boat.

-- Sailor - sid, first_name, surname
-- Boat - cni, of_class_name
-- Trip - cni,start_date, take_off_date, is_skipper_for(sid(Sailor), start_date(Reservation))
-- enables - sid, issue_date, jurisdiction_name, class_name

SELECT DISTINCT sid, first_name, surname -- so funciona se permitir row value expressions; problemas com nulls - chatgpt
FROM Trip AS t
JOIN Boat AS b ON t.cni = b.cni
JOIN Sailor AS s ON t.is_skipper_for_id = s.sid
WHERE (s.sid, b.of_class_name)
NOT IN (SELECT sid, class_name FROM enables)
;

SELECT DISTINCT s.sid, first_name, surname
FROM Sailor AS s
JOIN Trip AS t ON s.sid = t.is_skipper_for_id
JOIN Boat AS b ON t.cni = b.cni
WHERE NOT EXISTS
(
SELECT 1
FROM enables AS e
WHERE s.sid = e.sid
AND e.class_name = b.of_class_name
);


