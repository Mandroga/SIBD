---------------------------------------
-- Countries
---------------------------------------
-- Country flags (real URLs)
INSERT INTO Country(iso_code, name, flag) VALUES
('PTR', 'Portugal', 'https://flagcdn.com/w320/pt.png', ),
('GBN', 'United Kingdom', 'https://flagcdn.com/w320/gb.png'),
('BMU', 'Bermuda', 'https://flagcdn.com/w320/bm.png');

---------------------------------------
-- Jurisdictions
---------------------------------------
INSERT INTO Jurisdiction(name) VALUES
('International Waters'),
('Portuguese EEZ'),
('Portuguese Territorial Sea'),
('Spanish EEZ'),
('Spanish Territorial Sea'),
('Spanish Internal Waters');

---------------------------------------
-- International / National Jurisdictions
---------------------------------------
INSERT INTO International_Jurisdiction(name) VALUES
('International Waters');

INSERT INTO National_Jurisdiction(name, belongs_to_iso) VALUES
('Portugal Territorial Waters', 'PT'),
('Douro River', 'PT'),
('Ria Formosa Lagoon', 'PT'),
('UK Territorial Waters', 'GB');

---------------------------------------
-- Classes
---------------------------------------
INSERT INTO Class(name, max_length) VALUES
('Dinghy', 6.00),
('Cruiser 30', 9.50),
('Cruiser 40', 12.00),
('Optimist', 2.50);

---------------------------------------
-- Locations
---------------------------------------
INSERT INTO Location(long, lat, name) VALUES
(-9.142685, 38.736946, 'Lisbon Marina'),
(-8.653784, 41.141376, 'Porto Marina'),
(-7.937000, 37.016000, 'Faro Marina'),
(-16.000000, 32.650000, 'Madeira Marina');

---------------------------------------
-- Sailors
---------------------------------------
INSERT INTO Sailor(sid, first_name, surname, email) VALUES
(1, 'Ana',   'Silva',     'ana.silva@example.com'),
(2, 'Bruno', 'Costa',     'bruno.costa@example.com'),
(3, 'Carla', 'Ferreira',  'carla.ferreira@example.com'),
(4, 'Daniel','Pereira',   'daniel.pereira@example.com'),
(5, 'Eva',   'Santos',    'eva.santos@example.com');

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
-- Bruno: valid Cruiser 30 cert (multi-jurisdiction)
INSERT INTO Certification(sid, issue_date, expiry_date, for_class_name) VALUES
(2, DATE '2023-01-01', DATE '2026-12-31', 'Cruiser 30');

-- Bruno: old expired Dinghy cert
INSERT INTO Certification(sid, issue_date, expiry_date, for_class_name) VALUES
(2, DATE '2020-01-01', DATE '2020-12-31', 'Dinghy');

-- Carla: Cruiser 40 cert
INSERT INTO Certification(sid, issue_date, expiry_date, for_class_name) VALUES
(3, DATE '2022-06-15', DATE '2025-06-14', 'Cruiser 40');

-- Ana (junior): Optimist cert for rivers
INSERT INTO Certification(sid, issue_date, expiry_date, for_class_name) VALUES
(1, DATE '2024-03-01', DATE '2024-09-30', 'Optimist');

---------------------------------------
-- enables (Certification ↔ Jurisdictions)
---------------------------------------
-- Bruno, Cruiser 30 (offshore + coastal)
INSERT INTO enables(sid, issue_date, name) VALUES
(2, DATE '2023-01-01', 'International Waters'),
(2, DATE '2023-01-01', 'Portugal Territorial Waters');

-- Bruno, expired Dinghy cert (river only)
INSERT INTO enables(sid, issue_date, name) VALUES
(2, DATE '2020-01-01', 'Douro River');

-- Carla, Cruiser 40, international + UK waters
INSERT INTO enables(sid, issue_date, name) VALUES
(3, DATE '2022-06-15', 'International Waters'),
(3, DATE '2022-06-15', 'UK Territorial Waters');

-- Ana, Optimist, river only
INSERT INTO enables(sid, issue_date, name) VALUES
(1, DATE '2024-03-01', 'Douro River');

---------------------------------------
-- Boats (one without class to test NULL of_class_name)
---------------------------------------
INSERT INTO Boat(cni, picture_path, length, name, of_class_name) VALUES
('PT-BOAT-001', '/img/boats/pt-boat-001.jpg',  9.30, 'Lusitania',      'Cruiser 30'),
('PT-BOAT-002', '/img/boats/pt-boat-002.jpg', 11.80, 'Atlantico',      'Cruiser 40'),
('PT-BOAT-003', '/img/boats/pt-boat-003.jpg',  5.50, 'Gaivota',        'Dinghy'),
('BM-BOAT-004', '/img/boats/bm-boat-004.jpg',  9.20, 'Ocean Breeze',   NULL);

---------------------------------------
-- Reservations (including overlaps and unused)
---------------------------------------
-- Lusitania: long reservation, many authorized sailors, one main trip
INSERT INTO Reservation(cni, start_date, end_date, responsible_for_sid) VALUES
('PT-BOAT-001', DATE '2024-07-01', DATE '2024-07-10', 2);

-- Lusitania: overlapping reservation with different responsible
INSERT INTO Reservation(cni, start_date, end_date, responsible_for_sid) VALUES
('PT-BOAT-001', DATE '2024-07-05', DATE '2024-07-08', 3);

-- Atlantico: single longer reservation
INSERT INTO Reservation(cni, start_date, end_date, responsible_for_sid) VALUES
('PT-BOAT-002', DATE '2024-08-01', DATE '2024-08-15', 3);

-- Gaivota: short reservation, day-trips on river
INSERT INTO Reservation(cni, start_date, end_date, responsible_for_sid) VALUES
('PT-BOAT-003', DATE '2024-07-20', DATE '2024-07-22', 5);

-- Ocean Breeze: reserved but (for now) no trips
INSERT INTO Reservation(cni, start_date, end_date, responsible_for_sid) VALUES
('BM-BOAT-004', DATE '2024-09-01', DATE '2024-09-30', 5);

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
    cni, start_date, take_off_date, arrival_date,
    ins_ref, is_skipper_for_id, is_skipper_for_start_date, is_skipper_for_cni
) VALUES (
    'PT-BOAT-001',
    DATE '2024-07-01',
    DATE '2024-07-02',
    DATE '2024-07-09',
    1001,
    2,                   -- Bruno
    DATE '2024-07-01',
    'PT-BOAT-001'
);

-- Trip 2: Lusitania, short overlapping reservation with Carla as skipper
INSERT INTO Trip(
    cni, start_date, take_off_date, arrival_date,
    ins_ref, is_skipper_for_id, is_skipper_for_start_date, is_skipper_for_cni
) VALUES (
    'PT-BOAT-001',
    DATE '2024-07-05',
    DATE '2024-07-06',
    DATE '2024-07-08',
    1002,
    3,                   -- Carla
    DATE '2024-07-05',
    'PT-BOAT-001'
);

-- Trip 3: Atlantico, longer cruise with Carla
INSERT INTO Trip(
    cni, start_date, take_off_date, arrival_date,
    ins_ref, is_skipper_for_id, is_skipper_for_start_date, is_skipper_for_cni
) VALUES (
    'PT-BOAT-002',
    DATE '2024-08-01',
    DATE '2024-08-02',
    DATE '2024-08-14',
    2001,
    3,                   -- Carla
    DATE '2024-08-01',
    'PT-BOAT-002'
);

-- Trip 4: Gaivota, day-trip on Douro River with Eva
INSERT INTO Trip(
    cni, start_date, take_off_date, arrival_date,
    ins_ref, is_skipper_for_id, is_skipper_for_start_date, is_skipper_for_cni
) VALUES (
    'PT-BOAT-003',
    DATE '2024-07-20',
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

-- Trip 3: international + UK waters
INSERT INTO records(cni, start_date, take_off_date, sequence, jurisdiction_name) VALUES
('PT-BOAT-002', DATE '2024-08-01', DATE '2024-08-02', 1, 'International Waters'),
('PT-BOAT-002', DATE '2024-08-01', DATE '2024-08-02', 2, 'UK Territorial Waters');

-- Trip 4: river only
INSERT INTO records(cni, start_date, take_off_date, sequence, jurisdiction_name) VALUES
('PT-BOAT-003', DATE '2024-07-20', DATE '2024-07-20', 1, 'Douro River');
