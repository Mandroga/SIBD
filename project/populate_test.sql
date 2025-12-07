-- Country
INSERT INTO Country(iso_code, name, flag) VALUES ('XXX','xxx','https://flagcdn.com/w320/pt.png');
INSERT INTO Country(iso_code, name, flag) VALUES ('XXX','Portugal','xxx');
INSERT INTO Country(iso_code, name, flag) VALUES ('', '',''); -- PROBLEM!
-- We need to check if its empty string, do we need to check if its a valid ISO, name or link ?

-- Jurisdiction
INSERT INTO Jurisdiction(name) VALUES (''); -- PROBLEM?

-- International Jurisdiction
INSERT INTO International_Jurisdiction(name) VALUES ('Venezuelan EEZ'); -- PROBLEM!

-- National Jurisdiction
                                                                        -- Shouldnt be allowed
INSERT INTO National_Jurisdiction(name, belongs_to_iso) VALUES ('English Internal Waters','SPN'); -- PROBLEM?
INSERT INTO National_Jurisdiction(name, belongs_to_iso) VALUES ('xxx','xxx');
INSERT INTO National_Jurisdiction(name, belongs_to_iso) VALUES ('','');
INSERT INTO National_Jurisdiction(name, belongs_to_iso) VALUES ('Venezuelan EEZ','xxx');

-- Class
INSERT INTO Class(name, max_length) VALUES (NULL, NULL);
INSERT INTO Class(name, max_length) VALUES ('Class 5', NULL);
INSERT INTO Class(name, max_length) VALUES (NULL, 5);
INSERT INTO Class(name, max_length) VALUES ('Class 4', 5);
INSERT INTO Class(name, max_length) VALUES ('Class 5', -1); -- PROBLEM!
INSERT INTO Class(name, max_length) VALUES ('Class 6', 0); -- PROBLEM!
INSERT INTO Class(name, max_length) VALUES ('', 1000); -- PROBLEM?
INSERT INTO Class(name, max_length) VALUES ('Class 7', 001);

-- Location
INSERT INTO Location(long, lat, name) VALUES (90, 180, '');
INSERT INTO Location(long, lat, name) VALUES (-90, -180, '');
INSERT INTO Location(long, lat, name) VALUES (-100, 180, '');
INSERT INTO Location(long, lat, name) VALUES (-90, 190, ''); -- PROBLEM!
INSERT INTO Location(long, lat, name) VALUES (-16.000000, 32.650000, 'Madeira Marina2');
INSERT INTO Location(long, lat, name) VALUES (-16.0000001, 32.650000, 'Madeira Marina2');

-- Sailor
INSERT INTO Sailor(sid, first_name, surname, email) VALUES (NULL, NULL, NULL, NULL);
INSERT INTO Sailor(sid, first_name, surname, email) VALUES (1, '', '', '');
INSERT INTO Sailor(sid, first_name, surname, email) VALUES (6, '', '', '');-- PROBLEM?
INSERT INTO Sailor(sid, first_name, surname, email) VALUES (7, 'xx', 'xx', 'def not an email'); -- PROBLEM?
INSERT INTO Sailor(sid, first_name, surname, email) VALUES (-1, '', '', 'xa'); -- PROBLEM?
INSERT INTO Sailor(sid, first_name, surname, email) VALUES ( 8, '123', '123', 'xxaa');

-- Certification
INSERT INTO Certification(sid, issue_date, expiry_date) VALUES
(4, DATE '2024-03-01', DATE '2024-01-30');