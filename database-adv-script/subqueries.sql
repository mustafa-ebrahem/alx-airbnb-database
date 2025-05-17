-- AirBnB Database Advanced SQL Subqueries
-- This SQL script demonstrates different types of subqueries (correlated and non-correlated)

-- ==========================================
-- 1. Non-correlated subquery: Find all properties where the average rating is greater than 4.0
-- ==========================================

-- Method 1: Using a subquery in the WHERE clause
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    (SELECT AVG(r.rating) FROM review r WHERE r.property_id = p.property_id) AS average_rating
FROM 
    property p
WHERE 
    (SELECT AVG(r.rating) FROM review r WHERE r.property_id = p.property_id) > 4.0
ORDER BY 
    average_rating DESC;

-- Method 2: Using a subquery in the FROM clause
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    avg_ratings.average_rating
FROM 
    property p
JOIN 
    (SELECT 
        property_id, 
        AVG(rating) AS average_rating
     FROM 
        review
     GROUP BY 
        property_id
     HAVING 
        AVG(rating) > 4.0
    ) AS avg_ratings ON p.property_id = avg_ratings.property_id
ORDER BY 
    avg_ratings.average_rating DESC;

-- ==========================================
-- 2. Correlated subquery: Find users who have made more than 3 bookings
-- ==========================================

-- A correlated subquery where the inner query references the outer query
SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS user_name,
    u.email,
    u.role,
    (SELECT COUNT(*) FROM booking b WHERE b.user_id = u.user_id) AS booking_count
FROM 
    user u
WHERE 
    (SELECT COUNT(*) FROM booking b WHERE b.user_id = u.user_id) > 3
ORDER BY 
    booking_count DESC;

-- ==========================================
-- 3. ADDITIONAL QUERY: Correlated subquery with EXISTS - Find hosts who have properties with at least one 5-star review
-- ==========================================

SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS host_name,
    u.email,
    (SELECT COUNT(*) FROM property p WHERE p.host_id = u.user_id) AS property_count
FROM 
    user u
WHERE 
    u.role = 'host'
    AND EXISTS (
        SELECT 1
        FROM property p
        JOIN review r ON p.property_id = r.property_id
        WHERE p.host_id = u.user_id
        AND r.rating = 5
    )
ORDER BY 
    property_count DESC;

-- ==========================================
-- 4. ADDITIONAL QUERY: Non-correlated subquery - Find bookings with higher than average price
-- ==========================================

SELECT 
    b.booking_id,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    p.name AS property_name,
    b.total_price,
    b.start_date,
    b.end_date,
    DATEDIFF(b.end_date, b.start_date) AS nights_count
FROM 
    booking b
JOIN 
    user u ON b.user_id = u.user_id
JOIN 
    property p ON b.property_id = p.property_id
WHERE 
    b.total_price > (
        SELECT AVG(total_price) 
        FROM booking
    )
ORDER BY 
    b.total_price DESC;

-- ==========================================
-- 5. ADDITIONAL QUERY: Nested subqueries - Find properties that have more bookings than the average number of bookings per property
-- ==========================================

SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    CONCAT(u.first_name, ' ', u.last_name) AS host_name,
    (SELECT COUNT(*) FROM booking b WHERE b.property_id = p.property_id) AS booking_count,
    (SELECT AVG(booking_per_property) 
     FROM (SELECT COUNT(*) AS booking_per_property 
           FROM booking 
           GROUP BY property_id) AS avg_bookings) AS avg_booking_count
FROM 
    property p
JOIN 
    user u ON p.host_id = u.user_id
WHERE 
    (SELECT COUNT(*) FROM booking b WHERE b.property_id = p.property_id) > 
    (SELECT AVG(booking_per_property) 
     FROM (SELECT COUNT(*) AS booking_per_property 
           FROM booking 
           GROUP BY property_id) AS avg_bookings)
ORDER BY 
    booking_count DESC;