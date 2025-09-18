# Clinic Database Management System

## Overview
This project is a relational database system designed for a **Clinic Booking System**.  
It helps manage patients, doctors, services, appointments, and prescriptions.  

The database is implemented in **MySQL** with proper constraints and relationships.

---

## Features
- Patient records management  
- Doctor profiles with specialties  
- Medical services and pricing  
- Appointment scheduling with patients and doctors  
- Prescription tracking  
- Many-to-many relationship between appointments and services  

---

## Database Schema
### Entities:
1. **Patients**
   - Stores personal details of patients.  
2. **Doctors**
   - Stores doctor details and specialties.  
3. **Services**
   - Stores clinic services with prices.  
4. **Appointments**
   - Links patients with doctors and stores appointment details.  
5. **Appointment_Services**
   - Many-to-many relationship between appointments and services.  
6. **Prescriptions**
   - Medications prescribed during appointments.  

---

## Relationships
- **Patients → Appointments**: One-to-Many  
- **Doctors → Appointments**: One-to-Many  
- **Appointments → Services**: Many-to-Many  
- **Appointments → Prescriptions**: One-to-Many  

---

## Setup Instructions
1. Install **MySQL Server** on your machine.  
2. Open your MySQL client (e.g., `mysql` CLI, Workbench, or VS Code extension).  
3. Run the provided SQL script:

   ```bash
   mysql -u root -p < clinic.sql
The script will:

Create a new database clinic_db.

Create all required tables with constraints.

Insert sample data.

Example Query
Get all upcoming appointments with patient and doctor names:

sql
Copy code
SELECT 
    a.appointment_id,
    p.first_name AS patient,
    d.first_name AS doctor,
    a.appointment_datetime,
    a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE a.status = 'Scheduled';

Author: Isac Wangila
