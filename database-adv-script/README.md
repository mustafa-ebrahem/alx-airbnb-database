# Advanced SQL Join Queries for AirBnB Database

This directory contains SQL scripts demonstrating complex join queries for the AirBnB database schema.

## Overview

The `joins_queries.sql` file demonstrates various types of SQL joins and advanced query techniques to extract meaningful relationships from the AirBnB database.

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

## Usage

To execute these queries:

1. Ensure you have the AirBnB database schema set up from `database-script-0x01/schema.sql`
2. Load the sample data from `database-script-0x02/seed.sql`
3. Connect to your MySQL server:
   ```bash
   mysql -u username -p airbnb_db
   ```
4. Run the join queries:
   ```bash
   source path/to/joins_queries.sql;
   ```

## Notes on SQL Join Performance

- **Indexing**: The queries utilize indexes created in the schema to improve join performance
- **Order of Joins**: The queries are structured to optimize join performance by considering table sizes
- **When to Use Each Join Type**:
  - Use INNER JOIN when you only want records with matches in both tables
  - Use LEFT JOIN when you want all records from the left table regardless of matches
  - Use FULL OUTER JOIN (simulated) when you need all records from both tables

## Learning Outcomes

By studying these queries, you'll learn:

1. How to properly structure complex multi-table joins
2. Techniques for simulating FULL OUTER JOIN in MySQL
3. Practical applications of different join types for business use cases
4. How to combine joins with other SQL features like aggregation and filtering