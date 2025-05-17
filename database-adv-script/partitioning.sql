-- AirBnB Database Table Partitioning Implementation
-- This SQL script demonstrates how to implement partitioning on the Booking table

-- ==========================================
-- 1. First, let's analyze the current query performance (before partitioning)
-- ==========================================

-- Analyze query performance for date range searches on the Booking table
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    p.name AS property_name,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name
FROM 
    booking b
JOIN 
    property p ON b.property_id = p.property_id
JOIN 
    user u ON b.user_id = u.user_id
WHERE 
    b.start_date BETWEEN '2024-06-01' AND '2024-06-30'
ORDER BY 
    b.start_date;

-- ==========================================
-- 2. Backup existing data before modifying the table structure
-- ==========================================

-- Create a temporary table to store current booking data
CREATE TABLE booking_backup LIKE booking;
INSERT INTO booking_backup SELECT * FROM booking;

-- ==========================================
-- 3. Drop foreign key constraints that reference booking table
-- ==========================================

ALTER TABLE payment
DROP FOREIGN KEY payment_ibfk_1;

-- ==========================================
-- 4. Drop and recreate the booking table with partitioning
-- ==========================================

DROP TABLE booking;

-- Create the partitioned booking table
CREATE TABLE booking (
    booking_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_booking_property (property_id),
    INDEX idx_booking_user (user_id),
    INDEX idx_booking_dates_status (start_date, end_date, status),
    INDEX idx_booking_status (status),
    INDEX idx_booking_created_at (created_at),
    INDEX idx_booking_composite (user_id, property_id, status, start_date, end_date),
    FOREIGN KEY (property_id) REFERENCES property(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
    CHECK (end_date > start_date)
) ENGINE=InnoDB
PARTITION BY RANGE (YEAR(start_date) * 100 + MONTH(start_date)) (
    PARTITION p_before_2024 VALUES LESS THAN (202401),
    PARTITION p_2024_01 VALUES LESS THAN (202402),
    PARTITION p_2024_02 VALUES LESS THAN (202403),
    PARTITION p_2024_03 VALUES LESS THAN (202404),
    PARTITION p_2024_04 VALUES LESS THAN (202405),
    PARTITION p_2024_05 VALUES LESS THAN (202406),
    PARTITION p_2024_06 VALUES LESS THAN (202407),
    PARTITION p_2024_07 VALUES LESS THAN (202408),
    PARTITION p_2024_08 VALUES LESS THAN (202409),
    PARTITION p_2024_09 VALUES LESS THAN (202410),
    PARTITION p_2024_10 VALUES LESS THAN (202411),
    PARTITION p_2024_11 VALUES LESS THAN (202412),
    PARTITION p_2024_12 VALUES LESS THAN (202501),
    PARTITION p_2025_01 VALUES LESS THAN (202502),
    PARTITION p_2025_02 VALUES LESS THAN (202503),
    PARTITION p_2025_03 VALUES LESS THAN (202504),
    PARTITION p_2025_04 VALUES LESS THAN (202505),
    PARTITION p_2025_05 VALUES LESS THAN (202506),
    PARTITION p_2025_06 VALUES LESS THAN (202507),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- ==========================================
-- 5. Restore the data from the backup table
-- ==========================================

INSERT INTO booking SELECT * FROM booking_backup;

-- ==========================================
-- 6. Recreate the foreign key constraints in the payment table
-- ==========================================

ALTER TABLE payment
ADD CONSTRAINT payment_ibfk_1 FOREIGN KEY (booking_id) REFERENCES booking(booking_id) ON DELETE CASCADE;

-- ==========================================
-- 7. Drop the backup table
-- ==========================================

DROP TABLE booking_backup;

-- ==========================================
-- 8. Verify partition information
-- ==========================================

-- Show partitions and their row counts
SELECT 
    PARTITION_NAME, 
    TABLE_ROWS
FROM 
    INFORMATION_SCHEMA.PARTITIONS
WHERE 
    TABLE_SCHEMA = DATABASE() AND 
    TABLE_NAME = 'booking';

-- ==========================================
-- 9. Query performance after partitioning
-- ==========================================

-- Test query performance for date range search with partitioning
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    p.name AS property_name,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name
FROM 
    booking b
JOIN 
    property p ON b.property_id = p.property_id
JOIN 
    user u ON b.user_id = u.user_id
WHERE 
    b.start_date BETWEEN '2024-06-01' AND '2024-06-30'
ORDER BY 
    b.start_date;

-- ==========================================
-- 10. Additional test queries for different partitions
-- ==========================================

-- Query for a specific month (partition)
EXPLAIN ANALYZE
SELECT 
    COUNT(*) AS booking_count,
    SUM(total_price) AS total_revenue,
    AVG(total_price) AS avg_booking_value
FROM 
    booking 
WHERE 
    start_date BETWEEN '2024-07-01' AND '2024-07-31' 
    AND status = 'confirmed';

-- Query across multiple months (partitions)
EXPLAIN ANALYZE
SELECT 
    YEAR(start_date) AS booking_year,
    MONTH(start_date) AS booking_month,
    COUNT(*) AS booking_count
FROM 
    booking
WHERE 
    start_date BETWEEN '2024-06-01' AND '2024-09-30'
    AND status = 'confirmed'
GROUP BY 
    YEAR(start_date), MONTH(start_date)
ORDER BY 
    booking_year, booking_month;

-- ==========================================
-- 11. Partition maintenance (for future use)
-- ==========================================

-- Example: How to add a new partition for future months
-- ALTER TABLE booking REORGANIZE PARTITION p_future INTO (
--     PARTITION p_2025_07 VALUES LESS THAN (202508),
--     PARTITION p_future VALUES LESS THAN MAXVALUE
-- );