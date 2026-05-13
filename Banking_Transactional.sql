-- Q1: How Do Transaction Frequency and Transaction Volume Vary Across Product Categories?
SELECT
    ProductCategory,
    COUNT(DISTINCT TransactionID) AS TotalTransactions,
    SUM(Amount) AS Total_Amount,
    SAFE_DIVIDE(
        SUM(Amount),
        COUNT(DISTINCT TransactionID)
    ) AS AvgTransactionValue

FROM `project-cungocthanhtruc-2025.DA_project.Banking`
GROUP BY ProductCategory
ORDER BY Total_Amount DESC;

-- Q2: How Can Customers Be Segmented Based on Transaction Frequency and Transaction Volume?
WITH customer_metrics AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT TransactionID) AS CustomerFrequency,
        SUM(Amount) AS TotalTransactionVolume
    FROM `project-cungocthanhtruc-2025.DA_project.Banking`
    GROUP BY CustomerID
),

thresholds AS (
    SELECT
        APPROX_QUANTILES(CustomerFrequency, 4)[OFFSET(3)] AS freq_q3,
        APPROX_QUANTILES(TotalTransactionVolume, 4)[OFFSET(3)] AS volume_q3
    FROM customer_metrics
),

segmented AS (
    SELECT
        c.CustomerID,
        CASE
            WHEN c.CustomerFrequency >= t.freq_q3
             AND c.TotalTransactionVolume >= t.volume_q3
            THEN 'High Value & Active'

            WHEN c.CustomerFrequency < t.freq_q3
             AND c.TotalTransactionVolume >= t.volume_q3
            THEN 'High Value Occasional'

            WHEN c.CustomerFrequency >= t.freq_q3
             AND c.TotalTransactionVolume < t.volume_q3
            THEN 'Mass Active'

            ELSE 'Low Engagement'
        END AS CustomerSegmentGroup
    FROM customer_metrics c
    CROSS JOIN thresholds t
)

SELECT
    CustomerSegmentGroup,
    COUNT(*) AS NumberOfCustomers
FROM segmented
GROUP BY CustomerSegmentGroup
ORDER BY NumberOfCustomers DESC;

-- Q3: How Can Customers Be Segmented Based on Fee Burden?
WITH customer_summary AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT TransactionID) AS TotalTransactions,
        SUM(Amount) AS TotalTransactionVolume,
        SUM(COALESCE(CreditCardFees, 0)) AS TotalCreditCardFees,
        SUM(COALESCE(InsuranceFees, 0)) AS TotalInsuranceFees,
        SUM(COALESCE(LatePaymentAmount, 0)) AS TotalLatePaymentFees,
        SUM(
            COALESCE(CreditCardFees, 0) +
            COALESCE(InsuranceFees, 0) +
            COALESCE(LatePaymentAmount, 0)
        ) AS TotalFees
    FROM `project-cungocthanhtruc-2025.DA_project.Banking`
    GROUP BY CustomerID
)

SELECT
    CASE
        WHEN SAFE_DIVIDE(TotalFees, TotalTransactionVolume) >= 0.10 THEN 'High Fee Burden'
        WHEN SAFE_DIVIDE(TotalFees, TotalTransactionVolume) >= 0.05 THEN 'Moderate Fee Burden'
        ELSE 'Low Fee Burden'
    END AS FeeBurdenGroup,

    COUNT(*) AS NumberOfCustomers,
    ROUND(AVG(SAFE_DIVIDE(TotalFees, TotalTransactionVolume)) * 100, 2) AS AvgFeeRatioPercent,
    ROUND(AVG(SAFE_DIVIDE(TotalLatePaymentFees, TotalFees)) * 100, 2) AS AvgLatePaymentFeePercent,
    ROUND(AVG(TotalFees), 2) AS AvgFees,
    ROUND(AVG(TotalLatePaymentFees), 2) AS AvgLatePaymentFees,
    ROUND(AVG(TotalTransactionVolume), 2) AS AvgTransactionVolume

FROM customer_summary
GROUP BY FeeBurdenGroup
ORDER BY AvgFeeRatioPercent DESC;

-- Q4: How Does Product Usage Behavior Contribute to High Fee Burden Customers?
WITH fee_segmented AS (
    SELECT
        CustomerID,
        SUM(COALESCE(CreditCardFees, 0) +
            COALESCE(InsuranceFees, 0) +
            COALESCE(LatePaymentAmount, 0)) AS TotalFees,
        SUM(Amount) AS TotalTransactionVolume
    FROM `project-cungocthanhtruc-2025.DA_project.Banking`
    GROUP BY CustomerID
)

SELECT 
    b.ProductCategory,
    COUNT(*) AS TransactionCount,
    SUM(b.Amount) AS TotalValue,
    COUNT(DISTINCT b.CustomerID) AS NumCustomers,
    SUM(f.TotalFees) AS TotalFees
FROM `project-cungocthanhtruc-2025.DA_project.Banking` b
JOIN fee_segmented f
    ON b.CustomerID = f.CustomerID
WHERE SAFE_DIVIDE(f.TotalFees, f.TotalTransactionVolume) >= 0.10   
GROUP BY b.ProductCategory
ORDER BY TransactionCount DESC;

-- Q5: How Can Customers Be Segmented Based on Customer Score Risk Levels?
WITH customer_score AS (
    SELECT
        CustomerID,
        AVG(CustomerScore) AS AvgCustomerScore
    FROM `project-cungocthanhtruc-2025.DA_project.Banking`
    GROUP BY CustomerID
),

risk_segment AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY AvgCustomerScore) AS risk_quartile
    FROM customer_score
)

SELECT
    CASE
        WHEN risk_quartile = 1 THEN 'High Risk'
        WHEN risk_quartile IN (2,3) THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS CustomerRiskGroup,
    COUNT(*) AS NumCustomers,
    ROUND(AVG(AvgCustomerScore),2) AS AvgScore
FROM risk_segment
GROUP BY CustomerRiskGroup
ORDER BY AvgScore;

-- Q6: Does Product and Channel Diversity Increase Customer Value?
WITH customer_base AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT ProductCategory) AS TotalProducts,
        COUNT(DISTINCT Channel) AS TotalChannels,
        COUNT(DISTINCT TransactionID) AS TotalTransactions,
        SUM(Amount) AS TotalVolume
    FROM `project-cungocthanhtruc-2025.DA_project.Banking`
    GROUP BY CustomerID
),

segmented AS (
    SELECT *,
        TotalProducts * TotalChannels AS EngagementIndex
    FROM customer_base
)

SELECT
    CASE
        WHEN TotalProducts >= 3 AND TotalChannels >= 3 THEN 'High Product & Channel'
        WHEN TotalProducts >= 3 THEN 'High Product Only'
        WHEN TotalChannels >= 3 THEN 'High Channel Only'
        ELSE 'Basic Users'
    END AS EngagementSegment,
    COUNT(*) AS NumCustomers,
    ROUND(AVG(TotalTransactions),2) AS AvgTransactions,
    ROUND(AVG(TotalVolume),2) AS AvgVolume,
    ROUND(AVG(EngagementIndex),2) AS AvgEngagementIndex
FROM segmented
GROUP BY EngagementSegment
ORDER BY AvgVolume DESC;