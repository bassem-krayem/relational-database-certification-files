-- Drop existing tables if they exist (optional, for clean setup)
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS services;

-- Create the customers table
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  phone VARCHAR(20) UNIQUE NOT NULL
);

-- Create the services table
CREATE TABLE services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

-- Create the appointments table
CREATE TABLE appointments (
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL REFERENCES customers(customer_id),
  service_id INT NOT NULL REFERENCES services(service_id),
  time VARCHAR(50) NOT NULL
);

-- Insert at least three rows into the services table
INSERT INTO services (service_id, name) VALUES
(1, 'Haircut'),
(2, 'Shave'),
(3, 'Beard Trim');

-- Optionally insert some sample customers and appointments
INSERT INTO customers (name, phone) VALUES
('Ali', '123456789'),
('Bassem', '987654321'),
('Karim', '555666777');

INSERT INTO appointments (customer_id, service_id, time) VALUES
(1, 1, '10:00 AM'),
(2, 2, '11:00 AM'),
(3, 3, '12:00 PM');
