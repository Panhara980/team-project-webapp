DROP DATABASE IF EXISTS notes_system;
CREATE DATABASE notes_system CHARACTER SET utf8mb4;
USE notes_system;

CREATE TABLE users (
    user_id     INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    full_name   VARCHAR(100) NOT NULL,
    role        ENUM('STUDENT', 'PROFESSOR') NOT NULL DEFAULT 'STUDENT',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notes (
    note_id     INT AUTO_INCREMENT PRIMARY KEY,
    title       VARCHAR(200) NOT NULL,
    subject     VARCHAR(100) NOT NULL DEFAULT 'General',
    content     TEXT NOT NULL,
    user_id     INT NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notes_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
);

INSERT INTO users (username, password, full_name, role) VALUES
('prof.smith', 'password123', 'Prof. Smith', 'PROFESSOR'),
('j.chen',     'password123', 'J. Chen',     'STUDENT');

INSERT INTO notes (title, subject, content, user_id) VALUES
('Midterm Exam Schedule - Fall 2026', 'General',
 'The midterm examination schedule for Fall 2026 has been finalized. All exams will be held in the main examination hall. Students must bring their university ID cards.',
 1),
('Calculus II Problem Set 4 Released', 'Mathematics',
 'Problem Set 4 covering integration by parts and improper integrals is now available. Due date is September 15th.',
 1),
('Lab Safety Briefing - Mandatory Attendance', 'Science',
 'All students in CHEM 201, BIO 102, and PHYS 150 must attend the annual lab safety briefing.',
 1);