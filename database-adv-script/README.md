# Advanced SQL Queries for AirBnB Database

This directory contains SQL scripts demonstrating complex queries for the AirBnB database schema.

## Overview

- The `joins_queries.sql` file demonstrates various types of SQL joins and advanced query techniques.
- The `subqueries.sql` file showcases different types of subqueries (correlated and non-correlated).
- The `aggregations_and_window_functions.sql` file illustrates aggregation functions and window functions for data analysis.

## Join Types Demonstrated

### 1. INNER JOIN
- **Query**: Retrieve all bookings and their respective users
- **Description**: Shows all bookings matched with the users who made them
- **Use Case**: Useful for generating guest reports and analyzing booking patterns by user

### 2. LEFT JOIN
- **Query**: Retrieve all properties and their reviews (including properties with no reviews)
- **Description**: Lists all properties along with any reviews they have received, including properties with no reviews
- **Use Case**: Helpful for property listing pages where you want to show all properties regardless of review status

### 3. FULL OUTER JOIN (Simulated in MySQL)
- **Query**: Retrieve all users and all bookings (even if user has no booking or booking has no user)
- **Description**: Since MySQL doesn't directly support FULL OUTER JOIN, this query demonstrates how to simulate it using LEFT JOIN + UNION + RIGHT JOIN
- **Use Case**: Comprehensive user activity analysis, ensuring no data is missed

## Additional Advanced Queries

### 4. Multiple Joins
- **Query**: Complete booking information with user, property, and payment details
- **Description**: Combines data from multiple tables (booking, user, property, payment) to create a comprehensive view of booking information
- **Use Case**: Administrative dashboards and detailed booking reports

### 5. Self Join
- **Query**: Find all messages between users and their replies
- **Description**: Uses a self join on the message table to match conversations between users
- **Use Case**: Message thread visualization and conversation analysis

### 6. Aggregation with Joins
- **Query**: Average property ratings by location with property counts
- **Description**: Groups properties by location and calculates average ratings and counts
- **Use Case**: Market analysis and location performance metrics

## Subquery Types Demonstrated

### 1. Non-correlated Subquery
- **Query**: Find all properties where the average rating is greater than 4.0
- **Description**: Uses a subquery that can run independently of the outer query
- **Use Case**: Highlighting top-rated properties for promotional content

### 2. Correlated Subquery
- **Query**: Find users who have made more than 3 bookings
- **Description**: Uses a subquery that references columns from the outer query
- **Use Case**: Identifying frequent customers for loyalty programs

### 3. Correlated Subquery with EXISTS
- **Query**: Find hosts who have properties with at least one 5-star review
- **Description**: Uses the EXISTS operator with a correlated subquery
- **Use Case**: Identifying high-performing hosts for recognition programs

### 4. Nested Subqueries
- **Query**: Find properties that have more bookings than the average
- **Description**: Demonstrates subqueries within subqueries
- **Use Case**: Identifying popular properties for investment analysis

## Aggregation and Window Functions

### 1. Basic Aggregation with GROUP BY
- **Query**: Total number of bookings made by each user
- **Description**: Uses COUNT function and GROUP BY to aggregate booking data by user
- **Use Case**: Customer activity analysis and identifying power users

### 2. Window Functions for Ranking
- **Query**: Rank properties based on total number of bookings
- **Description**: Uses different ranking functions (ROW_NUMBER, RANK, DENSE_RANK) to show different ranking approaches
- **Use Case**: Creating leaderboards of popular properties and competitive analysis

### 3. Advanced Aggregations for Location Analysis
- **Query**: Comprehensive booking statistics by location
- **Description**: Uses multiple aggregation functions (COUNT, AVG, MIN, MAX, SUM) to provide statistical insights
- **Use Case**: Regional performance analysis and investment planning

### 4. Time-based Analysis with Date Functions
- **Query**: Monthly booking trends analysis
- **Description**: Uses date functions with aggregations to analyze booking patterns over time
- **Use Case**: Seasonal trend analysis and revenue forecasting

### 5. Percentile Analysis with Window Functions
- **Query**: Price analysis of properties by location
- **Description**: Uses advanced window functions to analyze pricing strategies within locations
- **Use Case**: Competitive pricing analysis and market positioning

### 6. User Activity Analysis with Cumulative Statistics
- **Query**: Progressive user activity tracking
- **Description**: Uses window functions to calculate running totals and sequential statistics
- **Use Case**: Customer journey analysis and lifetime value tracking

## Usage

To execute these queries:

1. Ensure you have the AirBnB database schema set up from `database-script-0x01/schema.sql`
2. Load the sample data from `database-script-0x02/seed.sql`
3. Connect to your MySQL server:
   ```bash
   mysql -u username -p airbnb_db
   ```
4. Run the queries:
   ```bash
   source path/to/joins_queries.sql;
   source path/to/subqueries.sql;
   source path/to/aggregations_and_window_functions.sql;
   ```

## Notes on SQL Join Performance

- **Indexing**: The queries utilize indexes created in the schema to improve join performance
- **Order of Joins**: The queries are structured to optimize join performance by considering table sizes
- **When to Use Each Join Type**:
  - Use INNER JOIN when you only want records with matches in both tables
  - Use LEFT JOIN when you want all records from the left table regardless of matches
  - Use FULL OUTER JOIN (simulated) when you need all records from both tables

## Notes on SQL Subquery Performance

- **Execution Order**: The inner subquery typically executes first, then the outer query
- **Correlated Subqueries**: May execute once for each row processed by the outer query
- **Alternatives**: In some cases, JOINs might be more efficient than correlated subqueries
- **Indexing**: Proper indexing is crucial for subquery performance

## Notes on Aggregation and Window Function Performance

- **GROUP BY Optimization**: Proper indexing on grouped columns can significantly improve performance
- **Window Functions Overhead**: Window functions may be more resource-intensive than simple aggregations
- **Partitioning Impact**: Using PARTITION BY with large datasets can increase memory usage
- **Materialized Views**: For frequently used aggregations, consider materialized views or summary tables

## Learning Outcomes

By studying these queries, you'll learn:

1. How to properly structure complex multi-table joins, subqueries, and aggregations
2. How to choose appropriate window functions for different analytical needs
3. Techniques for optimizing performance of aggregation and window functions
4. How to extract meaningful business intelligence through SQL data analysis