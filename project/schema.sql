

CREATE TABLE Location 
(
long NUMERIC(9,6),
lat NUMERIC(8,6),
name VARCHAR(255) NOT NULL
PRIMARY KEY(long, lat)
);

CREATE TABLE Country(
	iso_code VARCHAR(5),
	name VARCHAR(60) NOT NULL,
	flag VARCHAR(2083) NOT NULL,
    UNIQUE(name), --IC2
    UNIQUE (flag), --IC3
	PRIMARY KEY(iso_code)
);

CREATE TABLE Class(
	name VARCHAR(80),
	max_length NUMERIC(6,2) NOT NULL,
	PRIMARY KEY(name),
    UNIQUE(name, max_length) -- primary key makes this combination unique, but its written explicitly for the dbms to accept it as a foreign key
);

CREATE TABLE Boat -- TYPE!
(
cni VARCHAR(25), --
picture_path VARCHAR(2083) NOT NULL,
length NUMERIC(6,2) NOT NULL,
name VARCHAR(255) NOT NULL,
class_name VARCHAR(80),
registered_iso VARCHAR(5),
class_max_length NUMERIC(6,2),
year INTEGER NOT NULL,
PRIMARY KEY(cni),
FOREIGN KEY (class_name, class_max_length) REFERENCES Class(name,max_length),
FOREIGN KEY (registered_iso) REFERENCES Country(iso_code),
CHECK (length <= class_max_length) --IC16
);

CREATE TABLE Sailor -- IC1
(
sid INTEGER,
first_name VARCHAR(50) NOT NULL,
surname VARCHAR(80) NOT NULL,
email VARCHAR(254) NOT NULL,
PRIMARY KEY(sid),
UNIQUE(email) --IC1
-- Every sailor must be either Junior or Senior
-- (CAN NOT BE BOTH)
);

CREATE TABLE Junior_Sailor
(
sid INTEGER,
PRIMARY KEY(sid),
FOREIGN KEY(sid) REFERENCES Sailor(sid)
);

CREATE TABLE Senior_Sailor
(
sid INTEGER,
PRIMARY KEY(sid),
FOREIGN KEY(sid) REFERENCES Sailor(sid)
);

CREATE TABLE Certification 
(
sid INTEGER,
issue_date DATE,
expiry_date DATE NOT NULL,
PRIMARY KEY(sid, issue_date),
FOREIGN KEY(sid) REFERENCES Sailor(sid),
CHECK (issue_date <= expiry_date)
-- IC9:
-- The sailor that is skipper for a trip must
-- hold a certification for the class of the boat
-- used on the reservation which the trip is associated to.
);

CREATE TABLE Reservation 
(
cni VARCHAR(25),
start_date DATE,
end_date DATE NOT NULL,
PRIMARY KEY(cni, start_date),
UNIQUE(cni, start_date, end_date), -- primary key makes this combination unique, but its written explicitly for the dbms to accept it as a foreign key
FOREIGN KEY(cni) REFERENCES Boat(cni),
CHECK(start_date <= end_date) --IC12
);


CREATE TABLE authorized_for 
(
cni VARCHAR(25),
start_date DATE,
sid INTEGER,
PRIMARY KEY(cni, start_date, sid),
FOREIGN KEY(sid) REFERENCES Sailor(sid),
FOREIGN KEY(cni, start_date) REFERENCES Reservation(cni, start_date)
-- Every reservation must have at least one sailor
);

CREATE TABLE responsible_for
(
cni VARCHAR(25),
start_date DATE,
responsible_sid INTEGER,
PRIMARY KEY(cni, start_date, responsible_sid),
FOREIGN KEY (cni, start_date, responsible_sid)
    REFERENCES authorized_for(cni, start_date, sid),  -- IC4 - enforces the person is authorized for that reservation
FOREIGN KEY (cni, start_date) REFERENCES Reservation(cni, start_date),
FOREIGN KEY (responsible_sid) REFERENCES Senior_Sailor(sid)
-- Every reservation must have at least one responsible senior sailor
);

CREATE TABLE Trip 
(
cni VARCHAR(25),
start_date DATE,
end_date DATE,
take_off_date DATE,
arrival_date DATE NOT NULL,
ins_ref INTEGER NOT NULL,
is_skipper_for_sid INTEGER,
is_skipper_for_start_date DATE,
is_skipper_for_cni VARCHAR(25),
PRIMARY KEY(cni, start_date, take_off_date),
FOREIGN KEY (cni, start_date, end_date) REFERENCES Reservation(cni,start_date,end_date),
FOREIGN KEY (is_skipper_for_sid, is_skipper_for_start_date, is_skipper_for_cni)
    REFERENCES authorized_for(sid, start_date, cni),
CHECK(cni = is_skipper_for_cni), --IC5
CHECK(start_date = is_skipper_for_start_date), --IC5
CHECK(take_off_date BETWEEN start_date AND end_date), -- IC6
CHECK(arrival_date BETWEEN start_date AND end_date), --IC6
CHECK(take_off_date <= arrival_date) -- IC14

-- IC9:
-- The sailor that is skipper for a trip must
-- hold a certification for the class of the boat
-- used on the reservation which the trip is associated to.
);


-- WOULD WORK AND WOULD BE MUCH CLEANERRRRR
--CREATE TABLE Trip
--(
--  cni                 VARCHAR(25),
--  start_date          DATE       ,
--  take_off_date       DATE ,
-- arrival_date        DATE  NOT NULL       ,
--  ins_ref             INTEGER     NOT NULL,
--  skipper_sid         INTEGER    ,
--  PRIMARY KEY (cni, start_date, take_off_date),
--  FOREIGN KEY (cni, start_date) REFERENCES Reservation(cni, start_date),
--  FOREIGN KEY (cni, start_date, skipper_sid)
--    REFERENCES authorized_for(cni, start_date, sid),
--);
--


CREATE TABLE starts_ends -- MANDATORY!
(
cni VARCHAR(25),
start_date DATE,
take_off_date DATE,
start_long NUMERIC(9,6),
end_long NUMERIC(9,6),
start_lat NUMERIC(8,6),
end_lat NUMERIC(8,6),
PRIMARY KEY (cni, start_date, take_off_date, start_long, start_lat, end_long, end_lat),
FOREIGN KEY (cni,start_date,take_off_date) REFERENCES Trip(cni,start_date,take_off_date),
FOREIGN KEY (start_long,start_lat) REFERENCES Location(long,lat),
FOREIGN KEY (end_long, end_lat) REFERENCES Location(long,lat)
-- Every trip must have at least one start and end location.

-- IC7:
-- Every pair of rows must be at least 1 nautical mile apart
-- (We can not model this with a single simple CHECK because
-- it needs to compare a row to other rows -> NEED TRIGGERS)
);






CREATE TABLE Jurisdiction(
	name VARCHAR(80),
	PRIMARY KEY(name)
    -- Every jurisdiction is either International or National
    -- (CAN NOT BE BOTH)
);

CREATE TABLE enables(
    sid INTEGER,
    issue_date DATE,
    jurisdiction_name VARCHAR(80),
    class_name VARCHAR(80),
    PRIMARY KEY (sid, issue_date, jurisdiction_name, class_name),
    FOREIGN KEY (sid, issue_date) REFERENCES Certification(sid, issue_date),
    FOREIGN KEY (jurisdiction_name) REFERENCES Jurisdiction(name),
    FOREIGN KEY (class_name) REFERENCES Class(name)
    -- Every certification must have at least one Jurisdiction defined
);

CREATE TABLE International_Jurisdiction(
	name VARCHAR(80),
	PRIMARY KEY(name),
	FOREIGN KEY(name) REFERENCES Jurisdiction(name)
);

CREATE TABLE National_Jurisdiction(
	name VARCHAR(80),
	administrated_by_iso VARCHAR(5),
	PRIMARY KEY(name),
	FOREIGN KEY(name) REFERENCES Jurisdiction(name),
	FOREIGN KEY(administrated_by_iso) REFERENCES Country(iso_code)

);

CREATE TABLE records(
    cni VARCHAR(25),
    start_date DATE,
    take_off_date DATE,
    sequence INTEGER,
    jurisdiction_name VARCHAR(80),
    PRIMARY KEY(cni, start_date, take_off_date, jurisdiction_name),
    FOREIGN KEY(cni, start_date, take_off_date) REFERENCES Trip(cni, start_date, take_off_date),
    FOREIGN KEY(jurisdiction_name) REFERENCES Jurisdiction(name)
    -- Every trip must have at least one jurisdiction recorded
);


CREATE TABLE define(
    long NUMERIC(9,6),
    lat NUMERIC(8,6),
    country_name VARCHAR(60),
    PRIMARY KEY (long,lat),
    FOREIGN KEY (long,lat) REFERENCES Location(long,lat),
    FOREIGN KEY (country_name) REFERENCES Country(name)
    -- IC8:
    -- Every country that registers a boat must have
    -- at least one location defined.
);
