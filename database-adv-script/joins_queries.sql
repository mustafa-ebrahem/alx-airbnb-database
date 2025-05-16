-- AirBnB Database Advanced SQL Join Queries
-- This SQL script demonstrates different types of joins for the AirBnB database

-- ==========================================
-- 1. INNER JOIN: Retrieve all bookings and their respective users
-- ==========================================
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS user_name,
    u.email,
    u.phone_number
FROM 
    booking b
INNER JOIN 
    user u ON b.user_id = u.user_id
ORDER BY 
    b.start_date ASC;

-- ==========================================
-- 2. LEFT JOIN: Retrieve all properties and their reviews (including properties with no reviews)
-- ==========================================
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    r.review_id,
    r.rating,
    r.comment,
    CONCAT(u.first_name, ' ', u.last_name) AS reviewer_name
FROM 
    property p
LEFT JOIN 
    review r ON p.property_id = r.property_id
LEFT JOIN 
    user u ON r.user_id = u.user_id
ORDER BY 
    p.name ASC, r.rating DESC;

-- ==========================================
-- 3. FULL OUTER JOIN: Retrieve all users and all bookings (even if user has no booking or booking has no user)
-- ==========================================
-- MySQL doesn't directly support FULL OUTER JOIN, so we simulate it using LEFT JOIN + UNION + RIGHT JOIN

-- Method 1: Using LEFT JOIN + UNION + RIGHT JOIN to simulate FULL OUTER JOIN
SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS user_name,
    u.email,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM 
    user u
LEFT JOIN 
    booking b ON u.user_id = b.user_id

UNION

SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS user_name,
    u.email,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM 
    booking b
RIGHT JOIN 
    user u ON b.user_id = u.user_id
WHERE 
    b.booking_id IS NULL
ORDER BY 
    user_name ASC;

