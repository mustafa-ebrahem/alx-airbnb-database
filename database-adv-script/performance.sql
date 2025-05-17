-- AirBnB Database Performance Analysis and Optimization
-- Initial complex query with multiple joins

-- ==========================================
-- ORIGINAL COMPLEX QUERY
-- ==========================================

-- This query retrieves all bookings with user details, property details, and payment details
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at,
    
    u.user_id AS guest_id,
    u.first_name AS guest_first_name,
    u.last_name AS guest_last_name,
    u.email AS guest_email,
    u.phone_number AS guest_phone,
    
    p.property_id,
    p.name AS property_name,
    p.description AS property_description,
    p.location AS property_location,
    p.pricepernight,
    
    host.user_id AS host_id,
    host.first_name AS host_first_name,
    host.last_name AS host_last_name,
    host.email AS host_email,
    host.phone_number AS host_phone,
    
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_date,
    pay.payment_method,
    
    (SELECT AVG(r.rating) 
     FROM review r 
     WHERE r.property_id = p.property_id) AS avg_property_rating,
    
    (SELECT COUNT(*) 
     FROM review r 
     WHERE r.property_id = p.property_id) AS review_count
FROM 
    booking b
JOIN 
    user u ON b.user_id = u.user_id
JOIN 
    property p ON b.property_id = p.property_id
JOIN 
    user host ON p.host_id = host.user_id
LEFT JOIN 
    payment pay ON b.booking_id = pay.booking_id
LEFT JOIN 
    (SELECT property_id, COUNT(*) AS total_bookings
     FROM booking
     WHERE status = 'confirmed'
     GROUP BY property_id) prop_stats ON p.property_id = prop_stats.property_id
WHERE 
    b.start_date >= '2024-01-01'
    AND b.start_date <= '2024-12-31'
ORDER BY 
    b.start_date ASC;

-- Analyze the query performance
EXPLAIN
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at,
    
    u.user_id AS guest_id,
    u.first_name AS guest_first_name,
    u.last_name AS guest_last_name,
    u.email AS guest_email,
    u.phone_number AS guest_phone,
    
    p.property_id,
    p.name AS property_name,
    p.description AS property_description,
    p.location AS property_location,
    p.pricepernight,
    
    host.user_id AS host_id,
    host.first_name AS host_first_name,
    host.last_name AS host_last_name,
    host.email AS host_email,
    host.phone_number AS host_phone,
    
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_date,
    pay.payment_method,
    
    (SELECT AVG(r.rating) 
     FROM review r 
     WHERE r.property_id = p.property_id) AS avg_property_rating,
    
    (SELECT COUNT(*) 
     FROM review r 
     WHERE r.property_id = p.property_id) AS review_count
FROM 
    booking b
JOIN 
    user u ON b.user_id = u.user_id
JOIN 
    property p ON b.property_id = p.property_id
JOIN 
    user host ON p.host_id = host.user_id
LEFT JOIN 
    payment pay ON b.booking_id = pay.booking_id
LEFT JOIN 
    (SELECT property_id, COUNT(*) AS total_bookings
     FROM booking
     WHERE status = 'confirmed'
     GROUP BY property_id) prop_stats ON p.property_id = prop_stats.property_id
WHERE 
    b.start_date >= '2024-01-01'
    AND b.start_date <= '2024-12-31'
ORDER BY 
    b.start_date ASC;

-- ==========================================
-- OPTIMIZED QUERY 1: Eliminate subqueries
-- ==========================================

EXPLAIN
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at,
    
    u.user_id AS guest_id,
    u.first_name AS guest_first_name,
    u.last_name AS guest_last_name,
    u.email AS guest_email,
    u.phone_number AS guest_phone,
    
    p.property_id,
    p.name AS property_name,
    p.description AS property_description,
    p.location AS property_location,
    p.pricepernight,
    
    host.user_id AS host_id,
    host.first_name AS host_first_name,
    host.last_name AS host_last_name,
    host.email AS host_email,
    host.phone_number AS host_phone,
    
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_date,
    pay.payment_method,
    
    AVG_RATING.avg_rating,
    AVG_RATING.review_count
FROM 
    booking b
JOIN 
    user u ON b.user_id = u.user_id
JOIN 
    property p ON b.property_id = p.property_id
JOIN 
    user host ON p.host_id = host.user_id
LEFT JOIN 
    payment pay ON b.booking_id = pay.booking_id
LEFT JOIN 
    (
        SELECT 
            property_id, 
            AVG(rating) AS avg_rating,
            COUNT(*) AS review_count
        FROM 
            review
        GROUP BY 
            property_id
    ) AS AVG_RATING ON p.property_id = AVG_RATING.property_id
WHERE 
    b.start_date >= '2024-01-01'
    AND b.start_date <= '2024-12-31'
ORDER BY 
    b.start_date ASC;

-- ==========================================
-- OPTIMIZED QUERY 2: Use selective columns
-- ==========================================

EXPLAIN
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email AS guest_email,
    
    p.property_id,
    p.name AS property_name,
    p.location AS property_location,
    p.pricepernight,
    
    CONCAT(host.first_name, ' ', host.last_name) AS host_name,
    
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method,
    
    AVG_RATING.avg_rating,
    AVG_RATING.review_count
FROM 
    booking b
JOIN 
    user u ON b.user_id = u.user_id
JOIN 
    property p ON b.property_id = p.property_id
JOIN 
    user host ON p.host_id = host.user_id
LEFT JOIN 
    payment pay ON b.booking_id = pay.booking_id
LEFT JOIN 
    (
        SELECT 
            property_id, 
            AVG(rating) AS avg_rating,
            COUNT(*) AS review_count
        FROM 
            review
        GROUP BY 
            property_id
    ) AS AVG_RATING ON p.property_id = AVG_RATING.property_id
WHERE 
    b.start_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY 
    b.start_date ASC;

-- ==========================================
-- OPTIMIZED QUERY 3: With LIMIT for pagination
-- ==========================================

EXPLAIN
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email AS guest_email,
    
    p.property_id,
    p.name AS property_name,
    p.location AS property_location,
    p.pricepernight,
    
    CONCAT(host.first_name, ' ', host.last_name) AS host_name,
    
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method,
    
    AVG_RATING.avg_rating,
    AVG_RATING.review_count
FROM 
    booking b
JOIN 
    user u ON b.user_id = u.user_id
JOIN 
    property p ON b.property_id = p.property_id
JOIN 
    user host ON p.host_id = host.user_id
LEFT JOIN 
    payment pay ON b.booking_id = pay.booking_id
LEFT JOIN 
    (
        SELECT 
            property_id, 
            AVG(rating) AS avg_rating,
            COUNT(*) AS review_count
        FROM 
            review
        GROUP BY 
            property_id
    ) AS AVG_RATING ON p.property_id = AVG_RATING.property_id
WHERE 
    b.start_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY 
    b.start_date ASC
LIMIT 50 OFFSET 0;

-- ==========================================
-- OPTIMIZED QUERY 4: Using indexed columns effectively
-- ==========================================

-- Assuming composite index on booking(start_date, status)
-- Assuming composite index on property(location, pricepernight)

EXPLAIN
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email AS guest_email,
    
    p.property_id,
    p.name AS property_name,
    p.location AS property_location,
    p.pricepernight,
    
    CONCAT(host.first_name, ' ', host.last_name) AS host_name,
    
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method
FROM 
    booking b
USE INDEX (idx_booking_dates_status)
JOIN 
    user u ON b.user_id = u.user_id
JOIN 
    property p USE INDEX (idx_property_location_price) ON b.property_id = p.property_id
JOIN 
    user host ON p.host_id = host.user_id
LEFT JOIN 
    payment pay ON b.booking_id = pay.booking_id
WHERE 
    b.start_date BETWEEN '2024-01-01' AND '2024-12-31'
    AND b.status = 'confirmed'
ORDER BY 
    b.start_date ASC
LIMIT 50 OFFSET 0;