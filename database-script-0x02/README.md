# AirBnB Sample Data

This directory contains SQL scripts to populate the AirBnB database with sample data.

## Overview

The `seed.sql` file inserts realistic sample data into the database tables created by the schema.sql script in the database-script-0x01 directory.

## Sample Data Contents

The seed data includes:

1. **Users** - A mix of guests, hosts, and admins
2. **Properties** - Various property listings with different locations and prices
3. **Bookings** - Sample bookings with different statuses and dates
4. **Payments** - Payment records for bookings
5. **Reviews** - Sample property reviews with ratings and comments
6. **Messages** - Communication samples between users

## Usage

To populate your database with the sample data:

1. Ensure you have first run the schema.sql script from the database-script-0x01 directory
2. Connect to your MySQL server:
   ```bash
   mysql -u username -p airbnb_db
   ```
3. Run the seed script:
   ```bash
   source path/to/seed.sql;
   ```

## Data Generation Strategy

- UUIDs are pre-generated for all entities to ensure consistent relationships
- The sample data maintains referential integrity across all tables
- Realistic scenarios are modeled (bookings in different states, varied review scores, etc.)
- Data is organized chronologically where time is a factor (e.g., messages, bookings)

## Notes

- Running this script multiple times will result in duplicate data
- To reset the database, you can:
  1. Drop all tables and re-run schema.sql
  2. Truncate all tables before running seed.sql again

## Files

- `seed.sql`: Contains all SQL statements to insert sample data into the database schema