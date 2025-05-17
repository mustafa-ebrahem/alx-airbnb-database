-- AirBnB Database Performance Optimization - Index Creation
-- This SQL script creates additional indexes to improve query performance

-- ==========================================
-- EXPLAIN ANALYZE output before adding new indexes
-- ==========================================

-- Example query analyzing user booking history
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    p.name AS property_name,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM 
    booking b
JOIN 
    property p ON b.property_id = p.property_id
WHERE 
    b.user_id = '11111111-1111-1111-1111-111111111111'
    AND b.status = 'confirmed';

-- Example query analyzing property location performance
EXPLAIN ANALYZE
SELECT 
    p.location,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_revenue
FROM 
    property p
LEFT JOIN 
    booking b ON p.property_id = b.property_id
WHERE 
    b.status = 'confirmed'
    AND b.start_date >= '2024-01-01'
GROUP BY 
    p.location;

-- ==========================================
-- CREATE NEW INDEXES
-- ==========================================

-- 1. Multi-column index for User table - frequently filtered by email and role
CREATE INDEX idx_user_email_role ON user(email, role);

-- 2. Multi-column index for Booking table - frequently queried by date ranges and status
CREATE INDEX idx_booking_dates_status ON booking(start_date, end_date, status);

-- 3. Multi-column index for Property table - frequently filtered and sorted by location and price
CREATE INDEX idx_property_location_price ON property(location, pricepernight);

-- 4. Index for frequently queried booking statuses
CREATE INDEX idx_booking_status ON booking(status);

-- 5. Index for property searching by name (for full or partial text searches)
CREATE INDEX idx_property_name ON property(name);

-- 6. Composite index for Review table - analyzing reviews by rating
CREATE INDEX idx_review_property_rating ON review(property_id, rating);

-- 7. Index for date-based booking analysis
CREATE INDEX idx_booking_created_at ON booking(created_at);

-- 8. Index for filtering messages by timestamp
CREATE INDEX idx_message_sent_at ON message(sent_at);

-- 9. Covering index for commonly accessed Booking information
CREATE INDEX idx_booking_composite ON booking(user_id, property_id, status, start_date, end_date);

-- 10. Index for payment method analysis
CREATE INDEX idx_payment_method ON payment(payment_method);

-- ==========================================
-- EXPLAIN ANALYZE output after adding new indexes
-- ==========================================

-- Re-analyze the same queries after adding indexes
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    p.name AS property_name,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM 
    booking b
JOIN 
    property p ON b.property_id = p.property_id
WHERE 
    b.user_id = '11111111-1111-1111-1111-111111111111'
    AND b.status = 'confirmed';

-- Second query re-analyzed after adding indexes
EXPLAIN ANALYZE
SELECT 
    p.location,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_revenue
FROM 
    property p
LEFT JOIN 
    booking b ON p.property_id = b.property_id
WHERE 
    b.status = 'confirmed'
    AND b.start_date >= '2024-01-01'
GROUP BY 
    p.location;

-- ==========================================
-- Additional index performance metrics
-- ==========================================

-- Time-based booking query with specific location filter
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    u.email AS guest_email,
    p.name AS property_name,
    p.location
FROM 
    booking b
JOIN 
    user u ON b.user_id = u.user_id
JOIN 
    property p ON b.property_id = p.property_id
WHERE 
    p.location LIKE 'New York%'
    AND b.start_date BETWEEN '2024-06-01' AND '2024-08-31'
    AND b.status = 'confirmed'
ORDER BY 
    b.start_date ASC;

-- Analyze performance of high-value booking search with multiple filters
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.total_price,
    p.name AS property_name,
    p.location,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name
FROM 
    booking b
JOIN 
    property p ON b.property_id = p.property_id
JOIN 
    user u ON b.user_id = u.user_id
WHERE 
    b.total_price > 1000
    AND p.pricepernight > 200
    AND b.status = 'confirmed'
ORDER BY 
    b.total_price DESC
LIMIT 10;

-- Payment method distribution analysis
EXPLAIN ANALYZE
SELECT 
    pay.payment_method,
    COUNT(*) AS payment_count,
    SUM(pay.amount) AS total_amount,
    AVG(pay.amount) AS average_amount
FROM 
    payment pay
JOIN 
    booking b ON pay.booking_id = b.booking_id
WHERE 
    pay.payment_date >= '2024-01-01'
GROUP BY 
    pay.payment_method
ORDER BY 
    total_amount DESC;

-- Host revenue analysis with multi-table joins
EXPLAIN ANALYZE
SELECT 
    CONCAT(u.first_name, ' ', u.last_name) AS host_name,
    COUNT(DISTINCT p.property_id) AS property_count,
    COUNT(b.booking_id) AS booking_count,
    SUM(b.total_price) AS total_revenue,
    AVG(r.rating) AS average_rating
FROM 
    user u
JOIN 
    property p ON u.user_id = p.host_id
LEFT JOIN 
    booking b ON p.property_id = b.property_id AND b.status = 'confirmed'
LEFT JOIN 
    review r ON p.property_id = r.property_id
WHERE 
    u.role = 'host'
GROUP BY 
    u.user_id, u.first_name, u.last_name
HAVING 
    COUNT(b.booking_id) > 0
ORDER BY 
    total_revenue DESC;