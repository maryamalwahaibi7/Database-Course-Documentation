create database LibraryManagementSystem 

use LibraryManagementSystem


create table Libraries
(
libraryID int primary key identity(1,1),
LibraryName nvarchar(100) not null unique,
LibraryLocation nvarchar(100) not null,
ContactNumber varchar(20) not null,
EstablishedYear int
)


create table Book
(
BookID int primary key identity(1,1),
ISBN varchar(13) NOT NULL unique,
Title nvarchar(100) not null,
Genre nvarchar(20) not null,
Price DECIMAL(10,2) not null,
IsAvailable bit not null default (1),
AvailabilityStatus nvarchar(20) not null default ('Available'),
ShelfLocation nvarchar(100) not null,
LID int,
constraint CK_Book_Genre 
check (Genre in ('Fiction','Non-fiction','Reference','Children')),
constraint CK_Book_Price_Positive 
check (Price > 0),
foreign key (LID) references Libraries(libraryID)
on delete cascade
on update cascade
)


create table Members
(
MemberID int primary key identity(1,1),
FullName nvarchar(100) not null,
Email nvarchar(100) not null unique,
PhoneNumber varchar(20),
MembershipStartDate date not null
)


create table Loan
(
LoanID int primary key identity(1,1),
LoanDate date not null,
DueDate date not null,
ReturnDate date,
LStatus nvarchar(100) not null default ('Issued'),
MID int,
BID int,
constraint CK_Loan_Status 
check (LStatus in ('Issued','Returned','Overdue')),
constraint CK_Loan_ReturnDate 
check (ReturnDate is null or ReturnDate >= LoanDate),
foreign key (MID) references Members(MemberID)
on delete cascade
on update cascade,
foreign key (BID) references Book(BookID)
on delete cascade
on update cascade
)


create table Payment
(
PaymentID int primary key identity(1,1),
PaymentDate date not null,
Amount DECIMAL(10,2) not null,
Method nvarchar(100),
LoanID int,
constraint CK_Payment_Amount_Positive 
check (Amount > 0),
foreign key (LoanID) references Loan(LoanID)
on delete cascade
on update cascade
)


create table Staff
(
StaffID int primary key identity(1,1),
FullName nvarchar(100),
Position nvarchar(100),
ContactNumber varchar(20),
LID int,
foreign key (LID) references Libraries(libraryID)
on delete cascade
on update cascade
)


create table Review
(
ReviewID int primary key identity(1,1),
Rating int not null,
comments nvarchar(100) not null default ('No comments'),
ReviewDate date not null,
MID int,
BID int,
constraint CK_Review_Rating 
check (Rating between 1 and 5),
foreign key (MID) references Members(MemberID)
on delete cascade
on update cascade,
foreign key (BID) references Book(BookID)
on delete cascade
on update cascade
)

insert into Libraries(LibraryName, LibraryLocation, ContactNumber, EstablishedYear)
values ('Central Library','Muscat','24123456',2005),
       ('North Library','Sohar','26876543',2012),
       ('East Library','Sur','25551234',2010),
       ('West Library','Barka','24567890',2015),
       ('South Library','Salalah','23214567',2008),
       ('Al Buraimi Library','Al Buraimi','25678901',2011),
       ('Nizwa Library','Nizwa','25432109',2003),
       ('Ibra Library','Ibra','25223344',2014),
       ('Rustaq Library','Rustaq','26677889',2009),
       ('Khasab Library','Khasab','26779900',2016)

select * from Libraries

insert into Book(ISBN, Title, Genre, Price, ShelfLocation, LID)
values ('9780131103627','Database Systems','Reference',18.50,'A-01',1),
       ('9780262033848','Introduction to Algorithms','Non-fiction',25.00,'B-02',1),
       ('9780439554930','Harry Potter','Fiction',12.00,'C-05',2),
       ('9780141321097','Matilda','Children',7.50,'D-03',2),
       ('9780132350884','Clean Code','Non-fiction',20.00,'B-07',3),
       ('9780201633610','Design Patterns','Reference',22.75,'A-09',3),
       ('9780061120084','To Kill a Mockingbird','Fiction',9.99,'C-01',4),
       ('9780553380163','A Short History of Nearly Everything','Non-fiction',11.50,'B-03',5),
       ('9781408855652','Fantastic Beasts','Children',8.25,'D-06',6),
       ('9780307277671','The Road','Fiction',10.75,'C-08',7)

select * from Book

insert into Members(FullName, Email, PhoneNumber, MembershipStartDate)
values ('Ahmed Al Balushi','ahmed.balushi@example.com','96891234567','2026-02-01'),
       ('Fatma Al Harthi','fatma.harthi@example.com','96892345678','2026-02-02'),
       ('Salim Al Shukaili','salim.shukaili@example.com','96893456789','2026-02-03'),
       ('Aisha Al Hinai','aisha.hinai@example.com','96894567890','2026-02-04'),
       ('Khalid Al Kindi','khalid.kindi@example.com','96895678901','2026-02-05'),
       ('Maryam Al Farsi','maryam.farsi@example.com','96896789012','2026-02-06'),
       ('Hamad Al Mughairi','hamad.mughairi@example.com','96897890123','2026-02-07'),
       ('Noor Al Saadi','noor.saadi@example.com','96898901234','2026-02-08'),
       ('Saeed Al Habsi','saeed.habsi@example.com','96899012345','2026-02-09'),
       ('Reem Al Qasimi','reem.qasimi@example.com','96890123456','2026-02-10')

select * from Members


insert into Loan(LoanDate, DueDate, ReturnDate, LStatus, MID, BID)
values ('2026-02-01','2026-02-11',null,'Issued',1,1),
       ('2026-02-02','2026-02-12','2026-02-10','Returned',2,2),
       ('2026-02-03','2026-02-13',null,'Overdue',3,3),
       ('2026-02-04','2026-02-14','2026-02-14','Returned',4,4),
       ('2026-02-05','2026-02-15',null,'Issued',5,5),
       ('2026-02-06','2026-02-16',null,'Issued',6,6),
       ('2026-02-07','2026-02-17','2026-02-17','Returned',7,7),
       ('2026-02-08','2026-02-18',null,'Overdue',8,8),
       ('2026-02-09','2026-02-19',null,'Issued',9,9),
       ('2026-02-10','2026-02-20','2026-02-20','Returned',10,10)

select * from Loan


insert into Payment(PaymentDate, Amount, Method, LoanID)
values ('2026-02-10',2.00,'Cash',2),
       ('2026-02-11',1.50,'Card',3),
       ('2026-02-12',3.00,'Cash',3),
       ('2026-02-13',2.25,'Card',5),
       ('2026-02-14',4.00,'Cash',8),
       ('2026-02-15',1.00,'Card',8),
       ('2026-02-16',2.75,'Cash',1),
       ('2026-02-17',5.00,'Card',9),
       ('2026-02-18',1.25,'Cash',6),
       ('2026-02-19',3.50,'Card',4)

select * from Payment


insert into Staff(FullName, Position, ContactNumber, LID)
values ('Hassan Al Maamari','Librarian','96890001111',1),
       ('Maha Al Farsi','Assistant Librarian','96890002222',2),
       ('Nasser Al Shanfari','Librarian','96890003333',3),
       ('Huda Al Hashmi','Assistant Librarian','96890004444',4),
       ('Yousuf Al Zadjali','Librarian','96890005555',5),
       ('Salma Al Lawati','Assistant Librarian','96890006666',6),
       ('Khalfan Al Amri','Librarian','96890007777',7),
       ('Amal Al Riyami','Assistant Librarian','96890008888',8),
       ('Sultan Al Harthy','Librarian','96890009999',9),
       ('Wafa Al Kharousi','Assistant Librarian','96890000000',10)

select * from Staff


insert into Review(Rating, comments, ReviewDate, MID, BID)
values (5,'Excellent book','2026-02-09',1,1),
       (4,default,'2026-02-09',2,2),
       (3,'Good but long','2026-02-10',3,3),
       (5,'Very useful','2026-02-10',4,4),
       (2,'Not my type','2026-02-11',5,5),
       (4,'Well written','2026-02-11',6,6),
       (1,'Boring','2026-02-12',7,7),
       (3,'Average','2026-02-12',8,8),
       (5,'Loved it','2026-02-13',9,9),
       (4,'Nice read','2026-02-13',10,10)

select * from Review

-- DAY 1: Basic SELECT Queries

--Part 1: Basic SELECT - Retrieving All Data
--Task 1.1:Retrieve all columns from Library table
select * from Libraries

--Task 1.2:Retrieve all columns from Members table
select * from Members

--Task 1.3:Retrieve all columns from Books table
select * from Book

--Part 2:Selecting Specific Columns
--Task 2.1:Display only the Name and Location of all libraries
SELECT LibraryName, LibraryLocation
FROM Libraries; 

--Task 2.2:Show the Title, Genre, and Price of all books
SELECT Title, Genre, Price
FROM Book;

--Task 2.3:List the FullName and Email of all members
SELECT FullName, Email
FROM Members;

--Task 2.4:Display StaffID, FullName, and Position from the Staff table
SELECT StaffID, FullName, Position
FROM Staff; 

--Part 3: Using WHERE Clause - Simple Conditions
--Task 3.1:Find all books with Genre = 'Fiction' 
SELECT *
FROM Book
WHERE Genre = 'Fiction';

--Task 3.2: Retrieve all libraries located in 'Muscat'
SELECT *
FROM Libraries
WHERE LibraryLocation = 'Muscat';

--Task 3.3: Display all books where IsAvailable = TRUE (or 1)
SELECT *
FROM Book
WHERE IsAvailable = 1;

--Task 3.4: Find all staff members with Position = 'Librarian'
SELECT *
FROM Staff
WHERE Position = 'Librarian'; 

--Task 3.5: Show all loans with Status = 'Overdue'
SELECT *
FROM Loan 
WHERE LStatus = 'Overdue';

--Part 4: Comparison Operators
--Task 4.1: Find all books with Price greater than 20
SELECT *
FROM Book
WHERE Price > 20; 

--Task 4.2: Retrieve libraries established before 2010
SELECT *
FROM Libraries
WHERE EstablishedYear < 2010; 

--Task 4.3: Find all payments with Amount >= 3
SELECT *
FROM Payment
WHERE Amount >= 3; 

--Task 4.4: Show books where Price is less than or equal to 15
SELECT *
FROM Book
WHERE Price <= 15; 

--Task 4.5: Display reviews with Rating not equal to 5
SELECT *
FROM Review
WHERE Rating <> 5; 

--Part 5: Logical Operators (AND, OR, NOT)
--Task 5.1: Find books that are Fiction AND available
SELECT *
FROM Book
WHERE Genre = 'Fiction' AND IsAvailable = 1;

--Task 5.2: Retrieve books where Genre is 'Fiction' OR 'Children'
SELECT *
FROM Book
WHERE Genre = 'Fiction' OR Genre = 'Children';

--Task 5.3: Find libraries established after 2010 AND located in 'Ibra'
SELECT *
FROM Libraries
WHERE EstablishedYear > 2010 AND LibraryLocation = 'Ibra'; 

--Task 5.4: Show books with Price between 10 AND 30
SELECT *
FROM Book
WHERE Price >= 10 AND Price <= 30;

--Task 5.5: Display loans that are NOT 'Returned'
SELECT *
FROM Loan
WHERE LStatus <> 'Returned';

--Part 6: ORDER BY Clause
--Task 6.1: List all books ordered by Title in ascending order (A–Z)
SELECT *
FROM Book
ORDER BY Title ASC; 

--Task 6.2: Show all books ordered by Price in descending order (highest first)
SELECT *
FROM Book
ORDER BY Price DESC; 

--Task 6.3: Display members ordered by MembershipStartDate, newest first
SELECT *
FROM Members
ORDER BY MembershipStartDate DESC; 

--Task 6.4: List libraries ordered by EstablishedYear in ascending order (oldest first)
SELECT *
FROM Libraries
ORDER BY EstablishedYear ASC;

--Task 6.5: Show reviews ordered by Rating DESC, then by ReviewDate ASC
SELECT *
FROM Review
ORDER BY Rating DESC, ReviewDate ASC; 