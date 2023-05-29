-- tables for data_quality project

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- data for data_quality project
INSERT INTO users (username, email)
VALUES
('user1', 'user1@example.com'),
('user2', 'user2@example.com'),
('user3', 'user3@example.com'),
('user4', null),
('user5', ''),
('user6', 'user1@example.com'),
('user7', 'user7@example.com');
