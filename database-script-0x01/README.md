# AirBnB Database Schema

This directory contains the SQL scripts to create the database schema for the AirBnB clone project.

## Overview

The schema.sql file creates all the necessary tables, constraints, and indexes for the AirBnB database, implementing the entity-relationship diagram defined in the project specifications.

## Tables

The database consists of the following tables:

1. **User** - Stores user information including guests, hosts, and administrators
2. **Property** - Contains details about properties listed on the platform
3. **Booking** - Tracks reservation information for properties
4. **Payment** - Records payment details associated with bookings
5. **Review** - Stores user reviews and ratings for properties
6. **Message** - Manages communication between users

## Schema Features

- **UUID Primary Keys** - All tables use UUID (CHAR(36)) as primary keys for security and scalability
- **Foreign Key Constraints** - Maintains referential integrity between related tables
- **Check Constraints** - Ensures data validity (e.g., rating values between 1-5)
- **Indexes** - Optimizes query performance for frequently accessed columns
- **Timestamps** - Tracks creation and modification times for relevant entities
- **Enumerations** - Restricts certain columns to predefined values (e.g., booking status)


## Database Design Notes

- The schema follows Third Normal Form (3NF) principles
- ON DELETE CASCADE is used where appropriate to maintain data consistency
- Appropriate data types are selected to balance storage efficiency and functionality
- Proper indexing strategy is implemented to enhance query performance

## Entity Relationships

- **User to Property**: One-to-Many (One user can host multiple properties)
- **User to Booking**: One-to-Many (One user can make multiple bookings)
- **Property to Booking**: One-to-Many (One property can have multiple bookings)
- **Booking to Payment**: One-to-One (Each booking has one payment)
- **User to Review**: One-to-Many (One user can write multiple reviews)
- **Property to Review**: One-to-Many (One property can receive multiple reviews)
- **User to Message**: One-to-Many (Users can send/receive multiple messages)

## Files

- `schema.sql`: Contains all SQL statements to create the database schema