---------------------------------------
-- Countries
---------------------------------------
-- Country flags (real URLs)
INSERT INTO Country(iso_code, name, flag) VALUES
('PTR', 'Portugal', 'https://flagcdn.com/w320/pt.png'),
('SPN', 'Spain', 'https://flagcdn.com/w320/es.png'),
('BMU', 'Bermuda', 'https://flagcdn.com/w320/bm.png');

-- Shouldnt be allowed
INSERT INTO Country(iso_code, name, flag) VALUES ('XXX','xxx','https://flagcdn.com/w320/pt.png');
INSERT INTO Country(iso_code, name, flag) VALUES ('XXX','Portugal','xxx');
INSERT INTO Country(iso_code, name, flag) VALUES ('', '',''); -- PROBLEM!
-- We need to check if its empty string, do we need to check if its a valid ISO, name or link ?
SELECT * FROM Country;
DELETE FROM Country;
---------------------------------------
-- Jurisdictions
---------------------------------------
INSERT INTO Jurisdiction(name) VALUES
('International Waters'),
('Portuguese EEZ'),
('Portuguese Territorial Sea'),
('Spanish EEZ'),
('Spanish Territorial Sea'),
('Spanish Internal Waters'),
('English Internal Waters'),
('Venezuelan EEZ');

-- EDGE CASE
INSERT INTO Jurisdiction(name) VALUES (''); -- PROBLEM?


SELECT * FROM jurisdiction;
DELETE FROM international_jurisdiction;
DELETE FROM national_jurisdiction;
DELETE FROM jurisdiction;


---------------------------------------
-- International / National Jurisdictions
---------------------------------------
INSERT INTO International_Jurisdiction(name) VALUES
('International Waters');
-- Shouldnt be allowed
INSERT INTO International_Jurisdiction(name) VALUES ('Venezuelan EEZ'); -- PROBLEM!

INSERT INTO National_Jurisdiction(name, belongs_to_iso) VALUES
('Portuguese EEZ', 'PTR'),
('Portuguese Territorial Sea', 'PTR'),
('Spanish EEZ', 'SPN'),
('Spanish Territorial Sea','SPN'),
('Spanish Internal Waters','SPN');

-- Shouldnt be allowed
INSERT INTO National_Jurisdiction(name, belongs_to_iso) VALUES ('English Internal Waters','SPN'); -- PROBLEM?
INSERT INTO National_Jurisdiction(name, belongs_to_iso) VALUES ('xxx','xxx');
INSERT INTO National_Jurisdiction(name, belongs_to_iso) VALUES ('','');
INSERT INTO National_Jurisdiction(name, belongs_to_iso) VALUES ('Venezuelan EEZ','xxx');



---------------------------------------
-- Classes
---------------------------------------
INSERT INTO Class(name, max_length) VALUES
('Class 2', 6.00),
('Class 3', 9.50),
('Class 4', 12.00),
('Class 1', 2.50);

-- shouldnt be allowed
INSERT INTO Class(name, max_length) VALUES (NULL, NULL);
INSERT INTO Class(name, max_length) VALUES ('Class 5', NULL);
INSERT INTO Class(name, max_length) VALUES (NULL, 5);
INSERT INTO Class(name, max_length) VALUES ('Class 4', 5);
INSERT INTO Class(name, max_length) VALUES ('Class 5', -1); -- PROBLEM!
INSERT INTO Class(name, max_length) VALUES ('Class 6', 0); -- PROBLEM!
INSERT INTO Class(name, max_length) VALUES ('', 1000); -- PROBLEM?
INSERT INTO Class(name, max_length) VALUES ('Class 7', 001);
SELECT * FROM Class;
DELETE FROM Class;
---------------------------------------
-- Locations
---------------------------------------
INSERT INTO Location(long, lat, name) VALUES
(-9.142685, 38.736946, 'Lisbon Marina'),
(-8.653784, 41.141376, 'Porto Marina'),
(-7.937000, 37.016000, 'Faro Marina'),
(-16.000000, 32.650000, 'Madeira Marina');

-- Shouldnt be allowed
INSERT INTO Location(long, lat, name) VALUES (90, 180, '');
INSERT INTO Location(long, lat, name) VALUES (-90, -180, '');
INSERT INTO Location(long, lat, name) VALUES (-100, 180, '');
INSERT INTO Location(long, lat, name) VALUES (-90, 190, ''); -- PROBLEM!
INSERT INTO Location(long, lat, name) VALUES (-16.000000, 32.650000, 'Madeira Marina2');
INSERT INTO Location(long, lat, name) VALUES (-16.0000001, 32.650000, 'Madeira Marina2');

SELECT * FROM location;
DELETE FROM Location;
---------------------------------------
-- Sailors
---------------------------------------
INSERT INTO Sailor(sid, first_name, surname, email) VALUES
(1, 'Ana',   'Silva',     'ana.silva@example.com'),
(2, 'Bruno', 'Costa',     'bruno.costa@example.com'),
(3, 'Carla', 'Ferreira',  'carla.ferreira@example.com'),
(4, 'Daniel','Pereira',   'daniel.pereira@example.com'),
(5, 'Eva',   'Santos',    'eva.santos@example.com');

DELETE FROM Sailor;
-- Shouldnt be allowed
INSERT INTO Sailor(sid, first_name, surname, email) VALUES (NULL, NULL, NULL, NULL);
INSERT INTO Sailor(sid, first_name, surname, email) VALUES (1, '', '', '');
INSERT INTO Sailor(sid, first_name, surname, email) VALUES (6, '', '', '');-- PROBLEM?
INSERT INTO Sailor(sid, first_name, surname, email) VALUES (7, 'xx', 'xx', 'def not an email'); -- PROBLEM?
INSERT INTO Sailor(sid, first_name, surname, email) VALUES (-1, '', '', 'xa'); -- PROBLEM?
INSERT INTO Sailor(sid, first_name, surname, email) VALUES ( 8, '123', '123', 'xxaa');
-- Specializations
INSERT INTO Junior_Sailor(sid) VALUES
(1),
(4);

INSERT INTO Senior_Sailor(sid) VALUES
(2),
(3),
(5);

---------------------------------------
-- Certifications (valid & expired)
---------------------------------------
-- Bruno: valid (multi-jurisdiction)
INSERT INTO Certification(sid, issue_date, expiry_date) VALUES
(2, DATE '2023-01-01', DATE '2026-12-31');

INSERT INTO Certification(sid, issue_date, expiry_date) VALUES -- PROBLEM!
(1, DATE '2023-01-01', DATE '2022-12-31');

-- Bruno: old expired
INSERT INTO Certification(sid, issue_date, expiry_date) VALUES
(2, DATE '2020-01-01', DATE '2020-12-31');

-- Carla
INSERT INTO Certification(sid, issue_date, expiry_date ) VALUES
(3, DATE '2022-06-15', DATE '2025-06-14');

-- Ana (junior)
INSERT INTO Certification(sid, issue_date, expiry_date) VALUES
(1, DATE '2024-03-01', DATE '2024-09-30');

-- Shouldnt allow
INSERT INTO Certification(sid, issue_date, expiry_date) VALUES
(4, DATE '2024-03-01', DATE '2024-09-30');
---------------------------------------
-- enables (Certification ↔ Jurisdictions)
---------------------------------------
-- Bruno
INSERT INTO enables(sid, issue_date, jurisdiction_name, class_name) VALUES
(2, DATE '2023-01-01', 'International Waters','Class 4'),
(2, DATE '2023-01-01', 'Portuguese Territorial Sea', 'Class 4'),
(2, DATE '2023-01-01', 'Portuguese EEZ', 'Class 4');

SELECT * FROM jurisdiction;

-- Bruno, expired certification
INSERT INTO enables(sid, issue_date, jurisdiction_name, class_name) VALUES
(2, DATE '2020-01-01', 'Portuguese Territorial Sea', 'Class 1');

SELECT * FROM Sailor;
-- Carla
INSERT INTO enables(sid, issue_date, jurisdiction_name, class_name) VALUES
(3, DATE '2022-06-15', 'International Waters', 'Class 3'),
(3, DATE '2022-06-15', 'Spanish EEZ', 'Class 3'),
(3, DATE '2022-06-15', 'Spanish Territorial Sea', 'Class 3'),
(3, DATE '2022-06-15', 'Spanish Internal Waters', 'Class 3');

-- Ana (junior)
INSERT INTO enables(sid, issue_date, jurisdiction_name, class_name) VALUES
(1, DATE '2024-03-01', 'Portuguese Territorial Sea', 'Class 1');

---------------------------------------
-- Boats (one without class to test NULL class_name)
---------------------------------------
INSERT INTO Boat(cni, picture_path, length, name, class_name, registered_iso, class_max_length) VALUES
('PT-BOAT-001', 'https://picsum.photos/seed/lusi/800/600', 9.30, 'Lusitania', 'Class 3','PTR',9.50),
('PT-BOAT-002', 'https://placekitten.com/800/600', 11.80, 'Atlantico', 'Class 4', 'PTR',12.00),
('PT-BOAT-003', 'https://via.placeholder.com/800x600?text=Gaivota', 5.50, 'Gaivota', 'Class 2', 'PTR',6.00),
('BM-BOAT-004', 'https://picsum.photos/seed/oceanbreeze/800/600', 9.20, 'Ocean Breeze', NULL, 'BMU', NULL);


---------------------------------------
-- Reservations (including overlaps and unused)
---------------------------------------
-- Lusitania: long reservation, many authorized sailors, one main trip
INSERT INTO Reservation(cni, start_date, end_date) VALUES
('PT-BOAT-001', DATE '2024-07-01', DATE '2024-07-10');

-- Lusitania: overlapping reservation with different responsible (should give error !!!!)
INSERT INTO Reservation(cni, start_date, end_date) VALUES
('PT-BOAT-001', DATE '2024-07-05', DATE '2024-07-08');

-- Atlantico: single longer reservation
INSERT INTO Reservation(cni, start_date, end_date) VALUES
('PT-BOAT-002', DATE '2024-08-01', DATE '2024-08-15');

-- Gaivota: short reservation, day-trips on river
INSERT INTO Reservation(cni, start_date, end_date) VALUES
('PT-BOAT-003', DATE '2024-07-20', DATE '2024-07-22');

-- Ocean Breeze: reserved but (for now) no trips
INSERT INTO Reservation(cni, start_date, end_date) VALUES
('BM-BOAT-004', DATE '2024-09-01', DATE '2024-09-30');


---------------------------------------
-- Responsible for each reservation
---------------------------------------
INSERT INTO responsible_for(cni, start_date, responsible_sid) VALUES
('PT-BOAT-001', DATE '2024-07-01', 2),  -- Bruno (senior skipper)
('PT-BOAT-001', DATE '2024-07-05', 3),  -- Carla (senior skipper)
('PT-BOAT-002', DATE '2024-08-01', 3),  -- Carla (senior skipper)
('PT-BOAT-003', DATE '2024-07-20', 5);  -- Eva (senior skipper)



---------------------------------------
-- authorized_for (who may skipper/crew each reservation)
---------------------------------------
-- Reservation: PT-BOAT-001, 2024-07-01
INSERT INTO authorized_for(cni, start_date, sid) VALUES
('PT-BOAT-001', DATE '2024-07-01', 2),  -- Bruno (senior, likely skipper)
('PT-BOAT-001', DATE '2024-07-01', 1),  -- Ana (junior crew)
('PT-BOAT-001', DATE '2024-07-01', 4);  -- Daniel (junior crew)

-- Reservation: PT-BOAT-001, 2024-07-05
INSERT INTO authorized_for(cni, start_date, sid) VALUES
('PT-BOAT-001', DATE '2024-07-05', 3);  -- Carla as skipper

-- Reservation: PT-BOAT-002, 2024-08-01
INSERT INTO authorized_for(cni, start_date, sid) VALUES
('PT-BOAT-002', DATE '2024-08-01', 3),  -- Carla
('PT-BOAT-002', DATE '2024-08-01', 5);  -- Eva

-- Reservation: PT-BOAT-003, 2024-07-20
INSERT INTO authorized_for(cni, start_date, sid) VALUES
('PT-BOAT-003', DATE '2024-07-20', 5),  -- Eva (senior skipper)
('PT-BOAT-003', DATE '2024-07-20', 1);  -- Ana (junior crew)

-- Reservation: BM-BOAT-004, 2024-09-01
INSERT INTO authorized_for(cni, start_date, sid) VALUES
('BM-BOAT-004', DATE '2024-09-01', 5);  -- Eva

---------------------------------------
-- Trips (several patterns: long, short, overlapping, unused reservation)
---------------------------------------
-- Trip 1: Lusitania, offshore trip Lisbon → Madeira
INSERT INTO Trip(
    cni, start_date, end_date, take_off_date, arrival_date,
    ins_ref, is_skipper_for_sid, is_skipper_for_start_date, is_skipper_for_cni
) VALUES (
    'PT-BOAT-001',
    DATE '2024-07-01',
    DATE '2024-07-10',
    DATE '2024-07-02',
    DATE '2024-07-09',
    1001,
    2,                   -- Bruno
    DATE '2024-07-01',
    'PT-BOAT-001'
);

-- Trip 2: Lusitania, short overlapping reservation with Carla as skipper
-- (WE SHOULDN'T BE CAPABLE bc should have gotten error above)
INSERT INTO Trip(
    cni, start_date, end_date, take_off_date, arrival_date,
    ins_ref, is_skipper_for_sid, is_skipper_for_start_date, is_skipper_for_cni
) VALUES (
    'PT-BOAT-001',
    DATE '2024-07-05',
    DATE '2024-07-08',
    DATE '2024-07-06',
    DATE '2024-07-08',
    1002,
    3,                   -- Carla
    DATE '2024-07-05',
    'PT-BOAT-001'
);

-- Trip 3: Atlantico with Carla
INSERT INTO Trip(
    cni, start_date, end_date, take_off_date, arrival_date,
    ins_ref, is_skipper_for_sid, is_skipper_for_start_date, is_skipper_for_cni
) VALUES (
    'PT-BOAT-002',
    DATE '2024-08-01',
    DATE '2024-08-15',
    DATE '2024-08-02',
    DATE '2024-08-14',
    2001,
    3,                   -- Carla
    DATE '2024-08-01',
    'PT-BOAT-002'
);

-- Trip 4: Gaivota, day-trip with Eva
INSERT INTO Trip(
    cni, start_date, end_date, take_off_date, arrival_date,
    ins_ref, is_skipper_for_sid, is_skipper_for_start_date, is_skipper_for_cni
) VALUES (
    'PT-BOAT-003',
    DATE '2024-07-20',
    DATE '2024-07-22',
    DATE '2024-07-20',
    DATE '2024-07-20',
    3001,
    5,                   -- Eva
    DATE '2024-07-20',
    'PT-BOAT-003'
);

-- Reservation BM-BOAT-004 intentionally has no Trip for "reserved but never sailed" scenario

---------------------------------------
-- starts_ends (tracks route endpoints for each trip)
---------------------------------------
-- Trip 1: Lisbon → Madeira
INSERT INTO starts_ends(
    cni, start_date, take_off_date,
    start_long, end_long,
    start_lat, end_lat
) VALUES (
    'PT-BOAT-001',
    DATE '2024-07-01',
    DATE '2024-07-02',
    -9.142685,  -- Lisbon
    -16.000000, -- Madeira
    38.736946,
    32.650000
);

-- Trip 2: Porto → Lisbon
INSERT INTO starts_ends(
    cni, start_date, take_off_date,
    start_long, end_long,
    start_lat, end_lat
) VALUES (
    'PT-BOAT-001',
    DATE '2024-07-05',
    DATE '2024-07-06',
    -8.653784,  -- Porto
    -9.142685,  -- Lisbon
    41.141376,
    38.736946
);

-- Trip 3: Lisbon → Faro
INSERT INTO starts_ends(
    cni, start_date, take_off_date,
    start_long, end_long,
    start_lat, end_lat
) VALUES (
    'PT-BOAT-002',
    DATE '2024-08-01',
    DATE '2024-08-02',
    -9.142685,  -- Lisbon
    -7.937000,  -- Faro
    38.736946,
    37.016000
);

-- Trip 4: Porto → Porto (round trip / local)
INSERT INTO starts_ends(
    cni, start_date, take_off_date,
    start_long, end_long,
    start_lat, end_lat
) VALUES (
    'PT-BOAT-003',
    DATE '2024-07-20',
    DATE '2024-07-20',
    -8.653784,  -- Porto
    -8.653784,  -- Porto
    41.141376,
    41.141376
);

---------------------------------------
-- records (jurisdictions crossed by each trip)
---------------------------------------
-- Trip 1: mainly Portugal Territorial + International
INSERT INTO records(cni, start_date, take_off_date, sequence, jurisdiction_name) VALUES
('PT-BOAT-001', DATE '2024-07-01', DATE '2024-07-02', 1, 'Portugal Territorial Waters'),
('PT-BOAT-001', DATE '2024-07-01', DATE '2024-07-02', 2, 'International Waters');

-- Trip 2: coastal trip PT only
INSERT INTO records(cni, start_date, take_off_date, sequence, jurisdiction_name) VALUES
('PT-BOAT-001', DATE '2024-07-05', DATE '2024-07-06', 1, 'Portugal Territorial Waters');

-- Trip 3: international + Spain waters
INSERT INTO records(cni, start_date, take_off_date, sequence, jurisdiction_name) VALUES
('PT-BOAT-002', DATE '2024-08-01', DATE '2024-08-02', 1, 'International Waters'),
('PT-BOAT-002', DATE '2024-08-01', DATE '2024-08-02', 2, 'Spain Territorial Waters');

-- Trip 4: river only
INSERT INTO records(cni, start_date, take_off_date, sequence, jurisdiction_name) VALUES
('PT-BOAT-003', DATE '2024-07-20', DATE '2024-07-20', 1, 'Douro River');


-- DEFINE TABLE
INSERT INTO define(long, lat, name) VALUES
(-9.142685, 38.736946, 'Lisbon Marina'),
(-8.653784, 41.141376, 'Porto Marina'),
(-7.937000, 37.016000, 'Faro Marina'),
(-16.000000, 32.650000, 'Madeira Marina');


