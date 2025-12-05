

-- MANDATORY!, TYPE!, IC!
CREATE TABLE Location -- TYPE!
(
long NUMERIC(12,4),
lat NUMERIC(12,4),
name VARCHAR(255),
PRIMARY KEY(long, lat)
);

CREATE TABLE Boat -- TYPE!
(
cni INTEGER, --
picture_path VARCHAR(255),
lenght NUMERIC(12,4),
name VARCHAR(255),
PRIMARY KEY(cni)
);

CREATE TABLE Sailor -- IC1
(
sid INTEGER,
first_name VARCHAR(255),
surname VARCHAR(255),
email VARCHAR(255),
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
expiry_date DATE,
PRIMARY KEY(sid, issue_date),
FOREIGN KEY(sid) REFERENCES Sailor(sid)
);

CREATE TABLE Reservation -- IC4, IC6, IC12, IC13, IC15 IC!
(
cni INTEGER,
start_date DATE,
end_date DATE,
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