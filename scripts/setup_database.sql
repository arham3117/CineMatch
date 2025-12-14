-- CineMatch Database Setup Script
-- Complete database initialization in correct order
-- Run this script to set up the entire database

-- =============================================================================
-- CREATE DATABASE
-- =============================================================================

DROP DATABASE IF EXISTS cinematch;
CREATE DATABASE cinematch;
USE cinematch;

-- =============================================================================
-- STEP 1: CREATE TABLES
-- =============================================================================

SOURCE database/schema/01_create_tables.sql;

-- Verify tables created
SELECT 'Tables created successfully' AS status;
SHOW TABLES;

-- =============================================================================
-- STEP 2: CREATE TRIGGERS
-- =============================================================================

SOURCE database/triggers/02_create_triggers.sql;

-- Verify triggers created
SELECT 'Triggers created successfully' AS status;
SHOW TRIGGERS;

-- =============================================================================
-- STEP 3: CREATE CRUD PROCEDURES
-- =============================================================================

SOURCE database/procedures/03_crud_procedures.sql;

-- =============================================================================
-- STEP 4: CREATE RECOMMENDATION ENGINE PROCEDURES
-- =============================================================================

SOURCE database/procedures/04_recommendation_engine.sql;

-- Verify procedures created
SELECT 'Procedures created successfully' AS status;
SHOW PROCEDURE STATUS WHERE Db = 'cinematch';

-- =============================================================================
-- STEP 5: INSERT SAMPLE DATA
-- =============================================================================

SOURCE database/sample-data/05_sample_data.sql;

-- Verify data inserted
SELECT 'Sample data inserted successfully' AS status;

SELECT 'Users' AS table_name, COUNT(*) AS row_count FROM Users
UNION ALL
SELECT 'Movies', COUNT(*) FROM Movies
UNION ALL
SELECT 'Genres', COUNT(*) FROM Genres
UNION ALL
SELECT 'Cast', COUNT(*) FROM Cast
UNION ALL
SELECT 'Ratings', COUNT(*) FROM Ratings
UNION ALL
SELECT 'Reviews', COUNT(*) FROM Reviews
UNION ALL
SELECT 'MovieGenre', COUNT(*) FROM MovieGenre
UNION ALL
SELECT 'MovieCast', COUNT(*) FROM MovieCast
UNION ALL
SELECT 'Watchlist', COUNT(*) FROM Watchlist;

-- =============================================================================
-- VERIFICATION: Test that triggers worked correctly
-- =============================================================================

-- Check that movie ratings were calculated correctly by triggers
SELECT
    movie_id,
    title,
    average_rating,
    total_ratings,
    total_reviews
FROM Movies
WHERE total_ratings > 0
ORDER BY average_rating DESC
LIMIT 10;

-- =============================================================================
-- DATABASE SETUP COMPLETE
-- =============================================================================

SELECT '==================================' AS '';
SELECT 'DATABASE SETUP COMPLETE!' AS status;
SELECT '==================================' AS '';
SELECT 'Database: cinematch' AS '';
SELECT CONCAT('Tables: ', COUNT(*)) AS '' FROM information_schema.tables WHERE table_schema = 'cinematch';
SELECT CONCAT('Triggers: ', COUNT(*)) AS '' FROM information_schema.triggers WHERE trigger_schema = 'cinematch';
SELECT CONCAT('Procedures: ', COUNT(*)) AS '' FROM information_schema.routines WHERE routine_schema = 'cinematch' AND routine_type = 'PROCEDURE';
SELECT '==================================' AS '';
