-- AirBnB Database Sample Data
-- This SQL script populates the AirBnB database with realistic sample data

-- Clear existing data if needed (uncomment if you want to reset data)
/*
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE message;
TRUNCATE TABLE review;
TRUNCATE TABLE payment;
TRUNCATE TABLE booking;
TRUNCATE TABLE property;
TRUNCATE TABLE user;
SET FOREIGN_KEY_CHECKS = 1;
*/

-- Insert Users (a mix of guests, hosts, and admins)
INSERT INTO user (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
('11111111-1111-1111-1111-111111111111', 'John', 'Doe', 'john.doe@example.com', '$2a$10$6KyBxUK.p1J8w2t7F/TNkuZ.5QJnNUfuONJ7EyPJPLXtA1MUm1/O6', '+15551234567', 'guest', '2024-02-10 08:30:00'),
('22222222-2222-2222-2222-222222222222', 'Jane', 'Smith', 'jane.smith@example.com', '$2a$10$7LyJx2N3QpF5K5C1KD9SteQpuJ8YUci.8FgVSKjYhxW9U86qcr4Gy', '+15552345678', 'host', '2024-02-15 10:15:00'),
('33333333-3333-3333-3333-333333333333', 'Michael', 'Johnson', 'michael.j@example.com', '$2a$10$9xMfJ/DZ1bU6UeJX.cvXYO8rFPU4KH7tLfAGvjW5wNHa7YWgimZDe', '+15553456789', 'guest', '2024-03-01 14:20:00'),
('44444444-4444-4444-4444-444444444444', 'Emily', 'Williams', 'emily.w@example.com', '$2a$10$KhD9X2L5j8J3FxY5OkV3QeX/RKrSG1S1ZvQG3ULw4aT9K8HZT5OVm', '+15554567890', 'host', '2024-03-05 09:45:00'),
('55555555-5555-5555-5555-555555555555', 'David', 'Brown', 'david.b@example.com', '$2a$10$PkL9X3Y2Z5N7JvQG4pR8EuGm6K3HxL5wK8JsTpF5D7X9V7LzW3LXe', '+15555678901', 'guest', '2024-03-10 11:30:00'),
('66666666-6666-6666-6666-666666666666', 'Sarah', 'Miller', 'sarah.m@example.com', '$2a$10$XnM2Y5Z6P8Q9E3F4G7T1pO7JsTrF9K4C5L2W3X8V6N9R2K1D5S4Lq', '+15556789012', 'host', '2024-03-15 16:20:00'),
('77777777-7777-7777-7777-777777777777', 'Robert', 'Wilson', 'robert.w@example.com', '$2a$10$QpL3X2Z5N7JvQG4pR8EuGm6K3HxL5wK8JsTpF5D7X9V7LzW3LXe5f', '+15557890123', 'admin', '2024-01-05 08:00:00'),
('88888888-8888-8888-8888-888888888888', 'Jessica', 'Taylor', 'jessica.t@example.com', '$2a$10$RmN2Y5Z6P8Q9E3F4G7T1pO7JsTrF9K4C5L2W3X8V6N9R2K1D5S4Lq', '+15558901234', 'guest', '2024-03-20 13:10:00'),
('99999999-9999-9999-9999-999999999999', 'Thomas', 'Anderson', 'thomas.a@example.com', '$2a$10$SmN2Y5Z6P8Q9E3F4G7T1pO7JsTrF9K4C5L2W3X8V6N9R2K1D5S4Lq', '+15559012345', 'host', '2024-03-25 15:45:00'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Lisa', 'Martin', 'lisa.m@example.com', '$2a$10$TnM2Y5Z6P8Q9E3F4G7T1pO7JsTrF9K4C5L2W3X8V6N9R2K1D5S4Lq', '+15550123456', 'guest', '2024-04-01 10:30:00');

-- Insert Properties
INSERT INTO property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at) VALUES
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '22222222-2222-2222-2222-222222222222', 'Seaside Villa', 'Beautiful villa with ocean views', 'Malibu, CA', 350.00, '2024-02-16 09:30:00', '2024-02-16 09:30:00'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', '44444444-4444-4444-4444-444444444444', 'Mountain Cabin', 'Cozy cabin in the woods', 'Aspen, CO', 220.00, '2024-03-06 10:15:00', '2024-03-10 14:20:00'),
('dddddddd-dddd-dddd-dddd-dddddddddddd', '66666666-6666-6666-6666-666666666666', 'Downtown Loft', 'Modern loft in the heart of the city', 'New York, NY', 280.00, '2024-03-16 11:30:00', '2024-03-16 11:30:00'),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '99999999-9999-9999-9999-999999999999', 'Desert Oasis', 'Peaceful retreat with pool', 'Phoenix, AZ', 190.00, '2024-03-26 13:45:00', '2024-04-01 09:15:00'),
('ffffffff-ffff-ffff-ffff-ffffffffffff', '22222222-2222-2222-2222-222222222222', 'Lakefront Cottage', 'Charming cottage by the lake', 'Lake Tahoe, CA', 260.00, '2024-04-05 15:30:00', '2024-04-05 15:30:00'),
('gggggggg-gggg-gggg-gggg-gggggggggggg', '44444444-4444-4444-4444-444444444444', 'City Apartment', 'Stylish apartment in downtown', 'Chicago, IL', 175.00, '2024-04-10 08:45:00', '2024-04-10 08:45:00'),
('hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh', '66666666-6666-6666-6666-666666666666', 'Beach House', 'Spacious house steps from the beach', 'Miami, FL', 310.00, '2024-04-15 10:00:00', '2024-04-20 16:30:00'),
('iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii', '99999999-9999-9999-9999-999999999999', 'Country Farmhouse', 'Rustic farmhouse with modern amenities', 'Nashville, TN', 200.00, '2024-04-25 11:15:00', '2024-04-25 11:15:00');

-- Insert Bookings
INSERT INTO booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
('jjjjjjjj-jjjj-jjjj-jjjj-jjjjjjjjjjjj', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111', '2024-06-10', '2024-06-15', 1750.00, 'confirmed', '2024-05-01 09:30:00'),
('kkkkkkkk-kkkk-kkkk-kkkk-kkkkkkkkkkkk', 'cccccccc-cccc-cccc-cccc-cccccccccccc', '33333333-3333-3333-3333-333333333333', '2024-06-20', '2024-06-25', 1100.00, 'confirmed', '2024-05-05 10:45:00'),
('llllllll-llll-llll-llll-llllllllllll', 'dddddddd-dddd-dddd-dddd-dddddddddddd', '55555555-5555-5555-5555-555555555555', '2024-07-01', '2024-07-08', 1960.00, 'confirmed', '2024-05-10 14:15:00'),
('mmmmmmmm-mmmm-mmmm-mmmm-mmmmmmmmmmmm', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '88888888-8888-8888-8888-888888888888', '2024-07-15', '2024-07-20', 950.00, 'pending', '2024-05-15 16:30:00'),
('nnnnnnnn-nnnn-nnnn-nnnn-nnnnnnnnnnnn', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '2024-08-05', '2024-08-12', 1820.00, 'canceled', '2024-05-20 11:00:00'),
('oooooooo-oooo-oooo-oooo-oooooooooooo', 'gggggggg-gggg-gggg-gggg-gggggggggggg', '11111111-1111-1111-1111-111111111111', '2024-08-15', '2024-08-22', 1225.00, 'confirmed', '2024-05-22 13:20:00'),
('pppppppp-pppp-pppp-pppp-pppppppppppp', 'hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh', '33333333-3333-3333-3333-333333333333', '2024-09-01', '2024-09-07', 1860.00, 'pending', '2024-05-25 09:45:00'),
('qqqqqqqq-qqqq-qqqq-qqqq-qqqqqqqqqqqq', 'iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii', '55555555-5555-5555-5555-555555555555', '2024-09-15', '2024-09-22', 1400.00, 'confirmed', '2024-05-30 15:10:00');

-- Insert Payments
INSERT INTO payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
('rrrrrrrr-rrrr-rrrr-rrrr-rrrrrrrrrrrr', 'jjjjjjjj-jjjj-jjjj-jjjj-jjjjjjjjjjjj', 1750.00, '2024-05-01 09:35:00', 'credit_card'),
('ssssssss-ssss-ssss-ssss-ssssssssssss', 'kkkkkkkk-kkkk-kkkk-kkkk-kkkkkkkkkkkk', 1100.00, '2024-05-05 10:50:00', 'paypal'),
('tttttttt-tttt-tttt-tttt-tttttttttttt', 'llllllll-llll-llll-llll-llllllllllll', 1960.00, '2024-05-10 14:20:00', 'credit_card'),
('uuuuuuuu-uuuu-uuuu-uuuu-uuuuuuuuuuuu', 'oooooooo-oooo-oooo-oooo-oooooooooooo', 1225.00, '2024-05-22 13:25:00', 'stripe'),
('vvvvvvvv-vvvv-vvvv-vvvv-vvvvvvvvvvvv', 'qqqqqqqq-qqqq-qqqq-qqqq-qqqqqqqqqqqq', 1400.00, '2024-05-30 15:15:00', 'credit_card');

-- Insert Reviews (for completed stays)
INSERT INTO review (review_id, property_id, user_id, rating, comment, created_at) VALUES
('wwwwwwww-wwww-wwww-wwww-wwwwwwwwwwww', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111', 5, 'Amazing place with incredible views! The host was very accommodating.', '2024-06-16 10:30:00'),
('xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx', 'cccccccc-cccc-cccc-cccc-cccccccccccc', '33333333-3333-3333-3333-333333333333', 4, 'Very cozy cabin. Loved the fireplace and surrounding nature.', '2024-06-26 14:15:00'),
('yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy', 'dddddddd-dddd-dddd-dddd-dddddddddddd', '55555555-5555-5555-5555-555555555555', 5, 'Perfect location in the city. Everything was within walking distance.', '2024-07-09 11:45:00'),
('zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 3, 'Nice cottage but had some issues with the heating system.', '2024-08-14 09:20:00'),
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', 'gggggggg-gggg-gggg-gggg-gggggggggggg', '11111111-1111-1111-1111-111111111111', 4, 'Clean and stylish apartment. Great amenities.', '2024-08-23 16:10:00');

-- Insert Messages
INSERT INTO message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
('b1b1b1b1-b1b1-b1b1-b1b1-b1b1b1b1b1b1', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 'Hi, I have a question about your Seaside Villa. Is the beach accessible directly from the property?', '2024-04-25 10:30:00'),
('c1c1c1c1-c1c1-c1c1-c1c1-c1c1c1c1c1c1', '22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'Hello! Yes, there is a private path that leads directly to the beach from the backyard.', '2024-04-25 11:15:00'),
('d1d1d1d1-d1d1-d1d1-d1d1-d1d1d1d1d1d1', '33333333-3333-3333-3333-333333333333', '44444444-4444-4444-4444-444444444444', 'Is your Mountain Cabin suitable for a family with small children?', '2024-04-30 09:45:00'),
('e1e1e1e1-e1e1-e1e1-e1e1-e1e1e1e1e1e1', '44444444-4444-4444-4444-444444444444', '33333333-3333-3333-3333-333333333333', 'Yes, it is! We have a gated porch and child safety locks on all cabinets.', '2024-04-30 10:20:00'),
('f1f1f1f1-f1f1-f1f1-f1f1-f1f1f1f1f1f1', '55555555-5555-5555-5555-555555555555', '66666666-6666-6666-6666-666666666666', 'Do you provide parking for the Downtown Loft?', '2024-05-05 14:30:00'),
('g1g1g1g1-g1g1-g1g1-g1g1-g1g1g1g1g1g1', '66666666-6666-6666-6666-666666666666', '55555555-5555-5555-5555-555555555555', 'We offer one parking space in the garage below the building included in your stay.', '2024-05-05 15:10:00'),
('h1h1h1h1-h1h1-h1h1-h1h1-h1h1h1h1h1h1', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 'Thanks for the information. I just booked your villa for June. Looking forward to our stay!', '2024-05-01 10:00:00'),
('i1i1i1i1-i1i1-i1i1-i1i1-i1i1i1i1i1i1', '22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'Great! Looking forward to hosting you. Let me know if you need any recommendations for the area.', '2024-05-01 10:45:00'),
('j1j1j1j1-j1j1-j1j1-j1j1-j1j1j1j1j1j1', '88888888-8888-8888-8888-888888888888', '99999999-9999-9999-9999-999999999999', 'Is the pool heated at the Desert Oasis?', '2024-05-12 13:20:00'),
('k1k1k1k1-k1k1-k1k1-k1k1-k1k1k1k1k1k1', '99999999-9999-9999-9999-999999999999', '88888888-8888-8888-8888-888888888888', 'Yes, the pool is heated and maintained at a comfortable temperature year-round.', '2024-05-12 14:05:00');

-- Additional data can be added as needed