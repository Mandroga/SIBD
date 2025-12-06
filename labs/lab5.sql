CREATE TABLE Employee(
    eid INTEGER,
    name VARCHAR(80) NOT NULL,
    birthdate DATE NOT NULL,
    PRIMARY KEY(eid)
);

CREATE TABLE Department(
    did INTEGER,
    name VARCHAR(80) NOT NULL,
    budget NUMERIC(16,4) NOT NULL,
    PRIMARY KEY(did),
    UNIQUE(name)
);

CREATE TABLE works_at(
    eid INTEGER,
    did INTEGER,
    since DATE NOT NULL,
    PRIMARY KEY(eid),
    FOREIGN KEY(eid) REFERENCES Employee(eid),
    FOREIGN KEY(did) REFERENCES Department(did)
);

CREATE TABLE Freelancer(
    eid INTEGER,
    job VARCHAR(50),
    hour_rate NUMERIC(16,4) NOT NULL,
    PRIMARY KEY(eid),
    FOREIGN KEY(eid) REFERENCES Employee(eid)
);

CREATE TABLE Permanent(
    eid INTEGER,
    PRIMARY KEY(eid),
    FOREIGN KEY(eid) REFERENCES Employee(eid)
);

CREATE TABLE Contracted(
    eid INTEGER,
    role varchar(80),
    salary NUMERIC(16,4) NOT NULL,
    PRIMARY KEY(eid, role),
    FOREIGN KEY(eid) REFERENCES Permanent(eid)
);