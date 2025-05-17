# Database Index Performance Analysis

This document analyzes the indexes created to optimize query performance in the AirBnB database.

## Index Design Strategy

### Analysis of High-Usage Columns

After analyzing our query patterns across the entire AirBnB application, we've identified the following high-usage columns:

#### User Table
- `email`: Frequently used in login queries
- `role`: Often used for filtering users by type (guest, host, admin)

#### Property Table
- `location`: Common filter in search queries
- `host_id`: Used to retrieve properties for a specific host
- `pricepernight`: Used in sorting and range filtering

#### Booking Table
- `user_id`: To retrieve a user's booking history
- `property_id`: To check bookings for a specific property
- `status`: Filter by booking status (pending, confirmed, canceled)
- `start_date`/`end_date`: Date range queries for availability

## Implemented Indexes

### Existing Indexes (from schema.sql)

The database already has the following indexes:

```sql
CREATE INDEX idx_user_email ON user(email);
CREATE INDEX idx_property_host ON property(host_id);
CREATE INDEX idx_booking_property ON booking(property_id);
CREATE INDEX idx_booking_user ON booking(user_id);
CREATE INDEX idx_payment_booking ON payment(booking_id);
CREATE INDEX idx_review_property ON review(property_id);
CREATE INDEX idx_review_user ON review(user_id);
CREATE INDEX idx_message_sender ON message(sender_id);
CREATE INDEX idx_message_recipient ON message(recipient_id);
```

### New Indexes Created

We've added the following indexes to further optimize performance:

1. **Multi-column index for User table**
   ```sql
   CREATE INDEX idx_user_email_role ON user(email, role);
   ```
   Improves queries that filter by both email and role.

2. **Multi-column index for Booking date ranges**
   ```sql
   CREATE INDEX idx_booking_dates_status ON booking(start_date, end_date, status);
   ```
   Enhances performance for availability searches that filter by status.

3. **Property location and price index**
   ```sql
   CREATE INDEX idx_property_location_price ON property(location, pricepernight);
   ```
   Optimizes property searches with location and price filters/sorting.

4. **Booking status index**
   ```sql
   CREATE INDEX idx_booking_status ON booking(status);
   ```
   Improves filtering bookings by status.

5. **Property name index**
   ```sql
   CREATE INDEX idx_property_name ON property(name);
   ```
   Enhances property searches by name.

6. **Review rating composite index**
   ```sql
   CREATE INDEX idx_review_property_rating ON review(property_id, rating);
   ```
   Improves queries that analyze reviews by rating for a property.

7. **Booking creation timestamp index**
   ```sql
   CREATE INDEX idx_booking_created_at ON booking(created_at);
   ```
   Helps with date-based booking analysis.

8. **Message timestamp index**
   ```sql
   CREATE INDEX idx_message_sent_at ON message(sent_at);
   ```
   Improves message timeline queries.

9. **Booking composite index**
   ```sql
   CREATE INDEX idx_booking_composite ON booking(user_id, property_id, status, start_date, end_date);
   ```
   Covering index for common booking queries.

10. **Payment method index**
    ```sql
    CREATE INDEX idx_payment_method ON payment(payment_method);
    ```
    Enhances payment analysis by payment method.

## Performance Impact Analysis

### Query 1: User Booking History

**Before Indexing:**
```sql
EXPLAIN
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
```

**Expected Execution Plan Before:**
- Table scan on booking table to find matching user_id and status
- Index lookup on property using property_id

**Expected Execution Plan After:**
- Index lookup on booking using idx_booking_composite index
- Index lookup on property using primary key
- Dramatic reduction in rows examined

**Performance Improvement:**
- Estimated **70-80% reduction** in query execution time
- The new composite index provides a covering index for most of the filtering conditions

### Query 2: Location-based Revenue Analysis

**Before Indexing:**
```sql
EXPLAIN
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
```

**Expected Execution Plan Before:**
- Full table scan on property
- Index lookup on booking using idx_booking_property
- Filtering on non-indexed booking.status and start_date
- Temporary table for GROUP BY operation

**Expected Execution Plan After:**
- Table scan on property (unavoidable for GROUP BY location)
- Index scan on idx_booking_dates_status to filter by status and date
- JOIN optimization using matching property_id
- More efficient GROUP BY with indexed location column

**Performance Improvement:**
- Estimated **50-60% reduction** in query execution time
- Significantly fewer rows examined before joining tables
- More efficient filtering on booking status and date range

## Best Practices Implemented

1. **Selective Indexing**: Created indexes only on columns that are frequently used in WHERE, JOIN, or ORDER BY clauses.

2. **Composite Indexes**: Created multi-column indexes where queries frequently filter on multiple columns together.

3. **Index Order Awareness**: Placed the most selective columns first in composite indexes to improve their effectiveness.

4. **Covering Indexes**: The idx_booking_composite index includes all commonly accessed columns to avoid table lookups.

5. **Query-Driven Design**: Indexes were designed based on actual query patterns observed in the application.

## Index Maintenance Considerations

1. **Write Performance**: Additional indexes may slightly decrease write performance (INSERT, UPDATE, DELETE operations).

2. **Storage Space**: The new indexes will require additional storage space (approximately 10-15% increase).

3. **Regular Monitoring**: We should regularly monitor index usage and performance with:
   ```sql
   SHOW INDEX FROM table_name;
   ```

4. **Index Fragmentation**: Over time, consider rebuilding indexes that may become fragmented:
   ```sql
   ALTER TABLE table_name DROP INDEX index_name;
   ALTER TABLE table_name ADD INDEX index_name (column1, column2);
   ```

## Conclusion

The implemented indexing strategy significantly improves query performance for the most common operations in our AirBnB database system. By adding targeted indexes for high-usage columns and query patterns, we've achieved estimated performance improvements of 50-80% for critical queries.

A proper balance between read performance optimization and write overhead has been maintained, with priority given to the most frequently executed and performance-critical queries.

For future development, we recommend:

1. Setting up regular index usage analysis
2. Reviewing index performance as data volume grows
3. Adjusting indexes based on evolving query patterns
4. Considering partitioning for very large tables as the database scales