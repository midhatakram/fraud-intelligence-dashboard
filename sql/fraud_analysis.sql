USE CreditCard_Fraud_Intelligence_DB;
GO
select top 10 * from raw_FraudTransactions;
select count(*) as totalrows from raw_FraudTransactions;

SELECT
    is_fraud,
    COUNT(*) AS TransactionCount,
    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS Percentage
FROM raw_FraudTransactions
GROUP BY is_fraud;

SELECT
    MIN(trans_date_trans_time) AS FirstTransaction,
    MAX(trans_date_trans_time) AS LastTransaction
FROM raw_FraudTransactions;

SELECT
    trans_num,
    COUNT(*) AS DuplicateCount
FROM raw_FraudTransactions
GROUP BY trans_num
HAVING COUNT(*) > 1;

SELECT
    COUNT(DISTINCT cc_num) AS UniqueCards,
    COUNT(DISTINCT merchant) AS UniqueMerchants,
    COUNT(DISTINCT category) AS UniqueCategories,
    COUNT(DISTINCT state) AS UniqueStates
FROM raw_FraudTransactions;

SELECT
    COUNT(*) AS TotalRows,

    SUM(CASE WHEN trans_date_trans_time IS NULL THEN 1 ELSE 0 END) AS Null_DateTime,
    SUM(CASE WHEN cc_num IS NULL THEN 1 ELSE 0 END) AS Null_Card,
    SUM(CASE WHEN merchant IS NULL THEN 1 ELSE 0 END) AS Null_Merchant,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS Null_Category,
    SUM(CASE WHEN amt IS NULL THEN 1 ELSE 0 END) AS Null_Amount,
    SUM(CASE WHEN first IS NULL THEN 1 ELSE 0 END) AS Null_FirstName,
    SUM(CASE WHEN last IS NULL THEN 1 ELSE 0 END) AS Null_LastName,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS Null_Gender,
    SUM(CASE WHEN street IS NULL THEN 1 ELSE 0 END) AS Null_Street,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS Null_City,
    SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS Null_State,
    SUM(CASE WHEN zip IS NULL THEN 1 ELSE 0 END) AS Null_Zip,
    SUM(CASE WHEN lat IS NULL THEN 1 ELSE 0 END) AS Null_Latitude,
    SUM(CASE WHEN long IS NULL THEN 1 ELSE 0 END) AS Null_Longitude,
    SUM(CASE WHEN city_pop IS NULL THEN 1 ELSE 0 END) AS Null_CityPopulation,
    SUM(CASE WHEN job IS NULL THEN 1 ELSE 0 END) AS Null_Job,
    SUM(CASE WHEN dob IS NULL THEN 1 ELSE 0 END) AS Null_DOB,
    SUM(CASE WHEN trans_num IS NULL THEN 1 ELSE 0 END) AS Null_TransactionID,
    SUM(CASE WHEN unix_time IS NULL THEN 1 ELSE 0 END) AS Null_UnixTime,
    SUM(CASE WHEN merch_lat IS NULL THEN 1 ELSE 0 END) AS Null_MerchantLatitude,
    SUM(CASE WHEN merch_long IS NULL THEN 1 ELSE 0 END) AS Null_MerchantLongitude,
    SUM(CASE WHEN is_fraud IS NULL THEN 1 ELSE 0 END) AS Null_FraudFlag

FROM raw_FraudTransactions;

SELECT
    MIN(TRY_CONVERT(DECIMAL(18,2), amt)) AS MinAmount,
    MAX(TRY_CONVERT(DECIMAL(18,2), amt)) AS MaxAmount,
    AVG(TRY_CONVERT(DECIMAL(18,2), amt)) AS AvgAmount,
    SUM(CASE
            WHEN TRY_CONVERT(DECIMAL(18,2), amt) <= 0
            THEN 1
            ELSE 0
        END) AS InvalidAmountCount
FROM raw_FraudTransactions;

SELECT
    SUM(CASE
            WHEN TRY_CONVERT(DECIMAL(10,6), lat) NOT BETWEEN -90 AND 90
            THEN 1
            ELSE 0
        END) AS InvalidCustomerLatitude,

    SUM(CASE
            WHEN TRY_CONVERT(DECIMAL(10,6), long) NOT BETWEEN -180 AND 180
            THEN 1
            ELSE 0
        END) AS InvalidCustomerLongitude,

    SUM(CASE
            WHEN TRY_CONVERT(DECIMAL(10,6), merch_lat) NOT BETWEEN -90 AND 90
            THEN 1
            ELSE 0
        END) AS InvalidMerchantLatitude,

    SUM(CASE
            WHEN TRY_CONVERT(DECIMAL(10,6), merch_long) NOT BETWEEN -180 AND 180
            THEN 1
            ELSE 0
        END) AS InvalidMerchantLongitude

FROM raw_FraudTransactions;

SELECT
    SUM(CASE WHEN TRY_CONVERT(DATETIME2, trans_date_trans_time) IS NULL THEN 1 ELSE 0 END) AS InvalidDateTime,
    SUM(CASE WHEN TRY_CONVERT(DECIMAL(18,2), amt) IS NULL THEN 1 ELSE 0 END) AS InvalidAmount,
    SUM(CASE WHEN TRY_CONVERT(DATE, dob) IS NULL THEN 1 ELSE 0 END) AS InvalidDOB,
    SUM(CASE WHEN TRY_CONVERT(BIGINT, unix_time) IS NULL THEN 1 ELSE 0 END) AS InvalidUnixTime,
    SUM(CASE WHEN TRY_CONVERT(INT, city_pop) IS NULL THEN 1 ELSE 0 END) AS InvalidPopulation,
    SUM(CASE WHEN TRY_CONVERT(DECIMAL(10,6), lat) IS NULL THEN 1 ELSE 0 END) AS InvalidLatitude,
    SUM(CASE WHEN TRY_CONVERT(DECIMAL(10,6), long) IS NULL THEN 1 ELSE 0 END) AS InvalidLongitude,
    SUM(CASE WHEN TRY_CONVERT(DECIMAL(10,6), merch_lat) IS NULL THEN 1 ELSE 0 END) AS InvalidMerchantLatitude,
    SUM(CASE WHEN TRY_CONVERT(DECIMAL(10,6), merch_long) IS NULL THEN 1 ELSE 0 END) AS InvalidMerchantLongitude,
    SUM(CASE WHEN TRY_CONVERT(INT, is_fraud) IS NULL THEN 1 ELSE 0 END) AS InvalidFraudFlag
FROM raw_FraudTransactions;


CREATE TABLE clean_FraudTransactions
(
    TransactionIndex INT,
    TransactionDateTime DATETIME2,
    CardNumber NVARCHAR(50),
    Merchant NVARCHAR(255),
    Category NVARCHAR(100),
    Amount DECIMAL(18,2),
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Gender NVARCHAR(20),
    Street NVARCHAR(255),
    City NVARCHAR(100),
    State NVARCHAR(50),
    ZipCode NVARCHAR(20),
    CustomerLatitude DECIMAL(10,6),
    CustomerLongitude DECIMAL(10,6),
    CityPopulation INT,
    Job NVARCHAR(150),
    DateOfBirth DATE,
    TransactionNumber NVARCHAR(100),
    UnixTime BIGINT,
    MerchantLatitude DECIMAL(10,6),
    MerchantLongitude DECIMAL(10,6),
    IsFraud BIT
);

INSERT INTO clean_FraudTransactions
(
    TransactionIndex,
    TransactionDateTime,
    CardNumber,
    Merchant,
    Category,
    Amount,
    FirstName,
    LastName,
    Gender,
    Street,
    City,
    State,
    ZipCode,
    CustomerLatitude,
    CustomerLongitude,
    CityPopulation,
    Job,
    DateOfBirth,
    TransactionNumber,
    UnixTime,
    MerchantLatitude,
    MerchantLongitude,
    IsFraud
)
SELECT
    TRY_CONVERT(INT, column1),
    TRY_CONVERT(DATETIME2, trans_date_trans_time),
    cc_num,
    merchant,
    category,
    TRY_CONVERT(DECIMAL(18,2), amt),
    first,
    last,
    gender,
    street,
    city,
    state,
    zip,
    TRY_CONVERT(DECIMAL(10,6), lat),
    TRY_CONVERT(DECIMAL(10,6), long),
    TRY_CONVERT(INT, city_pop),
    job,
    TRY_CONVERT(DATE, dob),
    trans_num,
    TRY_CONVERT(BIGINT, unix_time),
    TRY_CONVERT(DECIMAL(10,6), merch_lat),
    TRY_CONVERT(DECIMAL(10,6), merch_long),
    TRY_CONVERT(BIT, is_fraud)
FROM raw_FraudTransactions;

SELECT COUNT(*) AS CleanRows
FROM clean_FraudTransactions;

SELECT TOP 10 *
FROM clean_FraudTransactions;

EXEC sp_help 'clean_FraudTransactions';

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT TransactionNumber) AS UniqueTransactions,
    SUM(CASE
            WHEN LTRIM(RTRIM(TransactionNumber)) = ''
            THEN 1
            ELSE 0
        END) AS BlankTransactionNumbers
FROM clean_FraudTransactions;

SELECT @@DATEFIRST AS FirstDayOfWeek;

ALTER TABLE clean_FraudTransactions
ALTER COLUMN TransactionNumber NVARCHAR(100) NOT NULL; 

ALTER TABLE clean_FraudTransactions
ADD CONSTRAINT PK_clean_FraudTransactions
PRIMARY KEY (TransactionNumber);

EXEC sp_help 'clean_FraudTransactions';

--STEP 8 — Create our Analytical View

CREATE VIEW vw_FraudTransactionAnalysis
AS
SELECT
    TransactionNumber,
    CardNumber,
    TransactionDateTime,
    Merchant,
    Category,
    Amount,
    FirstName,
    LastName,
    Gender,
    City,
    State,
    ZipCode,
    CustomerLatitude,
    CustomerLongitude,
    CityPopulation,
    Job,
    DateOfBirth,
    UnixTime,
    MerchantLatitude,
    MerchantLongitude,
    IsFraud,

    -- Time Features
    DATEPART(HOUR, TransactionDateTime) AS TransactionHour,

    DATENAME(WEEKDAY, TransactionDateTime) AS DayOfWeek,

    DATEPART(WEEKDAY, TransactionDateTime) AS DayOfWeekNumber,

    DATEPART(MONTH, TransactionDateTime) AS TransactionMonth,

    DATENAME(MONTH, TransactionDateTime) AS MonthName,

    DATEPART(YEAR, TransactionDateTime) AS TransactionYear,

    CASE
        WHEN DATEPART(WEEKDAY, TransactionDateTime) IN (1, 7)
            THEN 1
        ELSE 0
    END AS IsWeekend,

    CASE
        WHEN DATEPART(HOUR, TransactionDateTime) BETWEEN 0 AND 5
            THEN 'Late Night'

        WHEN DATEPART(HOUR, TransactionDateTime) BETWEEN 6 AND 11
            THEN 'Morning'

        WHEN DATEPART(HOUR, TransactionDateTime) BETWEEN 12 AND 17
            THEN 'Afternoon'

        ELSE 'Evening'
    END AS TimeOfDay

FROM clean_FraudTransactions;
GO

SELECT TOP 20
    TransactionNumber,
    TransactionDateTime,
    Amount,
    TransactionHour,
    DayOfWeek,
    DayOfWeekNumber,
    TransactionMonth,
    MonthName,
    TransactionYear,
    IsWeekend,
    TimeOfDay,
    IsFraud
FROM vw_FraudTransactionAnalysis
ORDER BY TransactionDateTime;
----STEP 9 — Customer Behavioral Baseline
SELECT
    CardNumber,
    COUNT(*) AS TotalTransactions,
    SUM(Amount) AS TotalSpend,
    AVG(Amount) AS AverageTransactionAmount,
    MAX(Amount) AS MaximumTransactionAmount,
    MIN(Amount) AS MinimumTransactionAmount
FROM clean_FraudTransactions
GROUP BY CardNumber
ORDER BY TotalTransactions DESC;

--Now let's look specifically at fraud history
--Which cards have historically been associated with fraudulent transactions?
SELECT
    CardNumber,
    COUNT(*) AS TotalTransactions,
    SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) AS FraudTransactions,
    CAST(
        SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(10,2)
    ) AS FraudRate
FROM clean_FraudTransactions
GROUP BY CardNumber
ORDER BY FraudTransactions DESC;

--STEP 10 — Transaction-Level Customer Baseline

CREATE VIEW vw_CustomerBehavior
AS
SELECT
    TransactionNumber,
    CardNumber,
    TransactionDateTime,
    Merchant,
    Category,
    Amount,
    IsFraud,

    -- Customer Transaction History
    COUNT(*) OVER (
        PARTITION BY CardNumber
    ) AS CustomerTotalTransactions,

    -- Customer Spending Baseline
    AVG(Amount) OVER (
        PARTITION BY CardNumber
    ) AS CustomerAverageAmount,

    MAX(Amount) OVER (
        PARTITION BY CardNumber
    ) AS CustomerMaximumAmount,

    MIN(Amount) OVER (
        PARTITION BY CardNumber
    ) AS CustomerMinimumAmount,

    -- Difference from Customer's Normal Spend
    Amount -
    AVG(Amount) OVER (
        PARTITION BY CardNumber
    ) AS AmountDifference,

    -- Percentage Difference
    CASE
        WHEN AVG(Amount) OVER (PARTITION BY CardNumber) = 0
        THEN 0
        ELSE
            (
                Amount -
                AVG(Amount) OVER (PARTITION BY CardNumber)
            )
            * 100.0
            /
            AVG(Amount) OVER (PARTITION BY CardNumber)
    END AS AmountDeviationPercent

FROM clean_FraudTransactions;
GO

SELECT TOP 20
    TransactionNumber,
    CardNumber,
    TransactionDateTime,
    Amount,
    CustomerTotalTransactions,
    CustomerAverageAmount,
    CustomerMaximumAmount,
    AmountDifference,
    AmountDeviationPercent,
    IsFraud
FROM vw_CustomerBehavior
ORDER BY AmountDeviationPercent DESC;

--Build the Historical Customer Baseline
--Create the historical baseline view


CREATE VIEW vw_HistoricalBehavior
AS
SELECT
    TransactionNumber,
    CardNumber,
    TransactionDateTime,
    Merchant,
    Category,
    Amount,
    IsFraud,

    -- Number of previous transactions
    COUNT(*) OVER (
        PARTITION BY CardNumber
        ORDER BY TransactionDateTime, TransactionNumber
        ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
    ) AS PreviousTransactionCount,

    -- Average amount of previous transactions
    AVG(Amount) OVER (
        PARTITION BY CardNumber
        ORDER BY TransactionDateTime, TransactionNumber
        ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
    ) AS PreviousAverageAmount,

    -- Maximum previous transaction
    MAX(Amount) OVER (
        PARTITION BY CardNumber
        ORDER BY TransactionDateTime, TransactionNumber
        ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
    ) AS PreviousMaximumAmount

FROM clean_FraudTransactions;
GO

SELECT TOP 30
    TransactionNumber,
    CardNumber,
    TransactionDateTime,
    Amount,
    PreviousTransactionCount,
    PreviousAverageAmount,
    PreviousMaximumAmount,
    IsFraud
FROM vw_HistoricalBehavior
ORDER BY CardNumber, TransactionDateTime, TransactionNumber;

--STEP 12 — Create Transaction Anomaly Features

CREATE VIEW vw_TransactionAnomalies
AS
SELECT
    TransactionNumber,
    CardNumber,
    TransactionDateTime,
    Merchant,
    Category,
    Amount,
    PreviousTransactionCount,
    PreviousAverageAmount,
    PreviousMaximumAmount,
    IsFraud,

    -- Difference from previous customer average
    CASE
        WHEN PreviousAverageAmount IS NULL
            THEN NULL
        ELSE Amount - PreviousAverageAmount
    END AS AmountDifference,

    -- Percentage deviation from previous customer average
    CASE
        WHEN PreviousAverageAmount IS NULL
             OR PreviousAverageAmount = 0
            THEN NULL
        ELSE
            ((Amount - PreviousAverageAmount)
             / PreviousAverageAmount) * 100.0
    END AS AmountDeviationPercent,

    -- Is this transaction larger than anything previously seen?
    CASE
        WHEN PreviousMaximumAmount IS NULL
            THEN NULL
        WHEN Amount > PreviousMaximumAmount
            THEN 1
        ELSE 0
    END AS ExceedsPreviousMaximum

FROM vw_HistoricalBehavior;

SELECT TOP 30
    TransactionNumber,
    CardNumber,
    TransactionDateTime,
    Amount,
    PreviousAverageAmount,
    AmountDifference,
    AmountDeviationPercent,
    PreviousMaximumAmount,
    ExceedsPreviousMaximum,
    IsFraud
FROM vw_TransactionAnomalies
WHERE PreviousTransactionCount >= 2
ORDER BY AmountDeviationPercent DESC;

--STEP 13 — Transaction Velocity

CREATE VIEW vw_TransactionVelocity
AS
SELECT
    TransactionNumber,
    CardNumber,
    TransactionDateTime,
    Merchant,
    Category,
    Amount,
    IsFraud,

    -- Previous transaction timestamp
    LAG(TransactionDateTime) OVER (
        PARTITION BY CardNumber
        ORDER BY TransactionDateTime, TransactionNumber
    ) AS PreviousTransactionTime,

    -- Time since previous transaction
    DATEDIFF(
        SECOND,
        LAG(TransactionDateTime) OVER (
            PARTITION BY CardNumber
            ORDER BY TransactionDateTime, TransactionNumber
        ),
        TransactionDateTime
    ) AS SecondsSincePreviousTransaction

FROM clean_FraudTransactions;
GO

SELECT TOP 30
    TransactionNumber,
    CardNumber,
    TransactionDateTime,
    Amount,
    PreviousTransactionTime,
    SecondsSincePreviousTransaction,
    IsFraud
FROM vw_TransactionVelocity
WHERE PreviousTransactionTime IS NOT NULL
ORDER BY SecondsSincePreviousTransaction;
--STEP 13.2 — Investigate the zero-second transactions
SELECT
    CardNumber,
    TransactionDateTime,
    COUNT(*) AS TransactionsAtSameTime
FROM clean_FraudTransactions
GROUP BY
    CardNumber,
    TransactionDateTime
HAVING COUNT(*) > 1
ORDER BY TransactionsAtSameTime DESC;

SELECT
    COUNT(*) AS DuplicateTimestampGroups,
    SUM(TransactionsAtSameTime) AS TransactionsInThoseGroups,
    MAX(TransactionsAtSameTime) AS MaxTransactionsAtSameTimestamp
FROM
(
    SELECT
        CardNumber,
        TransactionDateTime,
        COUNT(*) AS TransactionsAtSameTime
    FROM clean_FraudTransactions
    GROUP BY
        CardNumber,
        TransactionDateTime
    HAVING COUNT(*) > 1
) AS x;

--STEP 14 — Transactions within the previous 24 hours

CREATE VIEW vw_TransactionVelocity24H
AS
SELECT
    t.TransactionNumber,
    t.CardNumber,
    t.TransactionDateTime,
    t.Amount,
    t.Merchant,
    t.Category,
    t.IsFraud,

    -- Previous transaction time
    LAG(t.TransactionDateTime) OVER (
        PARTITION BY t.CardNumber
        ORDER BY t.TransactionDateTime, t.TransactionNumber
    ) AS PreviousTransactionTime,

    -- Seconds since previous transaction
    DATEDIFF(
        SECOND,
        LAG(t.TransactionDateTime) OVER (
            PARTITION BY t.CardNumber
            ORDER BY t.TransactionDateTime, t.TransactionNumber
        ),
        t.TransactionDateTime
    ) AS SecondsSincePreviousTransaction,

    -- Number of previous transactions in the last 24 hours
    (
        SELECT COUNT(*)
        FROM clean_FraudTransactions p
        WHERE p.CardNumber = t.CardNumber
          AND p.TransactionDateTime < t.TransactionDateTime
          AND p.TransactionDateTime >= DATEADD(
                HOUR,
                -24,
                t.TransactionDateTime
              )
    ) AS PreviousTransactions24H

FROM clean_FraudTransactions t;
GO

SELECT TOP 30
    TransactionNumber,
    CardNumber,
    TransactionDateTime,
    Amount,
    PreviousTransactionTime,
    SecondsSincePreviousTransaction,
    PreviousTransactions24H,
    IsFraud
FROM vw_TransactionVelocity24H
ORDER BY PreviousTransactions24H DESC;

--STEP 15 — Validate whether velocity is a fraud signal

SELECT
    CASE
        WHEN PreviousTransactions24H = 0 THEN '0'
        WHEN PreviousTransactions24H BETWEEN 1 AND 5 THEN '1-5'
        WHEN PreviousTransactions24H BETWEEN 6 AND 10 THEN '6-10'
        WHEN PreviousTransactions24H BETWEEN 11 AND 20 THEN '11-20'
        WHEN PreviousTransactions24H BETWEEN 21 AND 30 THEN '21-30'
        ELSE '31+'
    END AS VelocityBand,

    COUNT(*) AS TotalTransactions,

    SUM(CASE
        WHEN IsFraud = 1 THEN 1
        ELSE 0
    END) AS FraudTransactions,

    CAST(
        SUM(CASE
            WHEN IsFraud = 1 THEN 1
            ELSE 0
        END) * 100.0
        / COUNT(*)
        AS DECIMAL(10,2)
    ) AS FraudRatePercent

FROM vw_TransactionVelocity24H

GROUP BY
    CASE
        WHEN PreviousTransactions24H = 0 THEN '0'
        WHEN PreviousTransactions24H BETWEEN 1 AND 5 THEN '1-5'
        WHEN PreviousTransactions24H BETWEEN 6 AND 10 THEN '6-10'
        WHEN PreviousTransactions24H BETWEEN 11 AND 20 THEN '11-20'
        WHEN PreviousTransactions24H BETWEEN 21 AND 30 THEN '21-30'
        ELSE '31+'
    END;

--STEP 16 — Let's investigate TIME

SELECT
    DATEPART(HOUR, TransactionDateTime) AS TransactionHour,

    COUNT(*) AS TotalTransactions,

    SUM(CASE
        WHEN IsFraud = 1 THEN 1
        ELSE 0
    END) AS FraudTransactions,

    CAST(
        SUM(CASE
            WHEN IsFraud = 1 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS FraudRatePercent

FROM clean_FraudTransactions

GROUP BY
    DATEPART(HOUR, TransactionDateTime)

ORDER BY
    TransactionHour;

--STEP 17 — Create a Time Risk Classification

CREATE VIEW vw_TimeRisk
AS
SELECT
    TransactionNumber,
    CardNumber,
    TransactionDateTime,
    Amount,
    Merchant,
    Category,
    IsFraud,

    DATEPART(HOUR, TransactionDateTime) AS TransactionHour,

    CASE
        WHEN DATEPART(HOUR, TransactionDateTime) BETWEEN 22 AND 23
            THEN 'Very High'
        WHEN DATEPART(HOUR, TransactionDateTime) BETWEEN 0 AND 3
            THEN 'High'
        ELSE 'Normal'
    END AS TimeRisk

FROM clean_FraudTransactions;
GO

--STEP 17.1 — Validate our classification

SELECT
    TimeRisk,
    COUNT(*) AS TotalTransactions,

    SUM(CASE
        WHEN IsFraud = 1 THEN 1
        ELSE 0
    END) AS FraudTransactions,

    CAST(
        SUM(CASE
            WHEN IsFraud = 1 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS FraudRatePercent

FROM vw_TimeRisk

GROUP BY TimeRisk

ORDER BY
    CASE
        WHEN TimeRisk = 'Very High' THEN 1
        WHEN TimeRisk = 'High' THEN 2
        ELSE 3
    END;

--STEP 18 — Geographic Anomaly
SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'clean_FraudTransactions'
ORDER BY ORDINAL_POSITION;

SELECT TOP 20
    TransactionNumber,
    CardNumber,
    TransactionDateTime,
    Amount,
    CustomerLatitude,
    CustomerLongitude,
    MerchantLatitude,
    MerchantLongitude,

    6371 * 2 * ASIN(
        SQRT(
            POWER(
                SIN(
                    RADIANS(MerchantLatitude - CustomerLatitude) / 2
                ),
                2
            )
            +
            COS(RADIANS(CustomerLatitude))
            *
            COS(RADIANS(MerchantLatitude))
            *
            POWER(
                SIN(
                    RADIANS(MerchantLongitude - CustomerLongitude) / 2
                ),
                2
            )
        )
    ) AS DistanceFromHomeKM,

    IsFraud

FROM clean_FraudTransactions
ORDER BY DistanceFromHomeKM DESC;

--STEP 18.1 — Test Distance vs Fraud

SELECT
    DistanceBand,
    COUNT(*) AS TotalTransactions,
    SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) AS FraudTransactions,

    CAST(
        SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS FraudRatePercent

FROM
(
    SELECT
        IsFraud,

        CASE
            WHEN DistanceFromHomeKM < 25 THEN '0-25 KM'
            WHEN DistanceFromHomeKM < 50 THEN '25-50 KM'
            WHEN DistanceFromHomeKM < 100 THEN '50-100 KM'
            WHEN DistanceFromHomeKM < 150 THEN '100-150 KM'
            ELSE '150+ KM'
        END AS DistanceBand

    FROM
    (
        SELECT
            IsFraud,

            6371 * 2 * ASIN(
                SQRT(
                    POWER(
                        SIN(
                            RADIANS(MerchantLatitude - CustomerLatitude) / 2
                        ),
                        2
                    )
                    +
                    COS(RADIANS(CustomerLatitude))
                    *
                    COS(RADIANS(MerchantLatitude))
                    *
                    POWER(
                        SIN(
                            RADIANS(MerchantLongitude - CustomerLongitude) / 2
                        ),
                        2
                    )
                )
            ) AS DistanceFromHomeKM

        FROM clean_FraudTransactions
    ) AS DistanceCalculation

) AS DistanceBands

GROUP BY DistanceBand

ORDER BY
    CASE DistanceBand
        WHEN '0-25 KM' THEN 1
        WHEN '25-50 KM' THEN 2
        WHEN '50-100 KM' THEN 3
        WHEN '100-150 KM' THEN 4
        WHEN '150+ KM' THEN 5
    END;

--STEP 19 — Merchant & Category Risk

SELECT
    Category,

    COUNT(*) AS TotalTransactions,

    SUM(CASE
        WHEN IsFraud = 1 THEN 1
        ELSE 0
    END) AS FraudTransactions,

    CAST(
        SUM(CASE
            WHEN IsFraud = 1 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS FraudRatePercent,

    CAST(
        SUM(Amount) AS DECIMAL(18,2)
    ) AS TotalTransactionValue,

    CAST(
        SUM(CASE
            WHEN IsFraud = 1 THEN Amount
            ELSE 0
        END)
        AS DECIMAL(18,2)
    ) AS FraudTransactionValue

FROM clean_FraudTransactions

GROUP BY Category

ORDER BY FraudRatePercent DESC;

--STEP 20 — Merchant Risk

SELECT
    Merchant,

    COUNT(*) AS TotalTransactions,

    SUM(CASE
        WHEN IsFraud = 1 THEN 1
        ELSE 0
    END) AS FraudTransactions,

    CAST(
        SUM(CASE
            WHEN IsFraud = 1 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS FraudRatePercent,

    CAST(
        SUM(Amount) AS DECIMAL(18,2)
    ) AS TotalTransactionValue,

    CAST(
        SUM(CASE
            WHEN IsFraud = 1 THEN Amount
            ELSE 0
        END)
        AS DECIMAL(18,2)
    ) AS FraudTransactionValue

FROM clean_FraudTransactions

GROUP BY Merchant

HAVING COUNT(*) >= 100

ORDER BY FraudRatePercent DESC;
--step 21
SELECT
    CASE
        WHEN Merchant LIKE 'fraud_%' THEN 'Fraud_Named_Merchant'
        ELSE 'Normal_Merchant'
    END AS MerchantType,

    COUNT(*) AS TotalTransactions,

    SUM(CASE
        WHEN IsFraud = 1 THEN 1
        ELSE 0
    END) AS FraudTransactions,

    CAST(
        SUM(CASE
            WHEN IsFraud = 1 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS FraudRatePercent

FROM clean_FraudTransactions

GROUP BY
    CASE
        WHEN Merchant LIKE 'fraud_%' THEN 'Fraud_Named_Merchant'
        ELSE 'Normal_Merchant'
    END;

--Next: STEP 22 — Customer/Card Risk

SELECT TOP 20
    CardNumber,

    COUNT(*) AS TotalTransactions,

    SUM(CASE
        WHEN IsFraud = 1 THEN 1
        ELSE 0
    END) AS FraudTransactions,

    CAST(
        SUM(CASE
            WHEN IsFraud = 1 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS FraudRatePercent,

    CAST(SUM(Amount) AS DECIMAL(18,2)) AS TotalTransactionValue,

    CAST(
        SUM(CASE
            WHEN IsFraud = 1 THEN Amount
            ELSE 0
        END)
        AS DECIMAL(18,2)
    ) AS FraudTransactionValue

FROM clean_FraudTransactions

GROUP BY CardNumber

HAVING COUNT(*) >= 20

ORDER BY FraudRatePercent DESC;

--STEP 23 — Card Risk Segmentation

SELECT
    CASE
        WHEN FraudRatePercent >= 2.00 THEN 'High Risk'
        WHEN FraudRatePercent >= 1.00 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS CardRiskLevel,

    COUNT(*) AS NumberOfCards,

    SUM(TotalTransactions) AS TotalTransactions,

    SUM(FraudTransactions) AS FraudTransactions,

    CAST(
        SUM(FraudTransactions) * 100.0
        / SUM(TotalTransactions)
        AS DECIMAL(10,2)
    ) AS OverallFraudRatePercent,

    CAST(
        SUM(FraudTransactionValue)
        AS DECIMAL(18,2)
    ) AS FraudTransactionValue

FROM
(
    SELECT
        CardNumber,
        COUNT(*) AS TotalTransactions,

        SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END)
            AS FraudTransactions,

        CAST(
            SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END)
            * 100.0 / COUNT(*)
            AS DECIMAL(10,2)
        ) AS FraudRatePercent,

        SUM(
            CASE WHEN IsFraud = 1 THEN Amount ELSE 0 END
        ) AS FraudTransactionValue

    FROM clean_FraudTransactions

    GROUP BY CardNumber

    HAVING COUNT(*) >= 20

) AS CardRisk

GROUP BY
    CASE
        WHEN FraudRatePercent >= 2.00 THEN 'High Risk'
        WHEN FraudRatePercent >= 1.00 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END

ORDER BY OverallFraudRatePercent DESC;

--STEP 24 — Fraud Exposure by Risk Level

SELECT
    CardRiskLevel,
    NumberOfCards,
    TotalTransactions,
    FraudTransactions,
    OverallFraudRatePercent,
    FraudTransactionValue,

    CAST(
        FraudTransactionValue * 100.0
        / SUM(FraudTransactionValue) OVER ()
        AS DECIMAL(10,2)
    ) AS PercentOfTotalFraudValue

FROM
(
    SELECT
        CASE
            WHEN FraudRatePercent >= 2.00 THEN 'High Risk'
            WHEN FraudRatePercent >= 1.00 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS CardRiskLevel,

        COUNT(*) AS NumberOfCards,
        SUM(TotalTransactions) AS TotalTransactions,
        SUM(FraudTransactions) AS FraudTransactions,

        CAST(
            SUM(FraudTransactions) * 100.0
            / SUM(TotalTransactions)
            AS DECIMAL(10,2)
        ) AS OverallFraudRatePercent,

        SUM(FraudTransactionValue) AS FraudTransactionValue

    FROM
    (
        SELECT
            CardNumber,
            COUNT(*) AS TotalTransactions,

            SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END)
                AS FraudTransactions,

            CAST(
                SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END)
                * 100.0 / COUNT(*)
                AS DECIMAL(10,2)
            ) AS FraudRatePercent,

            SUM(
                CASE WHEN IsFraud = 1 THEN Amount ELSE 0 END
            ) AS FraudTransactionValue

        FROM clean_FraudTransactions

        GROUP BY CardNumber

        HAVING COUNT(*) >= 20

    ) AS CardLevel

    GROUP BY
        CASE
            WHEN FraudRatePercent >= 2.00 THEN 'High Risk'
            WHEN FraudRatePercent >= 1.00 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END

) AS RiskSummary;

--STEP 25 — Now we build the actual Risk Signals 🔥

create or alter VIEW dbo.vw_FraudBehaviorFeatures
AS

WITH PreviousTransactions AS
(
    SELECT
        *,
        
        LAG(TransactionDateTime) OVER
        (
            PARTITION BY CardNumber
            ORDER BY TransactionDateTime
        ) AS PreviousTransactionTime,

        LAG(Amount) OVER
        (
            PARTITION BY CardNumber
            ORDER BY TransactionDateTime
        ) AS PreviousTransactionAmount,

        COUNT(*) OVER
        (
            PARTITION BY CardNumber
            ORDER BY TransactionDateTime
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS PreviousTransactionCount,

        AVG(Amount) OVER
        (
            PARTITION BY CardNumber
            ORDER BY TransactionDateTime
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS PreviousAverageAmount,

        MAX(Amount) OVER
        (
            PARTITION BY CardNumber
            ORDER BY TransactionDateTime
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS PreviousMaximumAmount

    FROM dbo.vw_FraudTransactionAnalysis
)

SELECT
    *,

    CASE
        WHEN PreviousTransactionTime IS NULL THEN NULL
        ELSE DATEDIFF(
            SECOND,
            PreviousTransactionTime,
            TransactionDateTime
        )
    END AS SecondsSincePreviousTransaction,

    CASE
        WHEN PreviousAverageAmount IS NULL THEN NULL
        ELSE Amount - PreviousAverageAmount
    END AS AmountDifference,

    CASE
        WHEN PreviousAverageAmount IS NULL
             OR PreviousAverageAmount = 0
        THEN NULL
        ELSE
            ABS(Amount - PreviousAverageAmount)
            * 100.0 / PreviousAverageAmount
    END AS AmountDeviationPercent

FROM PreviousTransactions;

create or alter VIEW dbo.vw_FraudVelocityFeatures
AS

SELECT
    b.*,

    (
        SELECT COUNT(*)
        FROM dbo.clean_FraudTransactions AS p
        WHERE p.CardNumber = b.CardNumber
          AND p.TransactionDateTime < b.TransactionDateTime
          AND p.TransactionDateTime >= DATEADD(
              HOUR,
              -24,
              b.TransactionDateTime
          )
    ) AS PreviousTransactions24H

FROM dbo.vw_FraudBehaviorFeatures AS b;

create or alter VIEW dbo.vw_FraudRiskScore
AS

SELECT
    v.TransactionNumber,
    v.CardNumber,
    v.TransactionDateTime,
    v.Merchant,
    v.Category,
    v.Amount,
    v.IsFraud,

    v.PreviousTransactions24H,
    v.AmountDeviationPercent,
    a.ExceedsPreviousMaximum,
    v.SecondsSincePreviousTransaction,
    t.TimeRisk,

    (
        CASE
            WHEN v.AmountDeviationPercent >= 500 THEN 30
            WHEN v.AmountDeviationPercent >= 200 THEN 20
            WHEN v.AmountDeviationPercent >= 100 THEN 10
            ELSE 0
        END

        +

    CASE
        WHEN v.PreviousTransactions24H BETWEEN 6 AND 10 THEN 25
        WHEN v.PreviousTransactions24H BETWEEN 1 AND 5 THEN 10
        WHEN v.PreviousTransactions24H >= 11 THEN 5
        ELSE 0
    END

        +

        CASE
            WHEN t.TimeRisk = 'Very High' THEN 20
            WHEN t.TimeRisk = 'High' THEN 10
            ELSE 0
        END

        +

        CASE
            WHEN a.ExceedsPreviousMaximum = 1 THEN 15
            ELSE 0
        END

        +

        CASE
            WHEN v.SecondsSincePreviousTransaction <= 60
                 AND v.PreviousTransactionCount > 0
            THEN 10
            ELSE 0
        END

    ) AS FraudRiskScore

FROM dbo.vw_FraudVelocityFeatures AS v

LEFT JOIN dbo.vw_TransactionAnomalies AS a
    ON v.TransactionNumber = a.TransactionNumber

LEFT JOIN dbo.vw_TimeRisk AS t
    ON v.TransactionNumber = t.TransactionNumber;

create or alter VIEW dbo.vw_FraudRiskAssessment
AS

SELECT
    *,
    CASE
        WHEN FraudRiskScore >= 70 THEN 'Critical Risk'
        WHEN FraudRiskScore >= 40 THEN 'High Risk'
        WHEN FraudRiskScore >= 20 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS RiskLevel

FROM dbo.vw_FraudRiskScore;
