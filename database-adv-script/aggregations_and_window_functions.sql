-- AirBnB Database Advanced SQL - Aggregation and Window Functions
-- This SQL script demonstrates various aggregation functions and window functions for data analysis

-- ==========================================
-- 1. AGGREGATION: Total number of bookings made by each user
-- ==========================================
SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS user_name,
    u.email,
    u.role,
    COUNT(b.booking_id) AS total_bookings
FROM 
    user u
LEFT JOIN 
    booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name, u.email, u.role
ORDER BY 
    total_bookings DESC;

-- ==========================================
-- 2. WINDOW FUNCTION: Rank properties based on total bookings
-- ==========================================

-- Using ROW_NUMBER() to assign unique sequential ranks
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    CONCAT(u.first_name, ' ', u.last_name) AS host_name,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank
FROM 
    property p
LEFT JOIN 
    booking b ON p.property_id = b.property_id
JOIN 
    user u ON p.host_id = u.user_id
GROUP BY 
    p.property_id, p.name, p.location, u.first_name, u.last_name
ORDER BY 
    total_bookings DESC;

-- Using RANK() to assign ranks (same rank for ties)
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    CONCAT(u.first_name, ' ', u.last_name) AS host_name,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank
FROM 
    property p
LEFT JOIN 
    booking b ON p.property_id = b.property_id
JOIN 
    user u ON p.host_id = u.user_id
GROUP BY 
    p.property_id, p.name, p.location, u.first_name, u.last_name
ORDER BY 
    total_bookings DESC;

-- Using DENSE_RANK() to assign consecutive ranks
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    CONCAT(u.first_name, ' ', u.last_name) AS host_name,
    COUNT(b.booking_id) AS total_bookings,
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank
FROM 
    property p
LEFT JOIN 
    booking b ON p.property_id = b.property_id
JOIN 
    user u ON p.host_id = u.user_id
GROUP BY 
    p.property_id, p.name, p.location, u.first_name, u.last_name
ORDER BY 
    total_bookings DESC;
