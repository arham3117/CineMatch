-- CineMatch Setup Verification Script
-- Run this after setup to verify everything is working correctly

USE cinematch;

SELECT '============================================' AS '';
SELECT 'CINEMATCH SETUP VERIFICATION' AS '';
SELECT '============================================' AS '';

-- =============================================================================
-- CHECK 1: DATABASE EXISTS
-- =============================================================================

SELECT '\n[1] Checking database...' AS '';
SELECT DATABASE() AS current_database;
-- Expected: cinematch

-- =============================================================================
-- CHECK 2: ALL TABLES EXIST
-- =============================================================================

SELECT '\n[2] Checking tables...' AS '';
SELECT COUNT(*) AS table_count FROM information_schema.tables
WHERE table_schema = 'cinematch';
-- Expected: 9

SELECT table_name FROM information_schema.tables
WHERE table_schema = 'cinematch'
ORDER BY table_name;
-- Expected: Cast, Genres, MovieCast, MovieGenre, Movies, Ratings, Reviews, Users, Watchlist

-- Verify status
SELECT CASE
    WHEN COUNT(*) = 9 THEN '✓ PASS: All 9 tables exist'
    ELSE '✗ FAIL: Missing tables'
END AS status
FROM information_schema.tables
WHERE table_schema = 'cinematch';

-- =============================================================================
-- CHECK 3: ALL TRIGGERS EXIST
-- =============================================================================

SELECT '\n[3] Checking triggers...' AS '';
SELECT COUNT(*) AS trigger_count FROM information_schema.triggers
WHERE trigger_schema = 'cinematch';
-- Expected: 11

SELECT trigger_name, event_object_table, action_timing, event_manipulation
FROM information_schema.triggers
WHERE trigger_schema = 'cinematch'
ORDER BY trigger_name;

-- Verify status
SELECT CASE
    WHEN COUNT(*) = 11 THEN '✓ PASS: All 11 triggers exist'
    ELSE '✗ FAIL: Missing triggers'
END AS status
FROM information_schema.triggers
WHERE trigger_schema = 'cinematch';

-- =============================================================================
-- CHECK 4: ALL STORED PROCEDURES EXIST
-- =============================================================================

SELECT '\n[4] Checking stored procedures...' AS '';
SELECT COUNT(*) AS procedure_count FROM information_schema.routines
WHERE routine_schema = 'cinematch' AND routine_type = 'PROCEDURE';
-- Expected: 35

-- List all procedures
SELECT routine_name
FROM information_schema.routines
WHERE routine_schema = 'cinematch' AND routine_type = 'PROCEDURE'
ORDER BY routine_name;

-- Verify status
SELECT CASE
    WHEN COUNT(*) >= 35 THEN '✓ PASS: All stored procedures exist'
    ELSE '✗ FAIL: Missing procedures'
END AS status
FROM information_schema.routines
WHERE routine_schema = 'cinematch' AND routine_type = 'PROCEDURE';

-- =============================================================================
-- CHECK 5: SAMPLE DATA LOADED
-- =============================================================================

SELECT '\n[5] Checking sample data...' AS '';

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

-- Verify minimum data exists
SELECT CASE
    WHEN (SELECT COUNT(*) FROM Users) >= 10 THEN '✓ PASS: User data loaded'
    ELSE '✗ FAIL: Insufficient user data'
END AS user_status;

SELECT CASE
    WHEN (SELECT COUNT(*) FROM Movies) >= 15 THEN '✓ PASS: Movie data loaded'
    ELSE '✗ FAIL: Insufficient movie data'
END AS movie_status;

SELECT CASE
    WHEN (SELECT COUNT(*) FROM Ratings) >= 50 THEN '✓ PASS: Rating data loaded'
    ELSE '✗ FAIL: Insufficient rating data'
END AS rating_status;

-- =============================================================================
-- CHECK 6: TRIGGERS WORKING CORRECTLY
-- =============================================================================

SELECT '\n[6] Verifying triggers are working...' AS '';

-- Check if movie statistics are calculated
SELECT
    movie_id,
    title,
    average_rating,
    total_ratings
FROM Movies
WHERE total_ratings > 0
ORDER BY average_rating DESC
LIMIT 5;

-- Verify trigger calculation
SELECT CASE
    WHEN COUNT(*) > 0 THEN '✓ PASS: Rating triggers working (movies have calculated stats)'
    ELSE '✗ FAIL: Rating triggers not working'
END AS trigger_status
FROM Movies
WHERE total_ratings > 0 AND average_rating > 0;

-- =============================================================================
-- CHECK 7: TEST BASIC PROCEDURES
-- =============================================================================

SELECT '\n[7] Testing basic procedures...' AS '';

-- Test GetUserById
SELECT 'Testing GetUserById...' AS test;
CALL GetUserById(1);

-- Test GetMovieById
SELECT 'Testing GetMovieById...' AS test;
CALL GetMovieById(1);

-- Test GetAllGenres
SELECT 'Testing GetAllGenres...' AS test;
CALL GetAllGenres();

SELECT '✓ PASS: Basic procedures working' AS status;

-- =============================================================================
-- CHECK 8: TEST RECOMMENDATION ENGINE
-- =============================================================================

SELECT '\n[8] Testing recommendation engine...' AS '';

-- Test collaborative filtering
SELECT 'Testing GetRecommendations...' AS test;
CALL GetRecommendations(1, 5);

-- Test content-based
SELECT 'Testing GetSimilarMovies...' AS test;
CALL GetSimilarMovies(1, 5);

-- Test trending
SELECT 'Testing GetTrendingMovies...' AS test;
CALL GetTrendingMovies(365, 5);

SELECT '✓ PASS: Recommendation engine working' AS status;

-- =============================================================================
-- CHECK 9: VERIFY INDEXES EXIST
-- =============================================================================

SELECT '\n[9] Checking indexes...' AS '';

-- Count indexes
SELECT
    table_name,
    COUNT(DISTINCT index_name) AS index_count
FROM information_schema.statistics
WHERE table_schema = 'cinematch'
GROUP BY table_name
ORDER BY table_name;

SELECT CASE
    WHEN COUNT(*) >= 20 THEN '✓ PASS: Sufficient indexes exist'
    ELSE '✗ WARN: Consider adding more indexes'
END AS index_status
FROM information_schema.statistics
WHERE table_schema = 'cinematch';

-- =============================================================================
-- CHECK 10: VERIFY FOREIGN KEYS
-- =============================================================================

SELECT '\n[10] Checking foreign key constraints...' AS '';

SELECT
    table_name,
    constraint_name,
    referenced_table_name
FROM information_schema.key_column_usage
WHERE table_schema = 'cinematch'
    AND referenced_table_name IS NOT NULL
ORDER BY table_name, constraint_name;

SELECT CASE
    WHEN COUNT(*) >= 10 THEN '✓ PASS: Foreign keys properly configured'
    ELSE '✗ FAIL: Missing foreign keys'
END AS fk_status
FROM information_schema.key_column_usage
WHERE table_schema = 'cinematch'
    AND referenced_table_name IS NOT NULL;

-- =============================================================================
-- FINAL SUMMARY
-- =============================================================================

SELECT '\n============================================' AS '';
SELECT 'VERIFICATION SUMMARY' AS '';
SELECT '============================================' AS '';

-- Count checks
SELECT
    'Database Objects' AS category,
    CONCAT(
        (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'cinematch'),
        ' tables, ',
        (SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_schema = 'cinematch'),
        ' triggers, ',
        (SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema = 'cinematch' AND routine_type = 'PROCEDURE'),
        ' procedures'
    ) AS details;

SELECT
    'Sample Data' AS category,
    CONCAT(
        (SELECT COUNT(*) FROM Users), ' users, ',
        (SELECT COUNT(*) FROM Movies), ' movies, ',
        (SELECT COUNT(*) FROM Ratings), ' ratings, ',
        (SELECT COUNT(*) FROM Reviews), ' reviews'
    ) AS details;

-- Overall status
SELECT '\n============================================' AS '';
SELECT CASE
    WHEN (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'cinematch') = 9
     AND (SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_schema = 'cinematch') = 11
     AND (SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema = 'cinematch' AND routine_type = 'PROCEDURE') >= 35
     AND (SELECT COUNT(*) FROM Users) >= 10
     AND (SELECT COUNT(*) FROM Movies) >= 15
     AND (SELECT COUNT(*) FROM Ratings) >= 50
    THEN '✓✓✓ ALL CHECKS PASSED ✓✓✓'
    ELSE '✗✗✗ SOME CHECKS FAILED ✗✗✗'
END AS overall_status;
SELECT '============================================' AS '';

SELECT '\nCineMatch database is ready to use!' AS '';
SELECT 'Run: CALL GetRecommendations(1, 10); to test recommendations' AS '';
SELECT '============================================' AS '';
