-- Drop child tables first with CASCADE CONSTRAINTS
DROP TABLE Airline CASCADE CONSTRAINTS;

DROP TABLE Airport CASCADE CONSTRAINTS;

DROP TABLE Aircraft CASCADE CONSTRAINTS;

DROP TABLE Flight CASCADE CONSTRAINTS;

DROP TABLE Schedule CASCADE CONSTRAINTS;

DROP TABLE Passenger CASCADE CONSTRAINTS;

DROP TABLE PassengerPhoneNumber CASCADE CONSTRAINTS;

DROP TABLE Booking CASCADE CONSTRAINTS;

DROP TABLE Payment CASCADE CONSTRAINTS;

DROP TABLE Employee CASCADE CONSTRAINTS;

DROP TABLE Pilot CASCADE CONSTRAINTS;

DROP TABLE Crew CASCADE CONSTRAINTS;

DROP TABLE FlightAssignment CASCADE CONSTRAINTS;

DROP TABLE AIRLINE_USER CASCADE CONSTRAINTS;

-- 1. Airline
CREATE TABLE Airline (
    airline_id VARCHAR2(20) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    headquarters VARCHAR2(100),
    email VARCHAR2(100),
    phone_number VARCHAR2(20)
);

-- 2. Airport
CREATE TABLE Airport (
    airport_code VARCHAR2(10) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    city VARCHAR2(50),
    country VARCHAR2(50)
);

-- 3. Aircraft
CREATE TABLE Aircraft (
    aircraft_id VARCHAR2(20) PRIMARY KEY,
    model VARCHAR2(50),
    capacity NUMBER,
    airline_id VARCHAR2(20),
    FOREIGN KEY (airline_id) REFERENCES Airline(airline_id)
);

-- 4. Flight
CREATE TABLE Flight (
    flight_number VARCHAR2(10) PRIMARY KEY,
    departure_airport_code VARCHAR2(10),
    arrival_airport_code VARCHAR2(10),
    departure_time TIMESTAMP,
    arrival_time TIMESTAMP,
    aircraft_id VARCHAR2(20),
    airline_id VARCHAR2(20),
    flight_type VARCHAR2(20) CHECK (flight_type IN ('Domestic', 'International', 'Charter', 'Cargo')),
    FOREIGN KEY (departure_airport_code) REFERENCES Airport(airport_code),
    FOREIGN KEY (arrival_airport_code) REFERENCES Airport(airport_code),
    FOREIGN KEY (aircraft_id) REFERENCES Aircraft(aircraft_id),
    FOREIGN KEY (airline_id) REFERENCES Airline(airline_id)
);

-- 5. Schedule (Weak Entity of Flight)
CREATE TABLE Schedule (
    flight_number VARCHAR2(10),
    departure_date_time TIMESTAMP,
    arrival_date_time TIMESTAMP,
    gate_number VARCHAR2(10),
    status VARCHAR2(50),
    PRIMARY KEY (flight_number, departure_date_time,arrival_date_time,gate_number, status),
    FOREIGN KEY (flight_number) REFERENCES Flight(flight_number)
);

-- 6. Passenger
CREATE TABLE Passenger (
    passenger_id VARCHAR2(20) PRIMARY KEY,
    name VARCHAR2(100),
    date_of_birth DATE,
    email VARCHAR2(100),
    passport_no VARCHAR2(20) UNIQUE
);

-- 7. PassengerPhoneNumber (Multivalued Attribute)
CREATE TABLE PassengerPhoneNumber (
    passenger_id VARCHAR2(20),
    phone_number VARCHAR2(20),
    PRIMARY KEY (passenger_id, phone_number),
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id)
);

-- 8. Booking
CREATE TABLE Booking (
    booking_id VARCHAR2(20) PRIMARY KEY,
    passenger_id VARCHAR2(20),
    flight_number VARCHAR2(10),
    booking_date DATE,
    seat_number VARCHAR2(10),
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id),
    FOREIGN KEY (flight_number) REFERENCES flight(flight_number)
);

-- 9. Payment
CREATE TABLE Payment (
    payment_id VARCHAR2(20) PRIMARY KEY,
    booking_id VARCHAR2(20),
    payment_date DATE,
    amount NUMBER(3),
    payment_method VARCHAR2(50),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- 10. Employee (Superclass)
CREATE TABLE Employee (
    employee_id VARCHAR2(20) PRIMARY KEY,
    name VARCHAR2(100),
    hire_date DATE,
    role VARCHAR2(50),
    airline_id VARCHAR2(20),
    FOREIGN KEY (airline_id) REFERENCES Airline(airline_id)
);

-- 11. Pilot (Subclass of Employee)
CREATE TABLE Pilot (
    employee_id VARCHAR2(20) PRIMARY KEY,
    license_number VARCHAR2(50),
    ratings VARCHAR2(100),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

-- 12. Crew (Subclass of Employee)
CREATE TABLE Crew (
    employee_id VARCHAR2(20) PRIMARY KEY,
    position VARCHAR2(50),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

-- 13. FlightAssignment (Employee to Scheduled Flight)
CREATE TABLE FlightAssignment (
    flight_number VARCHAR2(10),
    employee_id VARCHAR2(20),
    PRIMARY KEY (flight_number,employee_id),
    FOREIGN KEY (flight_number) REFERENCES flight(flight_number),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

--14 User
CREATE TABLE AIRLINE_USER (
    user_id         INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    phone           VARCHAR(20),
    password        VARCHAR(255) NOT NULL,
    user_role VARCHAR2(20) CHECK (user_role IN ('admin', 'employee', 'passenger')),
    account_status  VARCHAR(20) DEFAULT 'active',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login      TIMESTAMP
);

-- 1. Airline
SELECT * FROM Airline;

-- 2. Airport
SELECT * FROM Airport;

-- 3. Aircraft
SELECT * FROM Aircraft;

-- 4. Flight
SELECT * FROM Flight;

-- 5. Schedule
SELECT * FROM Schedule;

-- 6. Passenger
SELECT * FROM Passenger;

-- 7. PassengerPhoneNumber
SELECT * FROM PassengerPhoneNumber;

-- 8. Booking
SELECT * FROM Booking;

-- 9. Payment
SELECT * FROM Payment;

-- 10. Employee
SELECT * FROM Employee;

-- 11. Pilot
SELECT * FROM Pilot;

-- 12. Crew
SELECT * FROM Crew;

-- 13. FlightAssignment
SELECT * FROM FlightAssignment;
--14. User
SELECT * FROM AIRLINE_USER;

-- 1. Airline
INSERT INTO Airline VALUES ('A001', 'SkyJet', 'New York', 'contact@skyjet.com', '111-222-3333');
INSERT INTO Airline VALUES ('A002', 'OceanAir', 'Los Angeles', 'info@oceanair.com', '222-333-4444');
INSERT INTO Airline VALUES ('A003', 'StarFly', 'London', 'support@starfly.co.uk', '333-444-5555');
INSERT INTO Airline VALUES ('A004', 'NimbusAir', 'Tokyo', 'hello@nimbusair.jp', '444-555-6666');
INSERT INTO Airline VALUES ('A005', 'BlueWings', 'Paris', 'contact@bluewings.fr', '555-666-7777');
INSERT INTO Airline VALUES ('A006', 'DesertWind', 'Dubai', 'info@desertwind.ae', '666-777-8888');
INSERT INTO Airline VALUES ('A007', 'AuroraFly', 'Toronto', 'support@aurorafly.ca', '777-888-9999');

-- 2. Airport
INSERT INTO Airport VALUES ('JFK', 'John F. Kennedy International', 'New York', 'USA');
INSERT INTO Airport VALUES ('LAX', 'Los Angeles International', 'Los Angeles', 'USA');
INSERT INTO Airport VALUES ('LHR', 'Heathrow', 'London', 'UK');
INSERT INTO Airport VALUES ('NRT', 'Narita', 'Tokyo', 'Japan');
INSERT INTO Airport VALUES ('CDG', 'Charles de Gaulle', 'Paris', 'France');
INSERT INTO Airport VALUES ('DXB', 'Dubai International', 'Dubai', 'UAE');
INSERT INTO Airport VALUES ('YYZ', 'Toronto Pearson', 'Toronto', 'Canada');

-- 3. Aircraft
INSERT INTO Aircraft VALUES ('AC01', 'Boeing 737', 180, 'A001');
INSERT INTO Aircraft VALUES ('AC02', 'Airbus A320', 160, 'A002');
INSERT INTO Aircraft VALUES ('AC03', 'Boeing 777', 300, 'A003');
INSERT INTO Aircraft VALUES ('AC04', 'Airbus A380', 500, 'A004');
INSERT INTO Aircraft VALUES ('AC05', 'Embraer E190', 100, 'A005');
INSERT INTO Aircraft VALUES ('AC06', 'Boeing 787', 250, 'A006');
INSERT INTO Aircraft VALUES ('AC07', 'Bombardier CRJ900', 90, 'A007');

-- 4. Flight
INSERT INTO Flight VALUES ('FL100', 'JFK', 'LAX', SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '6' HOUR, 'AC01', 'A001', 'Domestic');
INSERT INTO Flight VALUES ('FL101', 'LAX', 'NRT', SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '12' HOUR, 'AC02', 'A002', 'International');
INSERT INTO Flight VALUES ('FL102', 'LHR', 'DXB', SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '7' HOUR, 'AC03', 'A003', 'International');
INSERT INTO Flight VALUES ('FL103', 'CDG', 'YYZ', SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '8' HOUR, 'AC04', 'A004', 'International');
INSERT INTO Flight VALUES ('FL104', 'YYZ', 'JFK', SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '2' HOUR, 'AC05', 'A005', 'Domestic');
INSERT INTO Flight VALUES ('FL105', 'DXB', 'LHR', SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '7' HOUR, 'AC06', 'A006', 'International');
INSERT INTO Flight VALUES ('FL106', 'NRT', 'CDG', SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '11' HOUR, 'AC07', 'A007', 'International');

-- 5. Schedule
INSERT INTO Schedule VALUES ('FL100', SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '6' HOUR, 'G1', 'On Time');
INSERT INTO Schedule VALUES ('FL101', SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '12' HOUR, 'G2', 'Delayed');
INSERT INTO Schedule VALUES ('FL102', SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '7' HOUR, 'G3', 'On Time');
INSERT INTO Schedule VALUES ('FL103', SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '8' HOUR, 'G4', 'Cancelled');
INSERT INTO Schedule VALUES ('FL104', SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '2' HOUR, 'G5', 'On Time');
INSERT INTO Schedule VALUES ('FL105', SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '7' HOUR, 'G6', 'Boarding');
INSERT INTO Schedule VALUES ('FL106', SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '11' HOUR, 'G7', 'On Time');

-- 6. Passenger
INSERT INTO Passenger VALUES ('P001', 'Alice Smith', DATE '1980-01-01', 'alice@gmail.com', 'A1234567');
INSERT INTO Passenger VALUES ('P002', 'Bob Johnson', DATE '1990-02-02', 'bob@gmail.com', 'B2345678');
INSERT INTO Passenger VALUES ('P003', 'Charlie Brown', DATE '1985-03-03', 'charlie@gmail.com', 'C3456789');
INSERT INTO Passenger VALUES ('P004', 'Diana Prince', DATE '1995-04-04', 'diana@gmail.com', 'D4567890');
INSERT INTO Passenger VALUES ('P005', 'Ethan Hunt', DATE '1975-05-05', 'ethan@gmail.com', 'E5678901');
INSERT INTO Passenger VALUES ('P006', 'Fiona Glenanne', DATE '1982-06-06', 'fiona@gmail.com', 'F6789012');
INSERT INTO Passenger VALUES ('P007', 'George Miller', DATE '1993-07-07', 'george@gmail.com', 'G7890123');

-- 7. PassengerPhoneNumber
INSERT INTO PassengerPhoneNumber VALUES ('P001', '123-456-7890');
INSERT INTO PassengerPhoneNumber VALUES ('P002', '234-567-8901');
INSERT INTO PassengerPhoneNumber VALUES ('P003', '345-678-9012');
INSERT INTO PassengerPhoneNumber VALUES ('P004', '456-789-0123');
INSERT INTO PassengerPhoneNumber VALUES ('P005', '567-890-1234');
INSERT INTO PassengerPhoneNumber VALUES ('P006', '678-901-2345');
INSERT INTO PassengerPhoneNumber VALUES ('P007', '789-012-3456');

-- 8. Booking
INSERT INTO Booking VALUES ('B001', 'P001', 'FL100', SYSDATE, '12A');
INSERT INTO Booking VALUES ('B002', 'P002', 'FL101', SYSDATE, '14C');
INSERT INTO Booking VALUES ('B003', 'P003', 'FL102', SYSDATE, '15D');
INSERT INTO Booking VALUES ('B004', 'P004', 'FL103', SYSDATE, '16B');
INSERT INTO Booking VALUES ('B005', 'P005', 'FL104', SYSDATE, '10F');
INSERT INTO Booking VALUES ('B006', 'P006', 'FL105', SYSDATE, '22A');
INSERT INTO Booking VALUES ('B007', 'P007', 'FL106', SYSDATE, '7B');

-- 9. Payment
INSERT INTO Payment VALUES ('PAY001', 'B001', SYSDATE, 500, 'Credit Card');
INSERT INTO Payment VALUES ('PAY002', 'B002', SYSDATE, 800, 'Debit Card');
INSERT INTO Payment VALUES ('PAY003', 'B003', SYSDATE, 900, 'UPI');
INSERT INTO Payment VALUES ('PAY004', 'B004', SYSDATE, 750, 'PayPal');
INSERT INTO Payment VALUES ('PAY005', 'B005', SYSDATE, 300, 'Net Banking');
INSERT INTO Payment VALUES ('PAY006', 'B006', SYSDATE, 950, 'Cash');
INSERT INTO Payment VALUES ('PAY007', 'B007', SYSDATE, 700, 'Credit Card');

-- 10. Employee
INSERT INTO Employee VALUES ('E001', 'James Cameron', DATE '2010-01-01', 'Pilot', 'A001');
INSERT INTO Employee VALUES ('E002', 'Linda Lane', DATE '2012-02-01', 'Pilot', 'A002');
INSERT INTO Employee VALUES ('E003', 'Mark Smith', DATE '2015-03-01', 'Crew', 'A003');
INSERT INTO Employee VALUES ('E004', 'Nina Brown', DATE '2016-04-01', 'Crew', 'A004');
INSERT INTO Employee VALUES ('E005', 'Oscar Grant', DATE '2017-05-01', 'Crew', 'A005');
INSERT INTO Employee VALUES ('E006', 'Peter James', DATE '2018-06-01', 'Pilot', 'A006');
INSERT INTO Employee VALUES ('E007', 'Quincy Adams', DATE '2019-07-01', 'Pilot', 'A007');

-- 11. Pilot
INSERT INTO Pilot VALUES ('E001', 'L123', 'Boeing 737, Airbus A320');
INSERT INTO Pilot VALUES ('E002', 'L234', 'Airbus A380, Boeing 777');
INSERT INTO Pilot VALUES ('E006', 'L345', 'Boeing 787');
INSERT INTO Pilot VALUES ('E007', 'L456', 'Bombardier CRJ900');

-- 12. Crew
INSERT INTO Crew VALUES ('E003', 'Cabin Attendant');
INSERT INTO Crew VALUES ('E004', 'Cabin Supervisor');
INSERT INTO Crew VALUES ('E005', 'Ground Staff');

-- 13. FlightAssignment
INSERT INTO FlightAssignment VALUES ('FL100', 'E001');
INSERT INTO FlightAssignment VALUES ('FL101', 'E002');
INSERT INTO FlightAssignment VALUES ('FL102', 'E003');
INSERT INTO FlightAssignment VALUES ('FL103', 'E004');
INSERT INTO FlightAssignment VALUES ('FL104', 'E005');
INSERT INTO FlightAssignment VALUES ('FL105', 'E006');
INSERT INTO FlightAssignment VALUES ('FL106', 'E007');

--AIRLINE_USER
INSERT INTO AIRLINE_USER (full_name, email, phone, password, user_role, account_status, created_at, last_login)
VALUES ('Hasin Maliha', 'maliha@gmail.com', '+880123456781', 'maliha123', 'passenger', 'active', CURRENT_TIMESTAMP, NULL);

INSERT INTO AIRLINE_USER (full_name, email, phone, password, user_role, account_status, created_at, last_login)
VALUES ('Aniruddha', 'aniruddha@gmail.com', '+880123456782', 'aniruddha456', 'admin', 'active', CURRENT_TIMESTAMP, NULL);

INSERT INTO AIRLINE_USER (full_name, email, phone, password, user_role, account_status, created_at, last_login)
VALUES ('Pranay', 'pranay@gmail.com', '+880123456783', 'pranay789', 'admin', 'active', CURRENT_TIMESTAMP, NULL);

INSERT INTO AIRLINE_USER (full_name, email, phone, password, user_role, account_status, created_at, last_login)
VALUES ('Samiul Karim', 'samiul.k@gmail.com', '+880123456784', 'samiul321', 'passenger', 'inactive', CURRENT_TIMESTAMP, NULL);

INSERT INTO AIRLINE_USER (full_name, email, phone, password, user_role, account_status, created_at, last_login)
VALUES ('Nusrat Jahan', 'nusratj@gmail.com', '+880123456785', 'nusrat123', 'employee', 'active', CURRENT_TIMESTAMP, NULL);

INSERT INTO AIRLINE_USER (full_name, email, phone, password, user_role, account_status, created_at, last_login)
VALUES ('Rafi Ahmed', 'rafia@gmail.com', '+880123456786', 'rafi999', 'employee', 'active', CURRENT_TIMESTAMP, NULL);

INSERT INTO AIRLINE_USER (full_name, email, phone, password, user_role, account_status, created_at, last_login)
VALUES ('Meherab Islam', 'meherab@gmail.com', '+880123456787', 'meherab12', 'passenger', 'active', CURRENT_TIMESTAMP, NULL);

INSERT INTO AIRLINE_USER (full_name, email, phone, password, user_role, account_status, created_at, last_login)
VALUES ('Tahia Nawar', 'tahia@gmail.com', '+880123456788', 'tahia456', 'passenger', 'active', CURRENT_TIMESTAMP, NULL);

INSERT INTO AIRLINE_USER (full_name, email, phone, password, user_role, account_status, created_at, last_login)
VALUES ('Jannat Ara', 'jannat@gmail.com', '+880123456789', 'jannat89', 'passenger', 'inactive', CURRENT_TIMESTAMP, NULL);

INSERT INTO AIRLINE_USER (full_name, email, phone, password, user_role, account_status, created_at, last_login)
VALUES ('Sohug', 'sohug@gmail.com', '+880123456790', 'sohug00', 'admin', 'active', CURRENT_TIMESTAMP, NULL);

--view
--Pranay
CREATE OR REPLACE VIEW FlightsWithAirline AS
SELECT f.flight_number, f.departure_time, f.arrival_time, a.name AS airline_name
FROM Flight f
JOIN Airline a ON f.airline_id = a.airline_id;

CREATE OR REPLACE VIEW PassengerBookings AS
SELECT p.name AS passenger_name, b.booking_id, f.flight_number, b.seat_number
FROM Passenger p
JOIN Booking b ON p.passenger_id = b.passenger_id
JOIN Flight f ON b.flight_number = f.flight_number;

CREATE OR REPLACE VIEW FlightScheduleStatus AS
SELECT s.flight_number, s.departure_date_time, s.arrival_date_time, s.gate_number, s.status
FROM Schedule s;

CREATE OR REPLACE VIEW PilotDetails AS
SELECT e.name, e.role, p.license_number, p.ratings
FROM Employee e
JOIN Pilot p ON e.employee_id = p.employee_id;

--Aniruddha

CREATE OR REPLACE VIEW CrewDetails AS
SELECT e.name, e.role, c.position
FROM Employee e
JOIN Crew c ON e.employee_id = c.employee_id;

CREATE OR REPLACE VIEW PaymentSummary AS
SELECT p.payment_id, b.booking_id, p.amount, p.payment_method
FROM Payment p
JOIN Booking b ON p.booking_id = b.booking_id;

CREATE OR REPLACE VIEW FlightsPerAirport AS
SELECT a.name AS airport_name, f.flight_number, f.departure_time, f.arrival_time
FROM Airport a
JOIN Flight f ON a.airport_code = f.departure_airport_code OR a.airport_code = f.arrival_airport_code;

CREATE OR REPLACE VIEW AircraftDetails AS
SELECT ac.aircraft_id, ac.model, ac.capacity, al.name AS airline
FROM Aircraft ac
JOIN Airline al ON ac.airline_id = al.airline_id;

--Sohug
CREATE OR REPLACE VIEW FlightEmployees AS
SELECT fa.flight_number, e.name, e.role
FROM FlightAssignment fa
JOIN Employee e ON fa.employee_id = e.employee_id;

CREATE OR REPLACE VIEW PassengerContacts AS
SELECT p.name, p.email, ph.phone_number
FROM Passenger p
JOIN PassengerPhoneNumber ph ON p.passenger_id = ph.passenger_id;

CREATE OR REPLACE VIEW InternationalFlights AS
SELECT flight_number, departure_time, arrival_time
FROM Flight
WHERE flight_type = 'International';

CREATE OR REPLACE VIEW RecentBookings AS
SELECT booking_id, passenger_id, flight_number, booking_date
FROM Booking
WHERE booking_date > SYSDATE - 30;

---Prince
CREATE OR REPLACE VIEW CrewPerFlight AS
SELECT f.flight_number, e.name, c.position
FROM FlightAssignment fa
JOIN Employee e ON fa.employee_id = e.employee_id
JOIN Crew c ON e.employee_id = c.employee_id
JOIN Flight f ON fa.flight_number = f.flight_number;

CREATE OR REPLACE VIEW PaymentByMethod AS
SELECT payment_method, COUNT(*) AS total_payments, SUM(amount) AS total_amount
FROM Payment
GROUP BY payment_method;

CREATE OR REPLACE VIEW FullFlightSchedule AS
SELECT f.flight_number, f.departure_time, f.arrival_time, s.gate_number, s.status
FROM Flight f
JOIN Schedule s ON f.flight_number = s.flight_number;

CREATE OR REPLACE VIEW EmployeeCountPerAirline AS
SELECT a.name AS airline_name, COUNT(e.employee_id) AS total_employees
FROM Airline a
JOIN Employee e ON a.airline_id = e.airline_id
GROUP BY a.name;

---trigger
--Validate Age of Passenger
CREATE OR REPLACE TRIGGER trg_validate_passenger_age
BEFORE INSERT ON Passenger
FOR EACH ROW
DECLARE
    v_age NUMBER;
BEGIN
    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, :NEW.date_of_birth) / 12);
    IF v_age < 2 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Passenger must be at least 2 years old.');
    END IF;
END;
/

--Prevent Overbooking a Flight
CREATE OR REPLACE TRIGGER trg_prevent_overbooking
BEFORE INSERT ON Booking
FOR EACH ROW
DECLARE
    v_capacity NUMBER;
    v_booked   NUMBER;
BEGIN
    -- Get flight capacity
    SELECT a.capacity INTO v_capacity
    FROM Flight f
    JOIN Aircraft a ON f.aircraft_id = a.aircraft_id
    WHERE f.flight_number = :NEW.flight_number;

    -- Get current booked seats
    SELECT COUNT(*) INTO v_booked
    FROM Booking
    WHERE flight_number = :NEW.flight_number;

    IF v_booked >= v_capacity THEN
        RAISE_APPLICATION_ERROR(-20001, 'Flight is fully booked!');
    END IF;
END;
/
