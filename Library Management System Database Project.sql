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

--Day 2: Advanced SELECT Queries

--Part 7: DISTINCT Keyword
--Task 7.1:List all unique book genres from the Books table
SELECT DISTINCT Genre
FROM Book;

--Task 7.2: Show all unique locations from the Library table
SELECT DISTINCT LibraryLocation
FROM Libraries; 

--Task 7.3: Display all unique staff positions from the Staff table
SELECT DISTINCT Position
FROM Staff;

--Task 7.4: Find all unique loan statuses from the Loans table
SELECT DISTINCT LStatus
FROM Loan;

--Part 8: TOP/LIMIT Clause
--Task 8.1: Display the top 5 most expensive books (ordered by Price DESC).
SELECT TOP 5 *
FROM Book
ORDER BY Price DESC;

--Task 8.2: Show the first 10 members who joined
SELECT TOP 10 *
FROM Members
ORDER BY MembershipStartDate ASC;

--Task 8.3: Retrieve the 3 oldest libraries
SELECT TOP 3 *
FROM Libraries
ORDER BY EstablishedYear ASC;

--Task 8.4: Display the top 5 highest-rated reviews
SELECT TOP 5 *
FROM Review
ORDER BY Rating DESC;

--Part 9: LIKE Operator for Pattern Matching
--Task 9.1: Find all books whose title starts with 'The'
SELECT *
FROM Book
WHERE Title LIKE 'The%'; 

--Task 9.2: Retrieve members whose email contains 'gmail.com'
SELECT *
FROM Members
WHERE Email LIKE '%example.com%';

--Task 9.3: Find all libraries whose name ends with 'Library'
SELECT *
FROM Libraries
WHERE LibraryName LIKE '%Library';

--Task 9.4: Show books with titles containing the word 'Code' anywhere in the title
SELECT *
FROM Book
WHERE Title LIKE '%Code%';

--Task 9.5: Find staff members whose names start with 'H'
SELECT *
FROM Staff
WHERE FullName LIKE 'H%'; 

--Part 10: Working with NULL Values
--Task 10.1: Find all loans where ReturnDate IS NULL
SELECT *
FROM Loan
WHERE ReturnDate IS NULL; 

--Task 10.2: Show all loans where ReturnDate IS NOT NULL
SELECT *
FROM Loan
WHERE ReturnDate IS NOT NULL;

--Task 10.3: Display reviews where Comments IS NULL or equals 'No comments'
SELECT *
FROM Review 
WHERE Comments IS NULL OR Comments = 'No comments';

--Part 11: Complex Combined Queries
--Task 11.1: Find all Fiction books that are available and cost less than $25, ordered by price
SELECT *
FROM Book
WHERE Genre = 'Fiction'
  AND IsAvailable = 1
  AND Price < 25
ORDER BY Price ASC;

--Task 11.2: Retrieve the top 5 most recent overdue loans
SELECT TOP 5 *
FROM Loan
WHERE LStatus = 'Overdue'
ORDER BY DueDate DESC;

--Task 11.3: Show all libraries in 'Barka' or 'Muscat' established after 2005, ordered by name
SELECT *
FROM Libraries
WHERE (LibraryLocation = 'Barka' OR LibraryLocation = 'Muscat')
  AND EstablishedYear > 2005
ORDER BY LibraryName ASC

--Task 11.4: Find books with 'Fiction' or 'Children' genre, price between $10–$30, currently available
SELECT *
FROM Book
WHERE (Genre = 'Fiction' OR Genre = 'Children')
  AND Price >= 10 AND Price <= 30
  AND IsAvailable = 1;

--Task 11.5: Display members who joined in 2023 or 2026, with Gmail accounts, ordered by join date
SELECT *
FROM Members
WHERE (YEAR(MembershipStartDate) = 2023
    OR YEAR(MembershipStartDate) = 2026)
  AND Email LIKE '%example.com%'
ORDER BY MembershipStartDate ASC;

--Part 12: Challenge Queries
--Task 12.1: Find the 10 most expensive available books in 'Fiction' or 'Non-fiction' genres
SELECT TOP 10 *
FROM Book
WHERE IsAvailable = 1
  AND (Genre = 'Fiction' OR Genre = 'Non-fiction')
ORDER BY Price DESC;

--Task 12.2: Find all loans issued in 2026 that are still not returned, ordered by loan date
SELECT *
FROM Loan
WHERE YEAR(LoanDate) = 2026
  AND ReturnDate IS NULL
ORDER BY LoanDate ASC;

--Task 12.3: Show staff working at libraries established before 2010, with position 'Librarian' or 'Assistant'
SELECT S.*
FROM Staff S
JOIN Libraries L ON S.LID = L.LibraryID 
WHERE L.EstablishedYear < 2010
  AND (S.Position = 'Librarian' OR S.Position = 'Assistant');

--Task 12.4: Display all books that have never been reviewed
SELECT B.*
FROM Book B
LEFT JOIN Review R ON B.BookID = R.BID
WHERE R.BID IS NULL;

--SQL JOIN

--Session 1: Understanding the Concept
--Task 1.1: Look at the Loan table. Which column connects it to the Member table?
--Answer: MemberID 

--Task 1.2: Which column connects the Loan table to the Book table?
--Answer: BookID

--Task 1.3: Which column connects the Staff table to the Library table?
--Answer: LibraryID

--Task 1.4: Which column connects the Review table to the Book table?
--Answer: BookID

--Session 2: INNER JOIN - Matching Data
--Part A: Two-Table INNER JOINs
--Task 2.1: Display all loans with the book titles
SELECT L.LoanID, B.Title, L.LoanDate, L.DueDate
FROM Loan L
INNER JOIN Book B
ON L.BID = B.BookID;

--Task 2.2: Show all staff members with their library names
SELECT S.FullName, S.Position, L.LibraryName, L.LibraryLocation
FROM Staff S
INNER JOIN Libraries L
ON S.LID = L.LibraryID; 

--Task 2.3: Display all books with their library information
SELECT B.Title, B.Genre, B.Price, L.LibraryName, L.LibraryLocation
FROM Book B
INNER JOIN Libraries L
ON B.LID = L.LibraryID; 

--Task 2.4: Show all reviews with member names
SELECT M.FullName, R.Rating, R.Comments, R.ReviewDate
FROM Review R
INNER JOIN Members M
ON R.MID = M.MemberID;

--Task 2.5: Display all reviews with book titles
SELECT B.Title, R.Rating, R.Comments, R.ReviewDate
FROM Review R
INNER JOIN Book B
ON R.BID = B.BookID;

--Task 2.6: Show all payments with loan information
SELECT L.LoanID, P.PaymentDate, P.Amount, P.Method, L.LStatus
FROM Payment P
INNER JOIN Loan L
ON P.LoanID = L.LoanID; 

--Part B: Three-Table INNER JOINs
--Task 2.7: Show member names, book titles, and loan dates together
SELECT M.FullName, B.Title, L.LoanDate, L.DueDate, L.LStatus
FROM Members M
INNER JOIN Loan L
ON M.MemberID = L.MID
INNER JOIN Book B
ON L.BID = B.BookID;

--Task 2.8: Display reviews with both member names and book titles
SELECT M.FullName, B.Title, R.Rating, R.Comments
FROM Review R
INNER JOIN Members M
ON R.MID = M.MemberID
INNER JOIN Book B
ON R.BID = B.BookID;

--Task 2.9: Show books with their library name and location
SELECT B.Title, B.Genre, L.LibraryName, L.LibraryLocation, L.ContactNumber
FROM Book B
INNER JOIN Libraries L
ON B.LID = L.LibraryID;

--Task 2.10: Display complete loan information: member name, book title, loan dates, and status
SELECT M.FullName, M.Email, B.Title, B.Genre, L.LoanDate, L.DueDate, L.ReturnDate, L.LStatus
FROM Members M
INNER JOIN Loan L
ON M.MemberID = L.MID
INNER JOIN Book B
ON L.BID = B.BookID;

--Session 3: LEFT JOIN - Keep All Left Records
--Task 3.1: Show ALL books and their reviews (if any)
SELECT B.Title, B.Genre, R.Rating, R.Comments
FROM Book B
LEFT JOIN Review R
ON B.BookID = R.BID; 

--Task 3.2: Display ALL members with their loan information (if they have any loans)
SELECT M.FullName, M.Email, L.LoanDate, L.DueDate, L.LStatus 
FROM Members M
LEFT JOIN Loan L
ON M.MemberID = L.MID;

--Task 3.3: Show ALL loans with payment information (if any)
SELECT L.LoanID, L.LoanDate, L.LStatus, P.PaymentDate, P.Amount
FROM Loan L
LEFT JOIN Payment P
ON L.LoanID = P.LoanID;

--Task 3.4: Display ALL libraries with their staff (if any)
SELECT L.LibraryName, L.LibraryLocation, S.FullName, S.Position
FROM Libraries L
LEFT JOIN Staff S
ON L.LibraryID = S.LID;

--Task 3.5: Find members who have NEVER borrowed a book
SELECT M.FullName, M.Email
FROM Members M
LEFT JOIN Loan L
ON M.MemberID = L.MID
WHERE L.LoanID IS NULL;

--Task 3.6: Find books that have NEVER been reviewed
SELECT B.Title, B.Genre, B.Price
FROM Book B
LEFT JOIN Review R
ON B.BookID = R.BID
WHERE R.ReviewID IS NULL;

--Task 3.7: Show ALL books with member names who reviewed them (if reviewed)
SELECT B.Title, M.FullName, R.Rating, R.Comments
FROM Book B
LEFT JOIN Review R
ON B.BookID = R.BID
LEFT JOIN Members M
ON R.MID = M.MemberID;

--Session 4: RIGHT JOIN - Keep All Right Records
--Task 4.1: Rewrite Task 3.1 using RIGHT JOIN instead of LEFT JOIN
SELECT B.Title, B.Genre, R.Rating, R.Comments
FROM Review R
RIGHT JOIN Book B
ON R.BID = B.BookID;

--Task 4.2: Show ALL members with their loans using RIGHT JOIN
SELECT M.FullName, M.Email, L.LoanDate, L.DueDate, L.LStatus
FROM Loan L
RIGHT JOIN Members M
ON M.MemberID = L.MID;

--Task 4.3: Display ALL books using RIGHT JOIN with Library table
SELECT L.LibraryName, B.Title, B.Genre
FROM Libraries L
RIGHT JOIN Book B
ON L.LibraryID = B.LID;

--Task 4.4: Compare the results (same query using LEFT JOIN and RIGHT JOIN)
--A) Using LEFT JOIN
SELECT S.FullName, S.Position, L.LibraryName, L.LibraryLocation
FROM Staff S
LEFT JOIN Libraries L
ON S.LID = L.LibraryID;

--B) Using RIGHT JOIN (same result, tables swapped)
SELECT S.FullName, S.Position, L.LibraryName, L.LibraryLocation
FROM Libraries L
RIGHT JOIN Staff S
ON S.LID = L.LibraryID;

--Session 5: FULL OUTER JOIN - Keep Everything
--Task 5.1: Show ALL books and ALL reviews (whether matched or not)
SELECT B.Title, R.Rating, R.Comments
FROM Book B
FULL OUTER JOIN Review R
ON B.BookID = R.BID;

--Task 5.2: Display ALL loans and ALL payments
SELECT L.LoanID, L.LoanDate, P.PaymentDate, P.Amount
FROM Loan L
FULL OUTER JOIN Payment P
ON L.LoanID = P.LoanID;

--Task 5.3: Show complete data: ALL members and ALL books (through loans)
SELECT M.FullName, B.Title, L.LoanDate, L.DueDate, L.LStatus
FROM Members M
FULL OUTER JOIN Loan L
ON M.MemberID = L.MID
FULL OUTER JOIN Book B
ON L.BID = B.BookID;

--Session 6: Combining Multiple JOIN Types
--Task 6.1: Show all ACTIVE loans (INNER JOIN) with member info and payment info (LEFT JOIN for payments)
SELECT M.FullName, L.LoanDate, L.DueDate, L.LStatus, P.PaymentDate, P.Amount
FROM Loan L
INNER JOIN Members M
ON M.MemberID = L.MID
LEFT JOIN Payment P
ON L.LoanID = P.LoanID
WHERE L.LStatus = 'Active';

--Task 6.2: Display all books (INNER JOIN Library) and their reviews (LEFT JOIN Review)
SELECT L.LibraryName, B.Title, B.Genre, R.Rating, R.Comments
FROM Libraries L
INNER JOIN Book B
ON L.LibraryID = B.LID
LEFT JOIN Review R
ON B.BookID = R.BID;

--Task 6.3: Show member borrowing history with book and library information
SELECT M.FullName, B.Title, Lb.LibraryName, Ln.LoanDate, Ln.ReturnDate
FROM Members M
INNER JOIN Loan Ln
ON M.MemberID = Ln.MID
INNER JOIN Book B
ON Ln.BID = B.BookID
INNER JOIN Libraries Lb
ON B.LID = Lb.LibraryID;

--Session 7: Real-World Challenge Queries
--Challenge 7.1: Library Performance Report
SELECT L.LibraryName,
       COUNT(DISTINCT B.BookID),
       COUNT(DISTINCT S.StaffID),
       COUNT(DISTINCT Ln.LoanID)
FROM Libraries L
LEFT JOIN Book B
ON L.LibraryID = B.LID
LEFT JOIN Staff S
ON L.LibraryID = S.LID
LEFT JOIN Loan Ln
ON B.BookID = Ln.BID
GROUP BY L.LibraryName;

--Challenge 7.2: Member Activity Summary
SELECT M.FullName, M.Email,
       COUNT(DISTINCT Ln.LoanID),
       COUNT(DISTINCT R.ReviewID)
FROM Members M
LEFT JOIN Loan Ln
ON M.MemberID = Ln.MID
LEFT JOIN Review R
ON M.MemberID = R.MID
GROUP BY M.FullName, M.Email;

--Challenge 7.3: Book Popularity Analysis
SELECT B.Title, L.LibraryName,
       COUNT(DISTINCT Ln.LoanID),
       AVG(R.Rating),
       COUNT(DISTINCT R.ReviewID)
FROM Book B
INNER JOIN Libraries L
ON B.LID = L.LibraryID
LEFT JOIN Loan Ln
ON B.BookID = Ln.BID
LEFT JOIN Review R
ON B.BookID = R.BID
GROUP BY B.Title, L.LibraryName;

--Challenge 7.4: Overdue Books Report
SELECT M.FullName, M.Email, B.Title, L.LibraryName,
       DATEDIFF(DAY, Ln.DueDate, GETDATE()),
       P.Amount
FROM Loan Ln
INNER JOIN Members M
ON M.MemberID = Ln.MID
INNER JOIN Book B
ON Ln.BID = B.BookID
INNER JOIN Libraries L
ON B.LID = L.LibraryID
LEFT JOIN Payment P
ON Ln.LoanID = P.LoanID
WHERE Ln.LStatus = 'Overdue';

--Challenge 7.5: Complete Member Loan History
SELECT M.FullName, B.Title, B.Genre, L.LibraryLocation,
       Ln.LoanDate, Ln.ReturnDate,
       DATEDIFF(DAY, Ln.LoanDate, Ln.ReturnDate),
       R.Rating
FROM Members M
INNER JOIN Loan Ln
ON M.MemberID = Ln.MID
INNER JOIN Book B
ON Ln.BID = B.BookID
INNER JOIN Libraries L
ON B.LID = L.LibraryID
LEFT JOIN Review R
ON R.MID = M.MemberID
AND R.BID = B.BookID;

--Challenge 7.6: Books Never Borrowed
SELECT B.Title, B.Genre, B.Price, L.LibraryName
FROM Book B
INNER JOIN Libraries L
ON B.LID = L.LibraryID
LEFT JOIN Loan Ln
ON B.BookID = Ln.BID
WHERE Ln.LoanID IS NULL;

--Challenge 7.7: Members With No Activity
SELECT M.FullName, M.Email
FROM Members M
LEFT JOIN Loan Ln
ON M.MemberID = Ln.MID
LEFT JOIN Review R
ON M.MemberID = R.MID
WHERE Ln.LoanID IS NULL
AND R.ReviewID IS NULL;

--Challenge 7.8: Staff Workload Analysis
SELECT S.FullName, S.Position, L.LibraryName,
       COUNT(DISTINCT B.BookID),
       COUNT(DISTINCT Ln.LoanID)
FROM Staff S
INNER JOIN Libraries L
ON S.LID = L.LibraryID
LEFT JOIN Book B
ON L.LibraryID = B.LID
LEFT JOIN Loan Ln
ON B.BookID = Ln.BID
AND Ln.LStatus = 'Active'
GROUP BY S.FullName, S.Position, L.LibraryName;

