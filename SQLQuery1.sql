create database Company 

use Company 

create table Employee
(
SSN int primary key identity(1,1),
Fname nvarchar(20) not null,
Lname nvarchar(20) not null,
Bdate date,
Gender bit default 0,
Supervisor_SSN int,
foreign key (Supervisor_SSN) references Employee(SSN),
)




 create table Department
(
Dnumber int primary key identity(1,1),
Dname nvarchar(20) not null,
Hiredate date not null,
Mgr_SSN int,
foreign key (Mgr_SSN) references Employee(SSN),
)




 create table Locations 
(
Dnumber int,
Dlocation nvarchar(100),
foreign key (Dnumber) references Department(Dnumber),
primary key (Dnumber, Dlocation)
)



create table Project
(
Pnumber int primary key identity(1,1),
Pname nvarchar(20) not null,
Plocation nvarchar(20) not null,
Pcity nvarchar(20) not null,
Dnum int,
foreign key (Dnum) references Department(Dnumber),
)



create table Dependents 
(
Ssn int,
Deptname nvarchar(20) not null,
Bdate date,
Gender bit default 0,
foreign key (Ssn) references Employee(SSN),
primary key (Ssn, Deptname)
)



create table MyWork 
(
Ssn int,
Pnum int,
Whours int,
foreign key (Ssn) references Employee(SSN),
foreign key (Pnum) references Project(Pnumber),
primary key (Ssn, Pnum)
)


alter table Employee
add Dnum int foreign key references Department(Dnumber) 


insert into Employee(Fname,Lname,Bdate,Gender)
values('Ali','Ahmed','2001-06-05',1),
      ('Mohammed','Salim','1999-03-20',1),
	  ('Reem','Omar','2006-09-12',0) 

select * from Employee


insert into Department(Dname,Hiredate,Mgr_SSN)
values('IT','2026-01-03',7),
      ('HR', '2026-02-01',9),
	  ('Finance','2025-09-15',8)

select * from Department


insert into Locations(Dnumber,Dlocation)
values(3,'Muscat'),
      (4,'Sohar'),
	  (5,'Seeb')

select * from Locations


insert into Project(Pname,Plocation,Pcity,Dnum)
values('Smart Waste System','KOM','Muscat', 5),
      ('ERP Upgrade','Freezone','Sohar',3),
      ('IoT Pilot Deployment','Industrial Area','Seeb',4)

select * from Project
	  

insert into Dependents(Ssn,Deptname,Bdate,Gender)
values(9,'Nasser','2010-05-12', 1),
      (8,'Fatma','2012-08-20', 0),
      (7,'Moosa','2015-11-03', 1);

select * from Dependents



insert into MyWork(Ssn,Pnum,Whours)
values(9,2,7),
      (8,4,10),
      (7,3,9)


select * from MyWork
