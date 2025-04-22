-- Aircraft Management System SQL Schema and Sample Data

-- Table: Aircraft
CREATE TABLE Aircraft (
    aircraft_id SERIAL PRIMARY KEY,
    model VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    registration_number VARCHAR(50) UNIQUE NOT NULL
);

-- Table: Maintenance
CREATE TABLE Maintenance (
    maintenance_id SERIAL PRIMARY KEY,
    aircraft_id INT NOT NULL,
    maintenance_date DATE NOT NULL,
    description TEXT,
    FOREIGN KEY (aircraft_id) REFERENCES Aircraft(aircraft_id) ON DELETE CASCADE
);

-- Table: Flights
CREATE TABLE Flights (
    flight_id SERIAL PRIMARY KEY,
    flight_number VARCHAR(20) UNIQUE NOT NULL,
    origin VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    aircraft_id INT NOT NULL,
    scheduled_departure TIMESTAMP NOT NULL,
    scheduled_arrival TIMESTAMP NOT NULL,
    FOREIGN KEY (aircraft_id) REFERENCES Aircraft(aircraft_id) ON DELETE SET NULL
);

-- Table: Crew
CREATE TABLE Crew (
    crew_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(50) NOT NULL
);

-- Table: FlightCrewAssignments
CREATE TABLE FlightCrewAssignments (
    assignment_id SERIAL PRIMARY KEY,
    flight_id INT NOT NULL,
    crew_id INT NOT NULL,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id) ON DELETE CASCADE,
    FOREIGN KEY (crew_id) REFERENCES Crew(crew_id) ON DELETE CASCADE
);

-- Sample Data Inserts

-- Aircraft
INSERT INTO Aircraft (model, manufacturer, capacity, registration_number) VALUES
('Boeing 737', 'Boeing', 160, 'N73701'),
('Airbus A320', 'Airbus', 150, 'N32001'),
('Cessna 172', 'Cessna', 4, 'N17201');

-- Maintenance
INSERT INTO Maintenance (aircraft_id, maintenance_date, description) VALUES
(1, '2024-01-15', 'Engine check and oil change'),
(2, '2024-02-10', 'Landing gear inspection'),
(3, '2024-03-05', 'Annual safety inspection');

-- Flights
INSERT INTO Flights (flight_number, origin, destination, aircraft_id, scheduled_departure, scheduled_arrival) VALUES
('AA101', 'New York', 'Los Angeles', 1, '2024-06-01 08:00:00', '2024-06-01 11:00:00'),
('BA202', 'London', 'Paris', 2, '2024-06-02 09:00:00', '2024-06-02 10:30:00'),
('CA303', 'San Francisco', 'Seattle', 3, '2024-06-03 07:00:00', '2024-06-03 08:30:00');

-- Crew
INSERT INTO Crew (first_name, last_name, role) VALUES
('John', 'Doe', 'Pilot'),
('Jane', 'Smith', 'Co-Pilot'),
('Emily', 'Johnson', 'Flight Attendant');

-- Flight Crew Assignments
INSERT INTO FlightCrewAssignments (flight_id, crew_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 3),
(3, 2),
(3, 3);

-- Example Queries

-- List all flights with aircraft model and capacity
SELECT f.flight_number, f.origin, f.destination, a.model, a.capacity
FROM Flights f
JOIN Aircraft a ON f.aircraft_id = a.aircraft_id;

-- Get maintenance history for a specific aircraft
SELECT m.maintenance_date, m.description
FROM Maintenance m
JOIN Aircraft a ON m.aircraft_id = a.aircraft_id
WHERE a.registration_number = 'N73701'
ORDER BY m.maintenance_date DESC;

-- List crew assigned to a specific flight
SELECT c.first_name, c.last_name, c.role
FROM Crew c
JOIN FlightCrewAssignments fca ON c.crew_id = fca.crew_id
JOIN Flights f ON fca.flight_id = f.flight_id
WHERE f.flight_number = 'AA101';
