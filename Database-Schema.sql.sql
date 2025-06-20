/* (Database Fundamentals, Assignment Part D, Autumn 2025 */
/* First author's name: Shayan Ali (SID: 25555501)*/
/* First author's email: shayan.ali@student.uts.edu.au */
/* Second author's name: Ryea D'souza (SID: 25473176)*/
/* Second author's email: ryea.f.dsouza@student.uts.edu.au */
/* script name: PartD.SQL */
/* purpose:     Builds PostgreSQL tables for a Real Estate Listing Platform database */
/* date:        21/05/2025 */
/* The URL for the website that inspired this project is https://www.realestate.com.au/ */

--====================================================================
-- Drop the tables below 

DROP TABLE IF EXISTS "Application";
DROP TABLE IF EXISTS "Listing";
DROP TABLE IF EXISTS "User";

--====================================================================
-- Create and insert into the tables below

-- User Table
CREATE TABLE "User" (
    "Email_Address" VARCHAR(255) NOT NULL,
    "First_Name" VARCHAR(50) NOT NULL,
    "Last_Name" VARCHAR(50) NOT NULL,
    "Phone_Number" VARCHAR(20),
    "User_Type" VARCHAR(50) NOT NULL, -- e.g., 'Buyer', 'Renter', 'Prospective Tenant'
    "Creation_Date" DATE NOT NULL,
    CONSTRAINT PK_User PRIMARY KEY ("Email_Address")
);

INSERT INTO "User" ("Email_Address", "First_Name", "Last_Name", "Phone_Number", "User_Type", "Creation_Date") VALUES
('alice.wonder@example.com', 'Alice', 'Wonder', '0401123456', 'Renter', '2023-01-15'),
('bob.builder@example.com', 'Bob', 'Builder', '0402234567', 'Buyer', '2023-02-20'),
('carol.danvers@example.com', 'Carol', 'Danvers', '0403345678', 'Renter', '2023-03-10'),
('david.copper@example.com', 'David', 'Copper', '0404456789', 'Buyer', '2023-04-05'),
('eve.online@example.com', 'Eve', 'Online', '0405567890', 'Renter', '2023-05-25'),
('frank.castle@example.com', 'Frank', 'Castle', '0406678901', 'Buyer', '2023-06-12');

-- Listing Table
CREATE TABLE "Listing" (
    "Listing_Reference_Number" VARCHAR(50) NOT NULL,
    "Listing_Type" VARCHAR(50) NOT NULL, -- e.g., 'For Sale', 'For Rent'
    "Price" DECIMAL(12, 2) NOT NULL,
    "Listing_Date" DATE NOT NULL,
    "Status" VARCHAR(50) NOT NULL, -- e.g., 'Available', 'Under Offer', 'Leased', 'Sold'
    "Property_Address_FK" VARCHAR(255) NOT NULL, -- Simulating FK to a Property Address
    CONSTRAINT PK_Listing PRIMARY KEY ("Listing_Reference_Number")
);

INSERT INTO "Listing" ("Listing_Reference_Number", "Listing_Type", "Price", "Listing_Date", "Status", "Property_Address_FK") VALUES
('LST-RENT-001', 'For Rent', 750.00, '2024-05-01', 'Available', '123 Main St, Sydney, NSW 2000'),
('LST-SALE-001', 'For Sale', 850000.00, '2024-04-15', 'Available', '456 Oak Ave, Melbourne, VIC 3000'),
('LST-RENT-002', 'For Rent', 600.00, '2024-05-10', 'Leased', '789 Pine Rd, Brisbane, QLD 4000'),
('LST-SALE-002', 'For Sale', 1200000.00, '2024-03-20', 'Under Offer', '101 Elm St, Perth, WA 6000'),
('LST-RENT-003', 'For Rent', 950.00, '2024-06-01', 'Available', '202 Birch Ln, Adelaide, SA 5000'),
('LST-SALE-003', 'For Sale', 650000.00, '2024-06-05', 'Available', '303 Cedar Cres, Hobart, TAS 7000');

-- Application Table (Associative Entity)
CREATE TABLE "Application" (
    "User_Email_FK" VARCHAR(255) NOT NULL,
    "Listing_Reference_Number_FK" VARCHAR(50) NOT NULL,
    "Application_Date" DATE NOT NULL,
    "Status" VARCHAR(50) NOT NULL, -- e.g., 'Submitted', 'Under Review', 'Approved', 'Rejected'
    "Details" TEXT,
    CONSTRAINT PK_Application PRIMARY KEY ("User_Email_FK", "Listing_Reference_Number_FK", "Application_Date"),
    CONSTRAINT FK_Application_User FOREIGN KEY ("User_Email_FK") REFERENCES "User"("Email_Address"),
    CONSTRAINT FK_Application_Listing FOREIGN KEY ("Listing_Reference_Number_FK") REFERENCES "Listing"("Listing_Reference_Number")
);

INSERT INTO "Application" ("User_Email_FK", "Listing_Reference_Number_FK", "Application_Date", "Status", "Details") VALUES
('alice.wonder@example.com', 'LST-RENT-001', '2024-05-05', 'Submitted', 'Interested in a 12-month lease. Good rental history.'),
('bob.builder@example.com', 'LST-SALE-001', '2024-04-20', 'Under Review', 'Submitted offer, pending finance approval.'),
('carol.danvers@example.com', 'LST-RENT-001', '2024-05-06', 'Approved', 'Application accepted, lease sent.'),
('david.copper@example.com', 'LST-SALE-002', '2024-03-25', 'Submitted', 'Cash offer, ready to proceed quickly.'),
('eve.online@example.com', 'LST-RENT-003', '2024-06-02', 'Submitted', 'Looking for a quiet place, stable income.'),
('alice.wonder@example.com', 'LST-RENT-003', '2024-06-03', 'Rejected', 'Landlord chose another applicant.');


--=================================================================================================
-- Select * from TableName Statements
-- Note: Please write the “select * from TableName” statements in one line.

-- 2.b.1: Question: Get all information of all users stored in the database.
-- 2.b.1: Select all records from the "User" table
SELECT * FROM "User";

-- 2.b.2: Question: Get all information of all listings stored in the database.
-- 2.b.2:  Select all records from the "Listing" table.
SELECT * FROM "Listing";

-- 2.b.3: Question: Get all information of all applications stored in the database.
-- 2.b.3: Select all records from the "Application" table
SELECT * FROM "Application";

--=================================================================================================
-- 3.a: Question: Calculate the total number of applications received for each listing.
-- 3.a: SELECT statement using Group by:
SELECT "Listing_Reference_Number_FK", COUNT(*) AS "Number_Of_Applications" FROM "Application" GROUP BY "Listing_Reference_Number_FK" ORDER BY "Number_Of_Applications" DESC;

-- 3.b: Question: List user names, applied listing type and price, application date, and application status for all applications.
-- 3.b: SELECT statement using Inner Join:
SELECT U."First_Name", U."Last_Name", L."Listing_Type", L."Price", A."Application_Date", A."Status" AS "Application_Status" FROM "User" U INNER JOIN "Application" A ON U."Email_Address" = A."User_Email_FK" INNER JOIN "Listing" L ON A."Listing_Reference_Number_FK" = L."Listing_Reference_Number";

-- 3.c: Question: List the email addresses and names of users who have applied for listings with a sale price above $800,000.
-- 3.c: SELECT statement using Sub Query:
SELECT "Email_Address", "First_Name", "Last_Name" FROM "User" WHERE "Email_Address" IN ( SELECT "User_Email_FK" FROM "Application" WHERE "Listing_Reference_Number_FK" IN ( SELECT "Listing_Reference_Number" FROM "Listing" WHERE "Listing_Type" = 'For Sale' AND "Price" > 800000.00 ) );



