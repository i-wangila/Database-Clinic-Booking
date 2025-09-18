-- clinic.sql
-- Clinic Booking System schema (without DROP)

CREATE DATABASE clinic_db
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

USE clinic_db;

-- ----------------------
-- Table: patients
-- ----------------------
CREATE TABLE patients (
  patient_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  date_of_birth DATE,
  gender ENUM('M','F','Other') DEFAULT 'Other',
  phone VARCHAR(30),
  email VARCHAR(255),
  address VARCHAR(500),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_patients_email (email)
) ENGINE=InnoDB;

-- ----------------------
-- Table: doctors
-- ----------------------
CREATE TABLE doctors (
  doctor_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  specialty VARCHAR(150),
  phone VARCHAR(30),
  email VARCHAR(255),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_doctors_email (email)
) ENGINE=InnoDB;

-- ----------------------
-- Table: services
-- ----------------------
CREATE TABLE services (
  service_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_service_name (name)
) ENGINE=InnoDB;

-- ----------------------
-- Table: appointments
-- ----------------------
CREATE TABLE appointments (
  appointment_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  patient_id INT UNSIGNED NOT NULL,
  doctor_id INT UNSIGNED NOT NULL,
  appointment_datetime DATETIME NOT NULL,
  status ENUM('Scheduled','Completed','Cancelled','No-Show') NOT NULL DEFAULT 'Scheduled',
  notes TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_appointments_patient FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_appointments_doctor FOREIGN KEY (doctor_id)
    REFERENCES doctors(doctor_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ----------------------
-- Table: appointment_services
-- ----------------------
CREATE TABLE appointment_services (
  appointment_id INT UNSIGNED NOT NULL,
  service_id INT UNSIGNED NOT NULL,
  quantity INT UNSIGNED NOT NULL DEFAULT 1,
  price_at_time DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (appointment_id, service_id),
  CONSTRAINT fk_as_appointment FOREIGN KEY (appointment_id)
    REFERENCES appointments(appointment_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_as_service FOREIGN KEY (service_id)
    REFERENCES services(service_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ----------------------
-- Table: prescriptions
-- ----------------------
CREATE TABLE prescriptions (
  prescription_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT UNSIGNED NOT NULL,
  medication VARCHAR(255) NOT NULL,
  dosage VARCHAR(255),
  directions TEXT,
  issued_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_prescriptions_appointment FOREIGN KEY (appointment_id)
    REFERENCES appointments(appointment_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ----------------------
-- Helpful indexes
-- ----------------------
CREATE INDEX idx_appointments_datetime ON appointments (appointment_datetime);
CREATE INDEX idx_patients_phone ON patients (phone);
CREATE INDEX idx_doctors_specialty ON doctors (specialty);

-- ----------------------
-- Sample data (optional)
-- ----------------------
INSERT INTO doctors (first_name, last_name, specialty, phone, email)
VALUES
  ('Alice', 'Muthoni', 'General Practitioner', '+254700000001', 'alice.muthoni@example.com'),
  ('John',  'Otieno',  'Pathologist',           '+254700000002', 'john.otieno@example.com');

INSERT INTO services (name, description, price)
VALUES
  ('General Consultation', '30-minute GP consultation', 25.00),
  ('Full Blood Count', 'CBC test', 12.50),
  ('Malaria Rapid Test', 'Rapid antigen test for malaria', 6.00);

INSERT INTO patients (first_name, last_name, date_of_birth, gender, phone, email, address)
VALUES
  ('Isaac', 'Wangila', '1996-01-12', 'M', '+254700111222', 'isaac.wangila@example.com', 'Utawala, Nairobi'),
  ('Sarah', 'Kamau',  '1988-05-23', 'F', '+254700333444', 'sarah.kamau@example.com', 'Kilimani, Nairobi');

INSERT INTO appointments (patient_id, doctor_id, appointment_datetime, status, notes)
VALUES
  (1, 1, '2025-09-20 10:00:00', 'Scheduled', 'Follow-up to review CBC'),
  (2, 2, '2025-09-21 14:30:00', 'Scheduled', 'Initial consult');

INSERT INTO appointment_services (appointment_id, service_id, quantity, price_at_time)
VALUES
  (1, 1, 1, 25.00),
  (1, 2, 1, 12.50),
  (2, 3, 1, 6.00);

INSERT INTO prescriptions (appointment_id, medication, dosage, directions)
VALUES
  (1, 'Ferrous sulphate', '200 mg', 'One tablet daily for 3 months'),
  (2, 'Artemether-lumefantrine', '80/480 mg', 'As per standard malaria dosing');
