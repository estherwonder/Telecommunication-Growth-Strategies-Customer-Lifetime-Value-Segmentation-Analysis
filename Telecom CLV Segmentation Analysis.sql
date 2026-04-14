--creating a table in the schema
CREATE TABLE "NexaSat".nexa_sat(
		Customer_ID VARCHAR(50),
		gender VARCHAR (10),
		Partner VARCHAR (3),
		Dependents VARCHAR (3),
		Senior_Citizen INT,
		Call_Duration INT,
		Data_Usage FLOAT,
		Plan_Type VARCHAR(20),
		Plan_Level VARCHAR(20),
		Monthly_Bill_Amount FLOAT,
		Tenure_Months INT,
		Multiple_Lines VARCHAR (3),
		Tech_Support VARCHAR (3),
		Churn INT
);

--Confirming the schema
SELECT current_schema ();

--set path for the queries
SET search_path TO "NexaSat";

SELECT current_database();

--Data cleaning and preparation
--checking for duplicates
SELECT *
FROM nexa_sat
GROUP BY customer_id, gender, partner, dependents, senior_citizen,
		call_duration, data_usage, plan_type, plan_level, monthly_bill_amount, 
		tenure_months, multiple_lines, tech_support, churn
HAVING COUNT (*) > 1; -- this helps to filter out the duplicates, and there are no duplicates here

--checking for null values
SELECT * 
FROM nexa_sat 
WHERE customer_id IS NULL OR gender IS NULL OR partner IS NULL OR dependents IS NULL OR senior_citizen IS NULL 
		OR call_duration IS NULL OR data_usage IS NULL OR plan_type IS NULL OR plan_level IS NULL 
		OR monthly_bill_amount IS NULL OR tenure_months IS NULL OR multiple_lines IS NULL 
		OR tech_support IS NULL OR churn IS NULL;  --there are no null_values

--Checking for invalid numerical data
SELECT *
FROM nexa_sat
WHERE 
	call_duration < 0
	OR data_usage < 0
	OR monthly_bill_amount < 0
	OR senior_citizen NOT IN (0,1)
	OR churn NOT IN (0,1); --no invalid numerical date

--checking for incorrect categorical values
--for gender
SELECT DISTINCT *
FROM nexa_sat
WHERE gender NOT IN ('Male', 'Female');

--for partner
SELECT DISTINCT *
FROM nexa_sat
WHERE partner NOT IN ('Yes', 'No');

--for dependent
SELECT DISTINCT *
FROM nexa_sat
WHERE dependents NOT IN ('Yes', 'No');

--for multiple_lines
SELECT DISTINCT *
FROM nexa_sat
WHERE multiple_lines NOT IN ('Yes', 'No');

--for tech_support
SELECT DISTINCT *
FROM nexa_sat
WHERE tech_support NOT IN ('Yes', 'No');

--for plan_type
SELECT DISTINCT *
FROM nexa_sat
WHERE plan_type NOT IN ('Prepaid', 'Postpaid');

--for plan_level
SELECT DISTINCT *
FROM nexa_sat
WHERE plan_level NOT IN ('Basic', 'Premium'); --The data is in a good shape for analysis

--Exploratory Data Analysis
--Checking total users including churned users, total current and churned users
SELECT 
	COUNT(customer_id) AS total_users, 
	SUM(CASE WHEN churn = 0 THEN 1 ELSE 0 END) as current_users,
	SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) as churn_users
FROM nexa_sat; --7043 total users, 4272 current users and 2771 churned users

--Total users by level
SELECT plan_level, COUNT(customer_id)
FROM nexa_sat
WHERE churn = 0
GROUP BY 1 --3025 Premium Users and 1257 Basic users

--Total users by senior vs non-senior citizen
SELECT senior_citizen, COUNT(customer_id)
FROM nexa_sat
WHERE churn = 0
GROUP BY senior_citizen
ORDER BY senior_citizen; -- 3599 non-senior citizens and 673 senior citizens

--Users by plan
SELECT plan_type, COUNT(customer_id)
FROM nexa_sat
WHERE churn = 0
GROUP BY 1 -- 2175 Postpaid and 2097 Prepaid Users

--churn users by plan level and type
SELECT 	
	plan_type,
	plan_level,
	COUNT(customer_ID) AS total_users,
	SUM(churn) AS churn_users,
	ROUND(
        100.0 * SUM(churn) / COUNT(*),2) AS churn_rate
FROM nexa_sat
GROUP BY 1, 2
ORDER BY 2; --- Basic Postpaid and Basic Prepaid have the highest churn rate, 67.22% and 56.23% respectively,
			--and Premium Prepaid and  premium postpaid has the lowest churn rate 12.01 and 19.74 respectively

--total revenue and plan level
SELECT 
    ROUND(SUM(monthly_bill_amount::numeric), 2) AS total_revenue,

    ROUND(SUM(CASE 
        WHEN plan_level = 'Basic' THEN monthly_bill_amount::numeric 
        ELSE 0 END), 2) AS basic_revenue,

    ROUND(SUM(CASE 
        WHEN plan_level = 'Premium' THEN monthly_bill_amount::numeric 
        ELSE 0 END), 2) AS premium_revenue

FROM nexa_sat; -- total revenue is 1,054,953.70. Basic Plan 426,622 and premium 628,331.70

--Plan level usage behaviour
SELECT 
	plan_level,
	ROUND(AVG(call_duration),2) AS avg_call_duration,
	ROUND(AVG(data_usage::numeric),2) AS avg_data_uage
FROM nexa_sat
GROUP BY 1;--Premium and basic avg call duration 274.90 and 204.95 and avg data usage 8.73 and 8.86 respectively

--Plan type usage behaviour
SELECT 
	plan_type,
	ROUND(AVG(call_duration),2) AS avg_call_duration,
	ROUND(AVG(data_usage::numeric),2) AS avg_data_uage
FROM nexa_sat
GROUP BY 1 --Postpaid and Prepaid avg call duration 224.35 and 263.04 and avg data usage 6.81 and 11.56 respectively

-- Combined usage behaviour
SELECT 
    plan_level,
    plan_type,
    ROUND(AVG(call_duration), 2) AS avg_call_duration,
    ROUND(AVG(data_usage::numeric), 2) AS avg_data_usage
FROM nexa_sat
GROUP BY plan_level, plan_type
ORDER BY plan_level, plan_type;
--Premium Postpaid, Premium Prepaid, Basic Prepaid, Basic Postpaid average call duration in descending order.
--Basic prepaid, Premium prepaid, Premium postpaid, Basic postpaid avg data usage in descending order

--avg tenure by plan level
SELECT 
	plan_level,
	ROUND(AVG(tenure_months),0) AS avg_tenure
FROM nexa_sat
GROUP BY 1;--Premium and Basic avg_tenure months is 32 and 17 respectively

--CLV Segmentation
-- create table of existing users only
CREATE TABLE existing_users AS
SELECT *
FROM nexa_sat
WHERE churn = 0;

--viewing the new table
SELECT *
FROM existing_users;

--calculating existing users ARPU (Average Revenue Per User)
SELECT ROUND(AVG(monthly_bill_amount::numeric),2) AS ARPU
FROM existing_users; --ARPU is 157.53

-- To calculate clv, we add a new column clv
ALTER TABLE existing_users
ADD COLUMN clv NUMERIC(10,2);

UPDATE existing_users
SET clv = monthly_bill_amount * tenure_months;

--View clv columns
SELECT customer_id, clv
FROM existing_users

--clv scores
ALTER TABLE existing_users
ADD COLUMN clv_scores NUMERIC(10,2);

--setting clv variable weights, monthly_bill_amount is 40%, tenure is 30%, call_duration is 10%, data usage is 10% 
--and premium users is 10%
UPDATE existing_users
SET clv_scores =
				(0.4 * monthly_bill_amount) +
				(0.3 * tenure_months) +
				(0.1 * call_duration) +
				(0.1 * data_usage) +
				(0.1 * CASE WHEN plan_level = 'Premium' 
				THEN 1 ELSE 0 
				END);
--grouping users into segment based on clv scores
ALTER TABLE existing_users
ADD COLUMN clv_segment VARCHAR(20);

UPDATE existing_users
SET clv_segment = 
				CASE WHEN clv_scores > (SELECT percentile_cont(0.85)
										WITHIN GROUP (ORDER BY clv_scores)
										FROM existing_users) THEN 'High Value'
				WHEN clv_scores >= (SELECT percentile_cont(0.50)
										WITHIN GROUP (ORDER BY clv_scores)
										FROM existing_users) THEN 'Medium Value'
				WHEN clv_scores >= (SELECT percentile_cont(0.25)
										WITHIN GROUP (ORDER BY clv_scores)
										FROM existing_users) THEN 'Low Value'
				ELSE 'Churn Risk' END;

--view our table
SELECT customer_id, clv, clv_scores, clv_segment
FROM existing_users;

--Analyzing the segment
--distribution of the segments
SELECT clv_segment,
		COUNT(customer_id)
FROM existing_users
GROUP BY 1; -- Medium Value has the highest customer count of 1495, followed by Low Value and Churn Risk both at 1068
            --High Value has 641 total customers

--avg bills and tenure per segment
SELECT clv_segment,
		ROUND(AVG(monthly_bill_amount::NUMERIC),2) AS avg_monthly_charges,
		ROUND(AVG(tenure_months::NUMERIC),2) AS avg_tenure
FROM existing_users 
GROUP BY 1;  -- Monthly bill per clv segment goes in descending from High Value to Churn Risk,High value with spend of 311.82
             -- Churn_risk with 98.97. Average tenure for churn_risk is the lowest with 14.97,
			 -- and Medium Value and high value with 32.64

--tech support and multiple lines
SELECT clv_segment,
		ROUND(100.0 * AVG(CASE WHEN tech_support = 'Yes' THEN 1 ELSE 0 END),2) AS tech_support_perct,
		ROUND( 100.0 *AVG(CASE WHEN multiple_lines = 'Yes' THEN 1 ELSE 0 END),2) AS multilines_perct
FROM existing_users
GROUP BY 1; -- Medium value have the highest tech_support and multiple_lines rate of 92.31 and 92.64 respectively,
			--churn risk has the lowest rate of 53.84 and 62.55

--revenue per segment
SELECT clv_segment, 
	   COUNT(customer_id) AS total_users,
	   CAST(SUM(monthly_bill_amount * tenure_months) AS NUMERIC(10,2)) AS total_revenue
FROM existing_users
GROUP BY 1; -- Medium value generated the highest revenue of 7,715,584.50 also with the highest users, High value with the
			--lowest user generated the second highest 6,449,883.15. Low Value and Churn risk have the same number of users but
			--churn risk generated less than half of low value revenue

--Demographic distribution
--senior vs non-senior
SELECT clv_segment,
       senior_citizen,
	   COUNT(customer_id)
FROM existing_users
GROUP BY 1,2
ORDER BY 1; -- Highest number of senior citizen and non-senior falls in Medium value of 226 and 1269. 
            -- 	Churn risk has the total number of 160 senior citizens and 908 non-senior

--dependents 
SELECT clv_segment,
       dependents,
	   COUNT(customer_id)
FROM existing_users
GROUP BY 1,2
ORDER BY 1; 

--partner
SELECT clv_segment,
       partner,
	   COUNT(customer_id)
FROM existing_users
GROUP BY 1,2
ORDER BY 1; 


--clv segments by plan distribution
SELECT 
    clv_segment,
    plan_type,
    plan_level,
    COUNT(*) AS total_customers,
    ROUND(100.0 * COUNT(*)
	/ SUM(COUNT(*)) OVER (PARTITION BY clv_segment), 2) 
          AS percentage_within_segment
FROM existing_users
GROUP BY clv_segment, plan_type, plan_level
ORDER BY clv_segment; --No Prepaid plan in High Value, Medium value and low value prepaid premium has a rate 
					---of 55.18 and 57.21 respective, the highest in the medium and low value segment.
					-- churn risk segment has a high rate of postpaid basic and prepaid basic of 40.17 and 30.34.


--Upselling and Cross-selling
-- cross-selling tech support to senior citizens
SELECT 
	COUNT(customer_id)
FROM 
	existing_users
WHERE senior_citizen = 1 --senior citizen
AND dependents = 'No' --with no children and not tech savvy
AND tech_support = 'No' -- have
AND (clv_segment = 'Churn Risk' OR clv_segment = 'Low Value');
--There's potential to cross-sell for 115 senior citizens

-- Cross-selling multiple lines to users with dependents and partners
SELECT 
	COUNT(customer_id)
FROM existing_users
WHERE multiple_lines = 'No' --no multiple lines 
	AND (dependents = 'Yes' -- with dependent
	OR partner = 'Yes') -- with partner
	AND plan_level = 'Basic'; --basic users
-- There's potential to cross-sell for 376 users


--Upselling premium to basic users at churn risk  at a discounted price
SELECT 
	COUNT(customer_id)	
FROM existing_users
WHERE clv_segment = 'Churn Risk'
	AND plan_level = 'Basic'
--There are 753 churn risk users we can upsell premium to at a discounted price 

--upselling for users in medium and high value from basic to premium since they already have high ARPU 
SELECT plan_level, ROUND(AVG(monthly_bill_amount::INT), 2), ROUND(AVG(tenure_months::INT), 2)
FROM existing_users
WHERE clv_segment = 'High Value'
OR clv_segment = 'Medium Value'
GROUP BY 1
--Basic users avg spend of 241.42 is higher than premium with 200.97 but they stay for a shorter period 17.18 than premium 35.17

SELECT 
	COUNT(customer_id)
FROM existing_users
WHERE (clv_segment = 'High Value' 
	OR clv_segment = 'Medium Value')
	AND plan_level = 'Basic' 
	AND monthly_bill_amount > 200;
--160 Basic users can be upgraded to Premium for longer tenure month

--Create Stored Procedures
--for senior citizens who will be offered tech support
CREATE FUNCTION snr_citizen_tech_support()
RETURNS TABLE (customer_id VARCHAR(50))
AS $$
BEGIN
	RETURN QUERY 
	SELECT eu.customer_id
	FROM existing_users eu
	WHERE eu.senior_citizen = 1 
	AND eu.dependents = 'No' 
	AND eu.tech_support = 'No' 
	AND (eu.clv_segment = 'Churn Risk' OR eu.clv_segment = 'Low Value'); 
END;
$$ LANGUAGE plpgsql;

--for users with dependents and partners who will be offered multiple lines
CREATE FUNCTION users_multiple_lines()
RETURNS TABLE (customer_id VARCHAR(50))
AS $$
BEGIN
	RETURN QUERY 
	SELECT eu.customer_id
	FROM existing_users eu
	WHERE eu.multiple_lines = 'No' 
	AND (eu.dependents = 'Yes' 
	OR eu.partner = 'Yes') 
	AND eu.plan_level = 'Basic'; 
END;
$$ LANGUAGE plpgsql;

--Premium discount for churn risks
CREATE FUNCTION churn_risk_discount()
RETURNS TABLE (customer_id VARCHAR(50))
AS $$
BEGIN 	
	RETURN QUERY
	SELECT eu.customer_id
	FROM existing_users eu
	WHERE eu.clv_segment = 'Churn Risk'
	AND eu.plan_level = 'Basic';
END;
$$ LANGUAGE plpgsql;

--Premium discount for high and medium value users
CREATE FUNCTION highmid_basic_discount()
RETURNS TABLE (customer_id VARCHAR(50))
AS $$
BEGIN
	RETURN QUERY
	SELECT eu.customer_id 
	FROM existing_users eu
	WHERE (eu.clv_segment = 'High Value' 
	OR eu.clv_segment = 'Medium Value')
	AND eu.plan_level = 'Basic' 
	AND eu.monthly_bill_amount > 200;
END;
$$ LANGUAGE plpgsql;

--using procedures
SELECT *
FROM snr_citizen_tech_support();

SELECT *
FROM users_multiple_lines();

SELECT *
FROM churn_risk_discount();

SELECT *
FROM highmid_basic_discount();
