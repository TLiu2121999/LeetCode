-----------------------------------------------------------------------
--  LeetCode 1435. Create a Session Bar Chart
--
--  Easy
--
--  SQL Schema
--  Table: Sessions
--
--  +---------------------+---------+
--  | Column Name         | Type    |
--  +---------------------+---------+
--  | session_id          | int     |
--  | duration            | int     |
--  +---------------------+---------+
--  session_id is the primary key for this table.
--  duration is the time in seconds that a user has visited the application.
-- 
--  You want to know how long a user visits your application. You decided to 
--  create bins of "[0-5>", "[5-10>", "[10-15>" and "15 minutes or more" and 
--  count the number of sessions on it.
--
--  Write an SQL query to report the (bin, total) in any order.
--
--  The query result format is in the following example.
--
--  Sessions table:
--  +-------------+---------------+
--  | session_id  | duration      |
--  +-------------+---------------+
--  | 1           | 30            |
--  | 2           | 199           |
--  | 3           | 299           |
--  | 4           | 580           |
--  | 5           | 1000          |
--  +-------------+---------------+
--
--  Result table:
--  +--------------+--------------+
--  | bin          | total        |
--  +--------------+--------------+
--  | [0-5>        | 3            |
--  | [5-10>       | 1            |
--  | [10-15>      | 0            |
--  | 15 or more   | 1            |
--  +--------------+--------------+
--
--  For session_id 1, 2 and 3 have a duration greater or equal than 0 minutes 
--  and less than 5 minutes.
--  For session_id 4 has a duration greater or equal than 5 minutes and less 
--  than 10 minutes.
--  There are no session with a duration greater or equial than 10 minutes and 
--  less than 15 minutes.
--  For session_id 5 has a duration greater or equal than 15 minutes.
--------------------------------------------------------------------
/* Write your T-SQL query statement below */
SELECT 
    A.bin,
    CASE WHEN B.total IS NULL THEN 0 ELSE B.total END AS total
FROM
(
    SELECT
        0 AS ID,
        '[0-5>' AS bin
    UNION ALL
    SELECT
        1 AS ID,
        '[5-10>' AS bin
    UNION ALL
    SELECT
        2 AS ID,
        '[10-15>' AS bin
    UNION ALL
    SELECT
        3 AS ID,
        '15 or more' AS bin
) AS A
LEFT OUTER JOIN	
(
    SELECT
        five_min,
        COUNT(session_id) AS total
    FROM
    (
        SELECT
            session_id,
            CASE WHEN duration < 900 THEN duration / 300 ELSE 3 END AS five_min
        FROM 
            Sessions
    ) AS A
    GROUP BY
       five_min
) AS B
ON 
    A.ID = B.five_min
