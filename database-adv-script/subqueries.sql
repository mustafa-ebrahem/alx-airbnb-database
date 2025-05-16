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
