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

-- ==========================================
-- 4. ADDITIONAL QUERY: Multiple JOINs - Complete booking information with user, property, and payment details
-- ==========================================
SELECT 
    b.booking_id,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    p.name AS property_name,
    p.location,
    CONCAT(host.first_name, ' ', host.last_name) AS host_name,
    b.start_date,
    b.end_date,
    DATEDIFF(b.end_date, b.start_date) AS nights_stayed,
    b.total_price,
    b.status,
    pay.payment_id,
    pay.amount AS amount_paid,
    pay.payment_date,
    pay.payment_method
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
ORDER BY 
    b.start_date ASC;

-- ==========================================
-- 5. ADDITIONAL QUERY: Self JOIN - Find all messages between users and their replies
-- ==========================================
SELECT 
    m1.message_id AS original_message_id,
    CONCAT(sender.first_name, ' ', sender.last_name) AS sender_name,
    m1.message_body AS original_message,
    m1.sent_at AS original_sent_time,
    m2.message_id AS reply_message_id,
    CONCAT(recipient.first_name, ' ', recipient.last_name) AS recipient_name,
    m2.message_body AS reply_message,
    m2.sent_at AS reply_sent_time
FROM 
    message m1
JOIN 
    message m2 ON m1.sender_id = m2.recipient_id AND m1.recipient_id = m2.sender_id
JOIN 
    user sender ON m1.sender_id = sender.user_id
JOIN 
    user recipient ON m1.recipient_id = recipient.user_id
WHERE 
    m1.sent_at < m2.sent_at
ORDER BY 
    m1.sent_at ASC;

-- ==========================================
-- 6. ADDITIONAL QUERY: Average property ratings by location with property counts
-- ==========================================
SELECT 
    p.location,
    COUNT(DISTINCT p.property_id) AS property_count,
    AVG(r.rating) AS average_rating,
    COUNT(r.review_id) AS review_count
FROM 
    property p
LEFT JOIN 
    review r ON p.property_id = r.property_id
GROUP BY 
    p.location
ORDER BY 
    average_rating DESC, property_count DESC;