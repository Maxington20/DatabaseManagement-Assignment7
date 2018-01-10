--Assignment 7
--Max Herrington

--0
PRINT'***QUESTION 0***'
PRINT''

SET ANSI_WARNINGS OFF


--1
PRINT'***QUESTION 1***'
PRINT''

SELECT COUNT(Employee.number) AS 'Employees in the School of Business'
FROM Employee
WHERE schoolCode = 'BUS'


--2
PRINT'***QUESTION 2***'
PRINT''

SELECT cs.studentNumber, cs.finalMark, p.firstName, p.lastName
FROM CourseOffering co, Person p, CourseStudent cs
WHERE co.sessionCode = 'F09'
	AND co.courseNumber = 'PROG8080'
	AND p.number = cs.studentNumber
	AND CO.id = CS.CourseOfferingId
	AND finalMark > 
		(SELECT AVG(finalmark) FROM CourseStudent WHERE sessionCode = 'F09' 
		AND finalMark >0 AND CourseStudent.CourseOfferingId IN 
		(SELECT ID FROM CourseOffering WHERE CourseOffering.courseNumber = 'PROG8080' AND sessionCode ='F09'))
GROUP BY CS.finalMark, CS.studentNumber,P.firstName,P.lastName
ORDER BY p.lastName


 --3
 PRINT'***QUESTION 3***'
 PRINT''
 
 SELECT CourseOffering.courseNumber,
  ROUND(MIN(finalMark),0) AS 'Lowest Mark',
  ROUND(AVG(finalMark),0) AS 'Average Mark',
  ROUND(MAX(finalMark),0) AS 'Maximum Mark'  
 FROM CourseStudent,CourseOffering
 WHERE CourseStudent.CourseOfferingId = CourseOffering.id
	AND CourseOffering.sessionCode = 'F10'
GROUP BY courseNumber


--4
PRINT'***QUESTION 4***'
PRINT''

GO
CREATE VIEW auditPaymentSum AS
select Audit.studentNumbeR, SUM(AUDIT.AMOUNT) AS amount
FROM Audit
WHERE Audit.auditCategoryCode = 'P'
GROUP BY Audit.studentNumber
GO

SELECT Audit.studentNumber,
	Person.firstName,
	Person.lastName
FROM Audit, Person
WHERE Audit.studentNumber = Person.number
	AND auditCategoryCode = 'P'
GROUP BY studentNumber, lastName, firstName
HAVING SUM(audit.amount) < (SELECT AVG(amount) FROM auditPaymentSum)

--5A
PRINT'***QUESTION 5A***'
PRINT''	

SELECT Employee.number AS 'employeeNumber',firstName, lastName,
	COUNT(CourseOffering.courseNumber) AS 'Courses Taught'
FROM Person, Employee,CourseOffering,School
WHERE Person.number = Employee.number
	AND Employee.schoolCode = School.code
	AND Employee.schoolCode = 'EIT'
	AND CourseOffering.employeeNumber = Employee.number
	AND CourseOffering.sessionCode IN ('F09','W09','F08','W08')
GROUP BY Employee.number,Person.firstName,Person.lastName
ORDER BY lastName


--5B
PRINT'***QUESTION 5B***'
PRINT''	

SELECT Employee.number AS 'employeeNumber',firstName, lastName,
	COUNT(CourseOffering.courseNumber) AS 'Courses Taught'
FROM Person, Employee LEFT OUTER JOIN CourseOffering ON Employee.number = CourseOffering.employeeNumber 
	AND sessionCode IN ('F09','W09','F08','W08'),School
WHERE Person.number = Employee.number
	AND Employee.schoolCode = 'EIT'
	AND Employee.schoolCode = School.code
GROUP BY Employee.number,Person.firstName,Person.lastName
ORDER BY lastName


--6
PRINT'***QUESTION 6***'
PRINT''	

SELECT Program.acronym,Program.name,
	FORMAT(SUM(ProgramFee.tuition + (ProgramFee.tuition * ProgramFee.coopFeeMultiplier)),'C') AS 'Total Fees'
FROM Program,ProgramFee
WHERE name != 'Computer Programmer'
	AND Program.code = ProgramFee.code
GROUP BY Program.acronym,Program.name
ORDER BY acronym
	

--7
PRINT'***QUESTION 7***'
PRINT''

SELECT 
	(SELECT p.number from person p where p.number = py.studentNumber) AS 'Student Number',
	(SELECT p.firstname FROM Person p WHERE p.number = py.studentNumber) AS 'First Name',
	(SELECT p.lastname FROM Person p WHERE p.number = py.studentNumber) AS 'Last Name',
FORMAT(SUM(py.amount),'C') AS 'Fee Payment Total'
FROM Payment py
GROUP BY py.studentNumber
HAVING SUM(PY.AMOUNT) >=  (SELECT AVG(PY.amount) * 3 FROM PAYMENT PY)
ORDER BY (SELECT p.lastname FROM Person p WHERE P.number = PY.studentNumber), 
	(SELECT p.firstname FROM Person p WHERE P.number = PY.studentNumber)

--ALTERNATIVE ANSWER FOR 7 WITHOUT SUBQUERIES
select Student.number,person.firstName, person.lastName, sum(payment.amount)
from Person, Student, Payment
where person.number = student.number
and payment.studentNumber = student.number
group by student.number, firstName, lastName
having sum(payment.amount) > (select avg(payment.amount) * 3 from Payment) --THIS PART HAS TO BE A SUBQUERY!!
ORDER BY lastName, firstName


--8
PRINT'***QUESTION 8***'
PRINT''

SET ANSI_WARNINGS ON
