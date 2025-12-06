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
cni INTEGER, --
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
cni INTEGER,
start_date DATE,
end_date DATE NOT NULL,
responsible_for_sid INTEGER,
PRIMARY KEY(cni, start_date),
FOREIGN KEY(cni) REFERENCES Boat(cni),
FOREIGN KEY(responsible_for_sid) REFERENCES Sailor(sid), -- IC4
CHECK (start_date <= end_date) -- IC12
);

CREATE TABLE authorized_for -- MANDATORY! IC! IC5
(
cni INTEGER,
start_date DATE,
sid INTEGER,
PRIMARY KEY(sid, cni, start_date),
FOREIGN KEY(sid) REFERENCES Sailor(sid),
FOREIGN KEY(cni, start_date) REFERENCES Reservation(cni, start_date)
-- Mandatory reservation side
);

CREATE TABLE Trip -- IC! IC6, IC11, IC14, IC15
(
cni INTEGER,
start_date DATE,
take_off_date DATE,
arrival_date DATE,
ins_ref INTEGER,
PRIMARY KEY(cni, start_date, take_off_date),
CHECK (take_off_date <= arrival_date)
);

CREATE TABLE registers -- TYPE! MANDATORY! IC! IC8
(
cni INTEGER,
iso INTEGER,
year DATE,
PRIMARY KEY(cni, iso),
FOREIGN KEY(cni) REFERENCES Boat(cni),
FOREIGN KEY(iso) REFERENCES Country(iso)
-- mandatory boat side
);

CREATE TABLE starts_ends -- MANDATORY!
(
cni INTEGER,
start_date DATE,
take_off_date DATE,

start_long NUMERIC(12,4),
end_long NUMERIC(12,4),
start_lat NUMERIC(12,4),
end_lat NUMERIC(12,4),
PRIMARY KEY(cni, start_date, take_off_date, start_long, start_lat, end_long, end_long)
-- mandatory trip side
);

CREATE TABLE for -- IC!, MANDATORY!, IC9, IC10
(
sid INTEGER,
issue_date DATE,
class_name VARCHAR(255),
jurisdiction_name VARCHAR(255),
PRIMARY KEY(sid, issue_date, class_name, jurisdiction_name),
FOREIGN KEY(sid, issue_date) REFERENCES Certification(sid, issue_date),
FOREIGN KEY(class_name) REFERENCES Class(name),
FOREIGN KEY(jurisdiction_name) REFERENCES Jurisdiction(name)
-- mandatory certification side
);

CREATE TABLE country(
	iso_code CHAR(3),
	name VARCHAR(60) NOT NULL,
	flag VARCHAR(300),
	PRIMARY KEY(iso_code)
)

CREATE TABLE class(
	name VARCHAR(15),
	max_length(6,2) NOT NULL,
	PRIMARY KEY(name)
)

CREATE TABLE jurisdiction(
	name VARCHAR(50),
	PRIMARY KEY(name)
)

CREATE TABLE international_jurisdiction(
	name VARCHAR(50),
	PRIMARY KEY(name),
	FOREIGN KEY(name) REFERENCES jurisdiction(name)
)

CREATE TABLE national_jurisdiction(
	name VARCHAR(50),
	country_code CHAR(3) NOT NULL,
	PRIMARY KEY(name),
	FOREIGN KEY(name) REFERENCES jurisdiction(name),
	FOREIGN KEY(country_code) REFERENCES country(iso_code)
)

CREATE TABLE is_skipper_for(
	sid INTEGER,
	cni INTEGER,
    start_date DATE,
    take_off_date DATE,
    PRIMARY KEY(sid, cni, start_date, take_off_date),
    FOREIGN KEY(sid) REFERENCES sailor(sid),
    FOREIGN KEY(cni, start_date, take_off_date) REFERENCES trip(cni, start_date, take_off_date)
)   

CREATE TABLE records(
    cni INTEGER,
    start_date DATE,
    take_off_date DATE,
    sequence INTEGER,
    jurisdiction_name VARCHAR(50),
    PRIMARY KEY(cni, start_date, take_off_date, jurisdiction_name),
    FOREIGN KEY(cni, start_date, take_off_date) REFERENCES trip(cni, start_date, take_off_date),
    FOREIGN KEY(jurisdiction_name) REFERENCES jurisdiction(name)
)
