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
-- So its the sailors that have a reservation, that have a certificate, but its
-- not certified for the class of the boat in the trip they are in?

-- Sailor - sid, first_name, surname
-- Boat - cni, of_class_name
-- Trip - cni,start_date, take_off_date, is_skipper_for(sid(Sailor), start_date(Reservation))


-- authorized_for - cni, start_date, sid
-- enables - sid, issue_date, jurisdiction_name, class_name
SELECT * FROM certification; -- certified sailors are skippers
SELECT * FROM Trip;
SELECT * FROM Boat;
SELECT * FROM Reservation;
SELECT * FROM authorized_for;
SELECT * FROM enables;

-- Boat class except Certified class ?

