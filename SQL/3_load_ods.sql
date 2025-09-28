-- ODS loads from staging with exact copy
-- ODS Load from Staging with load_dt and load_ts

INSERT INTO odsdb.ods_accounts
SELECT a.*, 
       CURRENT_DATE AS load_dt, 
       CURRENT_TIMESTAMP AS load_ts
FROM stgdb.stg_accounts a;

INSERT INTO odsdb.ods_transactions
SELECT t.*, 
       CURRENT_DATE AS load_dt, 
       CURRENT_TIMESTAMP AS load_ts
FROM stgdb.stg_transactions t;

INSERT INTO odsdb.ods_payments
SELECT p.*, 
       CURRENT_DATE AS load_dt, 
       CURRENT_TIMESTAMP AS load_ts
FROM stgdb.stg_payments p;

INSERT INTO odsdb.ods_creditcard
SELECT c.*, 
       CURRENT_DATE AS load_dt, 
       CURRENT_TIMESTAMP AS load_ts
FROM stgdb.stg_creditcard c;

INSERT INTO odsdb.ods_loans
SELECT l.*, 
       CURRENT_DATE AS load_dt, 
       CURRENT_TIMESTAMP AS load_ts
FROM stgdb.stg_loans l;

INSERT INTO odsdb.ods_cust_profile
SELECT Address,
    BranchID,
    CustomerID,
    DateOfBirth,
    Email,
    FirstName,
    LastName,
    substr(PhoneNumber,1,20), 
    CURRENT_DATE AS load_dt, 
    CURRENT_TIMESTAMP AS load_ts
FROM stgdb.stg_cust_profile cp;

INSERT INTO odsdb.ods_branches
SELECT b.*, 
       CURRENT_DATE AS load_dt, 
       CURRENT_TIMESTAMP AS load_ts
FROM stgdb.stg_branches b;

INSERT INTO odsdb.ods_employees
SELECT e.*, 
       CURRENT_DATE AS load_dt, 
       CURRENT_TIMESTAMP AS load_ts
FROM stgdb.stg_employees e;