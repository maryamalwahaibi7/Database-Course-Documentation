-- ============================================
-- Hospital Management System - VIEWS Creation Tasks
-- Practice Exercise for Trainees
-- ============================================

USE HospitalManagementSystem;
GO

/*
============================================
INSTRUCTIONS FOR TRAINEES
============================================

Create the following 5 views for the Hospital Management System.
Each view should be named exactly as specified.
Test each view after creation by running: SELECT * FROM [ViewName];

============================================
*/


-- ============================================
-- View 1: ViewHighValuePatients
-- ============================================
/*
Create a view that displays patients who have spent more than $2000 in total,
including their total number of appointments.

Required columns:
- Patient_ID
- Patient full name (first + last)
- Phone number
- Total amount spent
- Total number of appointments

Order by total amount spent (highest first).
*/

CREATE VIEW ViewHighValuePatients
AS
SELECT 
    p.Patient_ID,
    p.F_name + ' ' + p.L_name AS Patient_Full_Name,
    p.Phone_no,
    SUM(b.Total_amount) AS Total_Amount_Spent,
    COUNT(DISTINCT a.APPT_ID) AS Total_Number_of_Appointments
FROM PATIENT p
INNER JOIN BILLING b
    ON p.Patient_ID = b.Patient_ID
INNER JOIN APPOINTMENT a
    ON p.Patient_ID = a.Patient_ID
GROUP BY 
    p.Patient_ID,
    p.F_name,
    p.L_name,
    p.Phone_no
HAVING SUM(b.Total_amount) > 2000;
GO 
SELECT * FROM ViewHighValuePatients
ORDER BY Total_Amount_Spent DESC;

-- ============================================
-- View 2: ViewDoctorWorkload
-- ============================================
/*
Create a view that lists each doctor along with their total number of completed 
appointments and their average appointment revenue.

Required columns:
- Doctor_ID
- Doctor name
- Specialization
- Department name
- Total completed appointments
- Average revenue per appointment

Order by total completed appointments (highest first).
*/

CREATE VIEW ViewDoctorWorkload
AS
SELECT 
    d.Doctor_ID,
    d.Name AS Doctor_Name,
    d.Specialization,
    dep.Dept_name AS Department_Name,
    COUNT(a.APPT_ID) AS Total_Completed_Appointments,
    AVG(CAST(ISNULL(b.Total_amount, 0) AS DECIMAL(10,2))) AS Average_Revenue_Per_Appointment
FROM DOCTOR d
INNER JOIN DEPARTMENT dep
    ON d.Dept_ID = dep.Dept_ID
LEFT JOIN APPOINTMENT a
    ON d.Doctor_ID = a.Doctor_ID
    AND a.Status = 'Completed'
LEFT JOIN BILLING b
    ON a.APPT_ID = b.APPT_ID
GROUP BY 
    d.Doctor_ID,
    d.Name,
    d.Specialization,
    dep.Dept_name;
GO
SELECT * FROM ViewDoctorWorkload
ORDER BY Total_Completed_Appointments DESC;

-- ============================================
-- View 3: ViewPendingBills
-- ============================================
/*
Create a view showing all unpaid bills (status = 'Pending' or 'Overdue'),
grouped by payment status and ordered by due date.

Required columns:
- Bill_ID
- Patient full name
- Patient phone number
- Bill amount
- Payment status
- Due date
- Days overdue (difference between due date and current date)

Order by due date (oldest first).
*/

CREATE VIEW ViewPendingBills
AS
SELECT 
    b.Bill_ID,
    p.F_name + ' ' + p.L_name AS Patient_Full_Name,
    p.Phone_no AS Patient_Phone_Number,
    b.Total_amount AS Bill_Amount,
    b.Payment_status,
    b.Due_date,
    DATEDIFF(DAY, b.Due_date, GETDATE()) AS Days_Overdue
FROM BILLING b
INNER JOIN PATIENT p
    ON b.Patient_ID = p.Patient_ID
WHERE b.Payment_status IN ('Pending', 'Overdue');
GO
SELECT * FROM ViewPendingBills
ORDER BY Due_date ASC;

-- ============================================
-- View 4: ViewServiceUtilization
-- ============================================
/*
Create a view summarizing service usage by department: 
total times each service was used and total revenue generated.

Required columns:
- Department name
- Service name
- Service type
- Unit price
- Times used (count of appointments using this service)
- Total revenue generated from this service

Only include services that have been used at least once.
Order by department name, then by total revenue (highest first).
*/

CREATE VIEW ViewServiceUtilization
AS
SELECT 
    dep.Dept_name AS Department_Name,
    s.Service_name,
    s.Service_type,
    s.Unit_price,
    COUNT(asv.APPT_ID) AS Times_Used,
    SUM(asv.Quantity * s.Unit_price) AS Total_Revenue_Generated
FROM SERVICE s
INNER JOIN DEPARTMENT dep
    ON s.Dept_ID = dep.Dept_ID
INNER JOIN APP_SERVICE asv
    ON s.Service_ID = asv.Service_ID
GROUP BY 
    dep.Dept_name,
    s.Service_name,
    s.Service_type,
    s.Unit_price;
GO
SELECT * FROM ViewServiceUtilization
ORDER BY Department_Name ASC, Total_Revenue_Generated DESC;



-- ============================================
-- View 5: ViewAppointmentSchedule
-- ============================================
/*
Create a view showing all scheduled appointments along with patient contact details,
doctor information, and billing status.

Required columns:
- Appointment ID
- Appointment date
- Appointment time
- Patient full name
- Patient phone number
- Doctor name
- Department name
- Appointment type
- Payment status from billing

Only include appointments with status = 'Scheduled'.
Order by appointment date and time.
*/

CREATE VIEW ViewAppointmentSchedule
AS
SELECT 
    a.APPT_ID AS Appointment_ID,
    a.Date AS Appointment_Date,
    a.Time AS Appointment_Time,
    p.F_name + ' ' + p.L_name AS Patient_Full_Name,
    p.Phone_no AS Patient_Phone_Number,
    d.Name AS Doctor_Name,
    dep.Dept_name AS Department_Name,
    a.Appointment_type,
    b.Payment_status
FROM APPOINTMENT a
INNER JOIN PATIENT p
    ON a.Patient_ID = p.Patient_ID
INNER JOIN DOCTOR d
    ON a.Doctor_ID = d.Doctor_ID
INNER JOIN DEPARTMENT dep
    ON d.Dept_ID = dep.Dept_ID
LEFT JOIN BILLING b
    ON a.APPT_ID = b.APPT_ID
WHERE a.Status = 'Scheduled';
GO
SELECT * FROM ViewAppointmentSchedule
ORDER BY Appointment_Date ASC, Appointment_Time ASC; 

-- ============================================
-- TESTING YOUR VIEWS
-- ============================================
/*
After creating each view, test it with:

SELECT * FROM ViewHighValuePatients;
SELECT * FROM ViewDoctorWorkload;
SELECT * FROM ViewPendingBills;
SELECT * FROM ViewServiceUtilization;
SELECT * FROM ViewAppointmentSchedule;

Make sure the results match the requirements!
*/


-- ============================================
-- END OF VIEW CREATION TASKS
-- ============================================
