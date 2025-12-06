-- MANDATORY!, TYPE!, IC!
CREATE TABLE Location -- TYPE!
(
long NUMERIC(8,6),
lat NUMERIC(9,6),
name VARCHAR(255) NOT NULL,
PRIMARY KEY(long, lat)
);

CREATE TABLE Boat -- TYPE!
(
cni VARCHAR(25), --
picture_path VARCHAR(2083) NOT NULL,
length NUMERIC(6,2) NOT NULL,
name VARCHAR(255) NOT NULL,
PRIMARY KEY(cni)
);

CREATE TABLE Sailor -- IC1
(
sid INTEGER,
first_name VARCHAR(50) NOT NULL,
surname VARCHAR(80) NOT NULL,
email VARCHAR(254) NOT NULL,
PRIMARY KEY(sid),
UNIQUE(email)
);

CREATE TABLE Junior -- Sailor disjoint specialization
(
sid INTEGER,
PRIMARY KEY(sid),
FOREIGN KEY(sid) REFERENCES Sailor(sid)
);

CREATE TABLE Senior -- Sailor disjoint specialization
(
sid INTEGER,
PRIMARY KEY(sid),
FOREIGN KEY(sid) REFERENCES Sailor(sid)
);

CREATE TABLE Certification -- TYPE! A certification is the permitions the sailor has during valid dates for skipping with the given combination of class and jurisdictions
-- IC9, IC10, IC11
(
sid INTEGER,
issue_date DATE,
expiry_date DATE NOT NULL,
PRIMARY KEY(sid, issue_date),
FOREIGN KEY(sid) REFERENCES Sailor(sid)
);

CREATE TABLE Reservation -- IC4, IC6, IC12, IC13, IC15 IC!
(
cni VARCHAR(25),
start_date DATE,
end_date DATE NOT NULL,
responsible_for_sid INTEGER,
PRIMARY KEY(cni, start_date),
FOREIGN KEY(cni) REFERENCES Boat(cni),
FOREIGN KEY(responsible_for_sid) REFERENCES Senior(sid), -- IC4
-- CHECK (start_date <= end_date) -- IC12
);

CREATE TABLE authorized_for -- MANDATORY! IC! IC5
(
cni VARCHAR(25),
start_date DATE,
sid INTEGER,
PRIMARY KEY(sid, cni, start_date),
FOREIGN KEY(sid) REFERENCES Sailor(sid),
FOREIGN KEY(cni, start_date) REFERENCES Reservation(cni, start_date)
-- Mandatory reservation side
);

CREATE TABLE Trip -- IC! IC6, IC11, IC14, IC15
(
cni VARCHAR(25),
start_date DATE,
take_off_date DATE,
arrival_date DATE NOT NULL,
ins_ref INTEGER NOT NULL,
PRIMARY KEY(cni, start_date, take_off_date),
FOREIGN KEY (cni, start_date) REFERENCES Reservation(cni,start_date),
--CHECK (take_off_date <= arrival_date)
);

CREATE TABLE registers -- TYPE! MANDATORY! IC! IC8
(
cni VARCHAR(25),
iso VARCHAR(5),
year DATE NOT NULL,
PRIMARY KEY(cni, iso),
FOREIGN KEY(cni) REFERENCES Boat(cni),
FOREIGN KEY(iso) REFERENCES Country(iso)
-- mandatory boat side
);

CREATE TABLE starts_ends -- MANDATORY!
(
cni VARCHAR(25),
start_date DATE,
take_off_date DATE,
start_long NUMERIC(9,6),
end_long NUMERIC(9,6),
start_lat NUMERIC(8,6),
end_lat NUMERIC(8,6),
PRIMARY KEY (cni, start_date, take_off_date, start_long, start_lat, end_long, end_long),
FOREIGN KEY (cni,start_date,take_off_date) REFERENCES Trip(cni,start_date,take_off_date),
FOREIGN KEY (start_long,start_lat) REFERENCES Location(long,lat),
FOREIGN KEY (end_long, end_lat) REFERENCES Location(long,lat)
-- mandatory trip side
);

CREATE TABLE for -- IC!, MANDATORY!, IC9, IC10
(
sid INTEGER,
issue_date DATE,
class_name VARCHAR(80),
jurisdiction_name VARCHAR(80),
PRIMARY KEY(sid, issue_date, class_name, jurisdiction_name),
FOREIGN KEY(sid, issue_date) REFERENCES Certification(sid, issue_date),
FOREIGN KEY(class_name) REFERENCES Class(name),
FOREIGN KEY(jurisdiction_name) REFERENCES Jurisdiction(name)
-- mandatory certification side
);

CREATE TABLE country(
	iso_code VARCHAR(5),
	name VARCHAR(60) NOT NULL,
	flag VARCHAR(2083) NOT NULL,
    UNIQUE(name),
    UNIQUE (flag),
	PRIMARY KEY(iso_code)
)

CREATE TABLE Class(
	name VARCHAR(80),
	max_length(6,2) NOT NULL,
	PRIMARY KEY(name)
)

CREATE TABLE Jurisdiction(
	name VARCHAR(80),
	PRIMARY KEY(name)
)

CREATE TABLE International_Jurisdiction(
	name VARCHAR(80),
	PRIMARY KEY(name),
	FOREIGN KEY(name) REFERENCES Jurisdiction(name)
)

CREATE TABLE National_Jurisdiction(
	name VARCHAR(80),
	belongs_to_iso VARCHAR(5),
	PRIMARY KEY(name),
	FOREIGN KEY(name) REFERENCES Jurisdiction(name),
	FOREIGN KEY(belongs_to_iso) REFERENCES Country(iso_code)
)

CREATE TABLE is_skipper_for(
	sid INTEGER,
	cni VARCHAR(25),
    start_date DATE,
    take_off_date DATE,
    PRIMARY KEY(sid, cni, start_date, take_off_date),
    FOREIGN KEY(sid) REFERENCES sailor(sid),
    FOREIGN KEY(cni, start_date, take_off_date) REFERENCES trip(cni, start_date, take_off_date)
    -- Mandatory aaaa
)   

CREATE TABLE records(
    cni VARCHAR(25),
    start_date DATE,
    take_off_date DATE,
    sequence INTEGER,
    jurisdiction_name VARCHAR(80),
    PRIMARY KEY(cni, start_date, take_off_date, jurisdiction_name),
    FOREIGN KEY(cni, start_date, take_off_date) REFERENCES trip(cni, start_date, take_off_date),
    FOREIGN KEY(jurisdiction_name) REFERENCES jurisdiction(name)
    -- MANDATORYYYY
)
