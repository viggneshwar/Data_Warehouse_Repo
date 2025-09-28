-- Dim Customers (SCD1 style overwrite)
INSERT INTO edwdb.dim_customers (
    CustomerID,
    FirstName,
    LastName,
    Email,
    PhoneNumber,
    Address,
    DateOfBirth,
    BranchID,
    effective_date
)
SELECT DISTINCT
    CustomerID,
    FirstName,
    LastName,
    Email,
    PhoneNumber,
    Address,
    DateOfBirth,
    BranchID,
    CURRENT_DATE
FROM odsdb.ods_cust_profile;

-- Dim Branches (SCD2 style - new rows for changes)
INSERT INTO edwdb.dim_branches (
    Address,
    BranchID,
    BranchName,
    City,
    State,
    Zipcode,
    start_date,
    end_date,
    is_current
)
SELECT
    Address,
    BranchID,
    BranchName,
    City,
    State,
    Zipcode,
    CURRENT_DATE,
    NULL,
    1
FROM odsdb.ods_branches;


-- Dim Employees
INSERT INTO edwdb.dim_employees (
    BranchID,
    EmployeeID,
    FirstName,
    Hiredate,
    LastName,
    ManagerID,
    Position
)
SELECT
    BranchID,
    EmployeeID,
    FirstName,
    Hiredate,
    LastName,
    ManagerID,
    Position
FROM odsdb.ods_employees;

-- Dim Loans
INSERT INTO edwdb.dim_loans (
    Amount,
    Collateral,
    CustomerID,
    EndDate,
    InterestRate,
    LoanID,
    LoanType,
    PaymentFrequency,
    StartDate,
    Status
)
SELECT
    Amount,
    Collateral,
    CustomerID,
    EndDate,
    InterestRate,
    LoanID,
    LoanType,
    PaymentFrequency,
    StartDate,
    Status
FROM odsdb.ods_loans;

INSERT INTO edwdb.fact_loans (
    LoanID,
    CustomerID,
    BranchID,
    Amount,
    InterestRate,
    StartDate,
    EndDate,
    PaymentFrequency,
    Status,
    OutstandingBalance,
    LoanDurationMonths,
    RiskIndicator,
    HighValueFlag,
    load_dt,
    load_ts
)
SELECT distinct
    o.LoanID,
    c.CustomerID,          -- from dim_customers
    b.BranchID,            -- from dim_branches
    o.Amount,
    o.InterestRate,
    o.StartDate,
    o.EndDate,
    o.PaymentFrequency,
    o.Status,
    o.Amount AS OutstandingBalance,
    TIMESTAMPDIFF(MONTH, o.StartDate, o.EndDate) AS LoanDurationMonths,
    CASE 
        WHEN o.InterestRate > 12 THEN 'HIGH'
        WHEN o.InterestRate BETWEEN 8 AND 12 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS RiskIndicator,

    CASE 
        WHEN o.Amount >= 1000000 THEN 'Y'
        ELSE 'N'
    END AS HighValueFlag,
    CURRENT_DATE,
    CURRENT_TIMESTAMP
FROM odsdb.ods_loans o
LEFT JOIN edwdb.dim_customers c
    ON o.CustomerID = c.CustomerID
LEFT JOIN edwdb.dim_branches b
    ON c.BranchID = b.BranchID
   AND b.is_current = 1;

-- Fact Transactions with transaction_flag derivation
INSERT INTO trans_mart.fact_transactions (
    AccountID,
    Amount,
    Currency,
    Description,
    EventTs,
    Status,
    Suspicious,
    TransactionDate,
    TransactionFee,
    TransactionID,
    TransactionType,
    transaction_flag
)
SELECT
    AccountID,
    Amount,
    Currency,
    Description,
    EventTs,
    Status,
    Suspicious,
    TransactionDate,
    TransactionFee,
    TransactionID,
    TransactionType,
    CASE WHEN Suspicious THEN 'FLAGGED' ELSE 'NORMAL' END
FROM odsdb.ods_transactions;


-- Fact Payments with derived AmountInBaseCurrency
INSERT INTO payment_mart.fact_payments (
    Amount,
    AuditTrial,
    ClearingSystem,
    Currency,
    CustomerSegment,
    Description,
    ExchangeRate,
    Fee,
    FromAccountID,
    MerchantName,
    PaymentDate,
    PaymentID,
    PaymentType,
    ToAccountID,
    AmountInBaseCurrency
)
SELECT
    Amount,
    AuditTrial,
    ClearingSystem,
    Currency,
    CustomerSegment,
    Description,
    ExchangeRate,
    Fee,
    FromAccountID,
    MerchantName,
    PaymentDate,
    PaymentID,
    PaymentType,
    ToAccountID,
    Amount * ExchangeRate
FROM odsdb.ods_payments;

-- Star Schema Model: Fact Creditcard with UtilizationPercent
INSERT INTO cc_mart.fact_creditcard (
    customerid,
    loanid,
    employeeid,
    firstname,
    phonenumber,
    cardid,
    cardtype,
    balance,
    creditlimit,
    billcycle,
    issuedate,
    utilization_percent,
    load_dt,
    load_ts
)
SELECT
    oc.customerid,
    dl.loanid,
    de.employeeid,
    dcu.firstname,
    dcu.phonenumber,
    oc.cardid,
    oc.cardtype,
    oc.balance,
    oc.creditlimit,
    oc.billcycle,
    oc.issuedate,
    ROUND((oc.balance / oc.creditlimit) * 100, 2) AS utilization_percent,
    oc.load_dt,
    oc.load_ts
FROM odsdb.ods_creditcard oc
LEFT JOIN edwdb.dim_customers dcu 
    ON oc.customerid = dcu.customerid
LEFT JOIN edwdb.dim_loans dl 
    ON oc.customerid = dl.customerid
LEFT JOIN edwdb.dim_employees de 
    ON dcu.branchid = de.branchid
WHERE oc.load_dt = (
        SELECT MAX(load_dt) 
        FROM odsdb.ods_creditcard
    );