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

-- ==========================================
-- 3. ADDITIONAL QUERY: Booking statistics by location with aggregations
-- ==========================================
SELECT 
    p.location,
    COUNT(DISTINCT p.property_id) AS property_count,
    COUNT(b.booking_id) AS total_bookings,
    ROUND(AVG(b.total_price), 2) AS avg_booking_price,
    MIN(b.total_price) AS min_booking_price,
    MAX(b.total_price) AS max_booking_price,
    SUM(b.total_price) AS total_revenue
FROM 
    property p
LEFT JOIN 
    booking b ON p.property_id = b.property_id AND b.status != 'canceled'
GROUP BY 
    p.location
ORDER BY 
    total_revenue DESC;

-- ==========================================
-- 4. ADDITIONAL QUERY: Monthly booking trends using date functions
-- ==========================================
SELECT 
    YEAR(b.start_date) AS booking_year,
    MONTH(b.start_date) AS booking_month,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS monthly_revenue,
    ROUND(AVG(b.total_price), 2) AS avg_booking_price
FROM 
    booking b
WHERE 
    b.status = 'confirmed'
GROUP BY 
    YEAR(b.start_date), MONTH(b.start_date)
ORDER BY 
    booking_year, booking_month;

-- ==========================================
-- 5. ADDITIONAL QUERY: Percentile analysis of property prices using window functions
-- ==========================================
SELECT 
    p.location,
    p.property_id,
    p.name AS property_name,
    p.pricepernight,
    ROUND(AVG(p.pricepernight) OVER (PARTITION BY p.location), 2) AS avg_price_in_location,
    ROUND(p.pricepernight / AVG(p.pricepernight) OVER (PARTITION BY p.location) * 100, 2) AS percent_of_avg,
    NTILE(4) OVER (PARTITION BY p.location ORDER BY p.pricepernight) AS price_quartile,
    RANK() OVER (PARTITION BY p.location ORDER BY p.pricepernight DESC) AS price_rank_in_location
FROM 
    property p
ORDER BY 
    p.location, p.pricepernight DESC;

-- ==========================================
-- 6. ADDITIONAL QUERY: User activity analysis with cumulative statistics
-- ==========================================
SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS user_name,
    u.role,
    b.booking_id,
    p.name AS property_name,
    b.start_date,
    b.total_price,
    SUM(b.total_price) OVER (PARTITION BY u.user_id ORDER BY b.start_date) AS cumulative_spending,
    ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY b.start_date) AS booking_sequence,
    COUNT(b.booking_id) OVER (PARTITION BY u.user_id) AS total_user_bookings
FROM 
    user u
JOIN 
    booking b ON u.user_id = b.user_id
JOIN 
    property p ON b.property_id = p.property_id
WHERE 
    b.status = 'confirmed'
ORDER BY 
    u.user_id, b.start_date;