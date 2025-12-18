-- ===============================================================
-- PROJECT : Banking Loan Default Analysis
-- DATABASE : MySQL 
-- AUTHOR : Nidhi Pardeshi 
-- =============================================================

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| bank_loan_analysis |
| collage_db         |
| college            |
| company            |
| customers          |
| employee           |
| information_schema |
| library            |
| loan_projects      |
| mysql              |
| newschool          |
| office             |
| performance_schema |
| school             |
| schooldb           |
| sql_project        |
| sys                |
+--------------------+
17 rows in set (0.02 sec)-

-- - STEP 1: DATABASE SETUP :- 
mysql> use sql_project;
Database changed

-- STEP 2: Table Creation and Data Availability :- 
mysql> show tables;
+-----------------------+
| Tables_in_sql_project |
+-----------------------+
| loan_project_clean    |
+-----------------------+
1 row in set (0.01 sec)

-- Table Structure of Loan Dataset 
mysql> show columns from loan_project_clean;
+---------------+--------+------+-----+---------+-------+
| Field         | Type   | Null | Key | Default | Extra |
+---------------+--------+------+-----+---------+-------+
| id            | int    | YES  |     | NULL    |       |
| address_state | text   | YES  |     | NULL    |       |
| issue_date    | text   | YES  |     | NULL    |       |
| loan_status   | text   | YES  |     | NULL    |       |
| purpose       | text   | YES  |     | NULL    |       |
| annual_income | int    | YES  |     | NULL    |       |
| dti           | double | YES  |     | NULL    |       |
| loan_amount   | int    | YES  |     | NULL    |       |
| total_payment | int    | YES  |     | NULL    |       |
| default_flag  | text   | YES  |     | NULL    |       |
+---------------+--------+------+-----+---------+-------+
10 rows in set (0.00 sec)

-- STEP 3: Viewing Loan Dataset 
SELECT * FROM loan_project_clean;

-- Task 1 :
-- Retrieve total loans disbursed per branch
mysql> select address_state as branch, sum(loan_amount) as total_loans
    -> from loan_project_clean
    -> group by address_state
    -> order by total_loans desc
    -> ;
+----------------+-------------+
| branch         | total_loans |
+----------------+-------------+
| Delhi          |     3270747 |
| Rajasthan      |     2926962 |
| Madhya Pradesh |     2909882 |
| Telangana      |     2836668 |
| Tamil Nadu     |     2582857 |
| Karnataka      |     2571645 |
| Maharashtra    |     2542161 |
| Gujarat        |     2540652 |
| West Bengal    |     2481248 |
| Uttar Pradesh  |     2184781 |
+----------------+-------------+
10 rows in set (0.02 sec)

-- Task 2 : 
-- Find customers with overdue loans
mysql> SELECT id AS customer_id, address_state, loan_amount, loan_status
    -> FROM loan_project_clean
    -> WHERE default_flag = 'Yes';
+-------------+----------------+-------------+-------------+
| customer_id | address_state  | loan_amount | loan_status |
+-------------+----------------+-------------+-------------+
|     1000071 | Tamil Nadu     |        8975 | Late        |
|     1000159 | Maharashtra    |       14525 | Charged Off |
|     1000208 | Delhi          |       43211 | Late        |
|     1000216 | Tamil Nadu     |       40254 | Late        |
|     1000341 | Delhi          |       32323 | Late        |
|     1000345 | Rajasthan      |       17102 | Charged Off |
|     1000421 | Madhya Pradesh |       23554 | Charged Off |
|     1000425 | Madhya Pradesh |       38260 | Late        |
|     1000515 | Telangana      |       34735 | Charged Off |
|     1000552 | Rajasthan      |       11736 | Late        |
|     1000598 | Maharashtra    |       47486 | Charged Off |
|     1000624 | West Bengal    |       16626 | Charged Off |
|     1000658 | West Bengal    |       48887 | Late        |
|     1000670 | Gujarat        |       47637 | Charged Off |
|     1000676 | West Bengal    |       33472 | Charged Off |
|     1000883 | Maharashtra    |        4872 | Charged Off |
|     1000884 | Maharashtra    |       46942 | Charged Off |
|     1000908 | Madhya Pradesh |       28998 | Late        |
|     1001024 | West Bengal    |        4192 | Late        |
|    
+-------------+----------------+-------------+-------------+
488 rows in set (0.01 sec)

-- Task 3 :- 
-- Calculate average loan amount by type
mysql> select purpose,
    -> avg(loan_amount) as average_loan_amount
    -> from loan_project_clean
    -> group by purpose
    -> ;
+--------------------+---------------------+
| purpose            | average_loan_amount |
+--------------------+---------------------+
| small_business     |          26513.5522 |
| debt_consolidation |          26465.7563 |
| home_improvement   |          26652.2986 |
| credit_card        |          26417.6308 |
| other              |          25425.2609 |
+--------------------+---------------------+
5 rows in set (0.02 sec)

-- Task 4 :- 
-- Identify defaulted loans by customer segment
mysql> select
    -> case
    -> when annual_income < 50000 then 'Low Income'
    -> when annual_income between 50000 and 100000 then 'Middle Income'
    -> else ' High Income'
    -> end as income_segment,
    -> count(*) as number_of_defaults
    -> from loan_project_clean
    -> where default_flag = 'Yes'
    -> group by income_segment
    -> ;
+----------------+--------------------+
| income_segment | number_of_defaults |
+----------------+--------------------+
|  High Income   |                 84 |
| Low Income     |                146 |
| Middle Income  |                258 |
+----------------+--------------------+
3 rows in set (0.01 sec)

-- Task 5 :- 
-- Rank branches by number of defaulters
mysql> select address_state as branch,
    -> count(*) as defaulters_count
    -> from loan_project_clean
    -> where default_flag = 'Yes'
    -> group by address_state
    -> order by defaulters_count desc
    -> ;
+----------------+------------------+
| branch         | defaulters_count |
+----------------+------------------+
| Delhi          |               60 |
| Karnataka      |               55 |
| Tamil Nadu     |               52 |
| Rajasthan      |               51 |
| Madhya Pradesh |               49 |
| Telangana      |               48 |
| West Bengal    |               48 |
| Gujarat        |               48 |
| Maharashtra    |               40 |
| Uttar Pradesh  |               37 |
+----------------+------------------+
10 rows in set (0.00 sec)

-- Task 6 :- 
-- Count loans approved versus rejected per branch
mysql> select address_state as branch,
    -> sum(case when loan_status = 'Approved' then 1 else 0 end) as approved_loans,
    -> sum(case when loan_status = 'Rejected' then 1 else 0 end) as rejected_loans
    -> from loan_project_clean
    -> group by address_state
    -> ;
+----------------+----------------+----------------+
| branch         | approved_loans | rejected_loans |
+----------------+----------------+----------------+
| Tamil Nadu     |              0 |              0 |
| Uttar Pradesh  |              0 |              0 |
| Maharashtra    |              0 |              0 |
| Rajasthan      |              0 |              0 |
| Delhi          |              0 |              0 |
| Telangana      |              0 |              0 |
| Madhya Pradesh |              0 |              0 |
| Karnataka      |              0 |              0 |
| West Bengal    |              0 |              0 |
| Gujarat        |              0 |              0 |
+----------------+----------------+----------------+
10 rows in set (0.01 sec)

-- Task 7 :- 
-- Identify high-risk customers based on repayment history
mysql> select id as customer_id,
    -> address_state,
    -> loan_amount,
    -> dti,
    -> default_flag
    -> from loan_project_clean
    -> where default_flag = 'Yes'
    -> or dti > 40
    -> ;
+-------------+----------------+-------------+--------+--------------+
| customer_id | address_state  | loan_amount | dti    | default_flag |
+-------------+----------------+-------------+--------+--------------+
|     1000071 | Tamil Nadu     |        8975 | 0.2983 | Yes          |
|     1000159 | Maharashtra    |       14525 | 0.2529 | Yes          |
|     1000208 | Delhi          |       43211 | 0.1328 | Yes          |
|     1000216 | Tamil Nadu     |       40254 | 0.2463 | Yes          |
|     1000341 | Delhi          |       32323 |  0.079 | Yes          |
|     1000345 | Rajasthan      |       17102 | 0.0188 | Yes          |
|     1000421 | Madhya Pradesh |       23554 | 0.2586 | Yes          |
|     1000425 | Madhya Pradesh |       38260 | 0.2747 | Yes          |
|     1000515 | Telangana      |       34735 | 0.1187 | Yes          |
|     1000552 | Rajasthan      |       11736 | 0.1249 | Yes          |
|     1000598 | Maharashtra    |       47486 | 0.1746 | Yes          |
|     1000624 | West Bengal    |       16626 | 0.0162 | Yes          |
|     1000658 | West Bengal    |       48887 | 0.2157 | Yes          |
|     1000670 | Gujarat        |       47637 | 0.1451 | Yes          |
|     1000676 | West Bengal    |       33472 |  0.246 | Yes          |
|     1000883 | Maharashtra    |        4872 | 0.0669 | Yes          |
|     1000884 | Maharashtra    |       46942 | 0.1108 | Yes          |
|     1000908 | Madhya Pradesh |       28998 | 0.0205 | Yes          |
|     1001024 | West Bengal    |        4192 | 0.2046 | Yes          |
|     1001240 | Rajasthan      |       38813 |   0.15 | Yes          |
|     1001424 | Madhya Pradesh |        8145 | 0.2667 | Yes          |
|     1001470 | Tamil Nadu     |       45090 | 0.1664 | Yes          |
|     1001502 | Madhya Pradesh |       32418 | 0.2085 | Yes          |
|     1001516 | Maharashtra    |       39411 |  0.031 | Yes          |
|     1001578 | Madhya Pradesh |       47540 | 0.1745 | Yes          |
|     1001589 | Delhi          |       15144 | 0.2976 | Yes          |
|     1001594 | Delhi          |       40886 |  0.119 | Yes          |
|     1001769 | West Bengal    |       13285 | 0.0264 | Yes          |
|     1039894 | Rajasthan      |       36908 | 0.2553 | Yes          |
|     1039897 | Gujarat        |       45873 | 0.1979 | Yes          |
+-------------+----------------+-------------+--------+--------------+
488 rows in set (0.02 sec)