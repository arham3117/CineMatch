-- CineMatch Analytics Queries
-- Data analysis for user behavior, trending movies, and statistics

-- =============================================================================
-- USER BEHAVIOR ANALYSIS
-- =============================================================================

-- Query 1: Most active users (by number of ratings)
SELECT
    u.user_id,
    u.username,
    u.country,
    COUNT(r.rating_id) AS total_ratings,
    AVG(r.rating) AS average_given_rating,
    COUNT(DISTINCT rev.review_id) AS total_reviews,
    MAX(r.rated_at) AS last_rating_date
FROM Users u
LEFT JOIN Ratings r ON u.user_id = r.user_id
LEFT JOIN Reviews rev ON u.user_id = rev.user_id
WHERE u.is_active = TRUE
GROUP BY u.user_id, u.username, u.country
ORDER BY total_ratings DESC
LIMIT 20;

-- Query 2: User rating patterns (harsh vs generous raters)
SELECT
    u.user_id,
    u.username,
    COUNT(r.rating_id) AS total_ratings,
    AVG(r.rating) AS avg_rating,
    MIN(r.rating) AS lowest_rating,
    MAX(r.rating) AS highest_rating,
    STDDEV(r.rating) AS rating_variance,
    CASE
        WHEN AVG(r.rating) >= 4.5 THEN 'Very Generous'
        WHEN AVG(r.rating) >= 4.0 THEN 'Generous'
        WHEN AVG(r.rating) >= 3.5 THEN 'Balanced'
        WHEN AVG(r.rating) >= 3.0 THEN 'Critical'
        ELSE 'Very Critical'
    END AS rater_type
FROM Users u
JOIN Ratings r ON u.user_id = r.user_id
GROUP BY u.user_id, u.username
HAVING total_ratings >= 5
ORDER BY avg_rating DESC;

-- Query 3: User genre preferences
SELECT
    u.user_id,
    u.username,
    g.genre_name,
    COUNT(*) AS movies_rated_in_genre,
    AVG(r.rating) AS avg_rating_for_genre,
    COUNT(*) * AVG(r.rating) AS weighted_preference_score
FROM Users u
JOIN Ratings r ON u.user_id = r.user_id
JOIN MovieGenre mg ON r.movie_id = mg.movie_id
JOIN Genres g ON mg.genre_id = g.genre_id
GROUP BY u.user_id, u.username, g.genre_name
HAVING movies_rated_in_genre >= 2
ORDER BY u.user_id, weighted_preference_score DESC;

-- Query 4: User activity timeline
SELECT
    DATE_FORMAT(rated_at, '%Y-%m') AS month,
    COUNT(DISTINCT user_id) AS active_users,
    COUNT(*) AS total_ratings,
    AVG(rating) AS average_rating
FROM Ratings
GROUP BY month
ORDER BY month DESC;

-- =============================================================================
-- MOVIE PERFORMANCE ANALYSIS
-- =============================================================================

-- Query 5: Top rated movies (minimum ratings threshold)
SELECT
    m.movie_id,
    m.title,
    m.release_date,
    m.average_rating,
    m.total_ratings,
    m.total_reviews,
    GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres,
    (m.average_rating * LOG10(m.total_ratings + 1)) AS weighted_score
FROM Movies m
LEFT JOIN MovieGenre mg ON m.movie_id = mg.movie_id
LEFT JOIN Genres g ON mg.genre_id = g.genre_id
WHERE m.total_ratings >= 5
GROUP BY m.movie_id, m.title, m.release_date, m.average_rating,
         m.total_ratings, m.total_reviews
ORDER BY weighted_score DESC
LIMIT 20;

-- Query 6: Most controversial movies (high variance in ratings)
SELECT
    m.movie_id,
    m.title,
    m.average_rating,
    m.total_ratings,
    STDDEV(r.rating) AS rating_variance,
    MIN(r.rating) AS lowest_rating,
    MAX(r.rating) AS highest_rating,
    (MAX(r.rating) - MIN(r.rating)) AS rating_range
FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title, m.average_rating, m.total_ratings
HAVING m.total_ratings >= 5
ORDER BY rating_variance DESC
LIMIT 20;

-- Query 7: Trending movies (most activity in last 30 days)
SELECT
    m.movie_id,
    m.title,
    m.release_date,
    m.average_rating,
    COUNT(r.rating_id) AS recent_ratings,
    COUNT(DISTINCT r.user_id) AS unique_raters,
    AVG(r.rating) AS recent_average_rating,
    GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres
FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id
    AND r.rated_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
LEFT JOIN MovieGenre mg ON m.movie_id = mg.movie_id
LEFT JOIN Genres g ON mg.genre_id = g.genre_id
GROUP BY m.movie_id, m.title, m.release_date, m.average_rating
HAVING recent_ratings >= 2
ORDER BY recent_ratings DESC, recent_average_rating DESC
LIMIT 20;

-- Query 8: Underrated gems (high ratings but few raters)
SELECT
    m.movie_id,
    m.title,
    m.release_date,
    m.average_rating,
    m.total_ratings,
    GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres
FROM Movies m
LEFT JOIN MovieGenre mg ON m.movie_id = mg.movie_id
LEFT JOIN Genres g ON mg.genre_id = g.genre_id
WHERE m.average_rating >= 4.0
    AND m.total_ratings BETWEEN 3 AND 10
GROUP BY m.movie_id, m.title, m.release_date, m.average_rating, m.total_ratings
ORDER BY m.average_rating DESC, m.total_ratings ASC
LIMIT 20;

-- Query 9: Box office performance vs ratings
SELECT
    m.title,
    m.release_date,
    m.budget,
    m.revenue,
    (m.revenue - m.budget) AS profit,
    ROUND((m.revenue / NULLIF(m.budget, 0)), 2) AS roi_multiplier,
    m.average_rating,
    m.total_ratings,
    CASE
        WHEN m.average_rating >= 4.5 AND (m.revenue / NULLIF(m.budget, 0)) >= 3 THEN 'Critical & Commercial Success'
        WHEN m.average_rating >= 4.5 THEN 'Critical Success'
        WHEN (m.revenue / NULLIF(m.budget, 0)) >= 3 THEN 'Commercial Success'
        ELSE 'Mixed Performance'
    END AS performance_category
FROM Movies m
WHERE m.budget > 0 AND m.revenue > 0
ORDER BY profit DESC;

-- =============================================================================
-- GENRE ANALYSIS
-- =============================================================================

-- Query 10: Genre popularity and ratings
SELECT
    g.genre_name,
    COUNT(DISTINCT mg.movie_id) AS total_movies,
    COUNT(DISTINCT r.rating_id) AS total_ratings,
    AVG(r.rating) AS average_rating,
    AVG(m.total_ratings) AS avg_ratings_per_movie,
    SUM(m.revenue) AS total_genre_revenue
FROM Genres g
LEFT JOIN MovieGenre mg ON g.genre_id = mg.genre_id
LEFT JOIN Movies m ON mg.movie_id = m.movie_id
LEFT JOIN Ratings r ON m.movie_id = r.movie_id
GROUP BY g.genre_id, g.genre_name
ORDER BY total_ratings DESC;

-- Query 11: Genre combinations (what genres work well together)
SELECT
    g1.genre_name AS genre_1,
    g2.genre_name AS genre_2,
    COUNT(DISTINCT m.movie_id) AS movies_count,
    AVG(m.average_rating) AS avg_rating,
    AVG(m.total_ratings) AS avg_num_ratings
FROM MovieGenre mg1
JOIN MovieGenre mg2 ON mg1.movie_id = mg2.movie_id AND mg1.genre_id < mg2.genre_id
JOIN Genres g1 ON mg1.genre_id = g1.genre_id
JOIN Genres g2 ON mg2.genre_id = g2.genre_id
JOIN Movies m ON mg1.movie_id = m.movie_id
GROUP BY g1.genre_name, g2.genre_name
HAVING movies_count >= 2
ORDER BY avg_rating DESC, movies_count DESC;

-- =============================================================================
-- CAST & DIRECTOR ANALYSIS
-- =============================================================================

-- Query 12: Most popular directors (by ratings and reviews)
SELECT
    c.cast_id,
    c.name AS director_name,
    c.country,
    COUNT(DISTINCT mc.movie_id) AS movies_directed,
    AVG(m.average_rating) AS avg_movie_rating,
    SUM(m.total_ratings) AS total_audience_ratings,
    SUM(m.revenue) AS total_box_office
FROM `Cast` c
JOIN MovieCast mc ON c.cast_id = mc.cast_id
JOIN Movies m ON mc.movie_id = m.movie_id
WHERE mc.role_type = 'Director'
GROUP BY c.cast_id, c.name, c.country
HAVING movies_directed >= 2
ORDER BY avg_movie_rating DESC, total_audience_ratings DESC;

-- Query 13: Actor performance analysis
SELECT
    c.cast_id,
    c.name AS actor_name,
    c.country,
    COUNT(DISTINCT mc.movie_id) AS movies_count,
    AVG(m.average_rating) AS avg_movie_rating,
    SUM(m.revenue) AS total_box_office,
    GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres_worked_in
FROM `Cast` c
JOIN MovieCast mc ON c.cast_id = mc.cast_id
JOIN Movies m ON mc.movie_id = m.movie_id
LEFT JOIN MovieGenre mg ON m.movie_id = mg.movie_id
LEFT JOIN Genres g ON mg.genre_id = g.genre_id
WHERE mc.role_type = 'Actor'
GROUP BY c.cast_id, c.name, c.country
HAVING movies_count >= 2
ORDER BY avg_movie_rating DESC;

-- =============================================================================
-- RECOMMENDATION SYSTEM PERFORMANCE
-- =============================================================================

-- Query 14: Recommendation accuracy simulation
-- Shows which users have similar taste to each other
SELECT
    u1.username AS user_1,
    u2.username AS user_2,
    COUNT(DISTINCT r1.movie_id) AS common_movies_rated,
    AVG(ABS(r1.rating - r2.rating)) AS avg_rating_difference,
    (5.0 - AVG(ABS(r1.rating - r2.rating))) AS similarity_score,
    CASE
        WHEN (5.0 - AVG(ABS(r1.rating - r2.rating))) >= 4.0 THEN 'Very Similar'
        WHEN (5.0 - AVG(ABS(r1.rating - r2.rating))) >= 3.5 THEN 'Similar'
        WHEN (5.0 - AVG(ABS(r1.rating - r2.rating))) >= 3.0 THEN 'Somewhat Similar'
        ELSE 'Different'
    END AS similarity_category
FROM Users u1
JOIN Ratings r1 ON u1.user_id = r1.user_id
JOIN Ratings r2 ON r1.movie_id = r2.movie_id
JOIN Users u2 ON r2.user_id = u2.user_id
WHERE u1.user_id < u2.user_id
GROUP BY u1.user_id, u1.username, u2.user_id, u2.username
HAVING common_movies_rated >= 3
ORDER BY similarity_score DESC
LIMIT 30;

-- Query 15: Genre transition patterns (what genres users explore)
SELECT
    g1.genre_name AS from_genre,
    g2.genre_name AS to_genre,
    COUNT(*) AS transition_count,
    AVG(r2.rating) AS avg_rating_after_transition
FROM Ratings r1
JOIN Ratings r2 ON r1.user_id = r2.user_id AND r2.rated_at > r1.rated_at
JOIN MovieGenre mg1 ON r1.movie_id = mg1.movie_id
JOIN MovieGenre mg2 ON r2.movie_id = mg2.movie_id
JOIN Genres g1 ON mg1.genre_id = g1.genre_id
JOIN Genres g2 ON mg2.genre_id = g2.genre_id
WHERE g1.genre_id != g2.genre_id
GROUP BY g1.genre_name, g2.genre_name
HAVING transition_count >= 3
ORDER BY transition_count DESC
LIMIT 20;

-- =============================================================================
-- TIME-BASED ANALYSIS
-- =============================================================================

-- Query 16: Movies by release decade performance
SELECT
    CONCAT(FLOOR(YEAR(release_date) / 10) * 10, 's') AS decade,
    COUNT(*) AS movies_count,
    AVG(average_rating) AS avg_rating,
    AVG(total_ratings) AS avg_num_ratings,
    SUM(revenue) AS total_revenue
FROM Movies
WHERE release_date IS NOT NULL
GROUP BY decade
ORDER BY decade DESC;

-- Query 17: Rating activity by day of week
SELECT
    DAYNAME(rated_at) AS day_of_week,
    COUNT(*) AS total_ratings,
    AVG(rating) AS average_rating,
    COUNT(DISTINCT user_id) AS unique_users
FROM Ratings
GROUP BY day_of_week, DAYOFWEEK(rated_at)
ORDER BY DAYOFWEEK(rated_at);

-- =============================================================================
-- WATCHLIST ANALYSIS
-- =============================================================================

-- Query 18: Most watchlisted movies
SELECT
    m.movie_id,
    m.title,
    m.release_date,
    m.average_rating,
    COUNT(w.user_id) AS total_watchlist_adds,
    SUM(CASE WHEN w.watched = TRUE THEN 1 ELSE 0 END) AS watched_count,
    SUM(CASE WHEN w.watched = FALSE THEN 1 ELSE 0 END) AS pending_count,
    ROUND(SUM(CASE WHEN w.watched = TRUE THEN 1 ELSE 0 END) / COUNT(w.user_id) * 100, 1) AS completion_rate
FROM Movies m
JOIN Watchlist w ON m.movie_id = w.movie_id
GROUP BY m.movie_id, m.title, m.release_date, m.average_rating
ORDER BY total_watchlist_adds DESC;

-- =============================================================================
-- REVIEW ANALYSIS
-- =============================================================================

-- Query 19: Most reviewed movies
SELECT
    m.movie_id,
    m.title,
    m.average_rating,
    m.total_ratings,
    m.total_reviews,
    ROUND((m.total_reviews / NULLIF(m.total_ratings, 0) * 100), 1) AS review_rate_percentage,
    AVG(r.helpful_count) AS avg_helpful_count
FROM Movies m
LEFT JOIN Reviews r ON m.movie_id = r.movie_id
WHERE m.total_reviews > 0
GROUP BY m.movie_id, m.title, m.average_rating, m.total_ratings, m.total_reviews
ORDER BY m.total_reviews DESC;

-- Query 20: Most helpful reviewers
SELECT
    u.user_id,
    u.username,
    COUNT(r.review_id) AS total_reviews,
    SUM(r.helpful_count) AS total_helpful_votes,
    AVG(r.helpful_count) AS avg_helpful_per_review,
    AVG(CHAR_LENGTH(r.review_text)) AS avg_review_length
FROM Users u
JOIN Reviews r ON u.user_id = r.user_id
GROUP BY u.user_id, u.username
HAVING total_reviews >= 2
ORDER BY total_helpful_votes DESC;

-- =============================================================================
-- SUMMARY
-- =============================================================================
-- Total Analytical Queries: 20
-- Categories:
-- - User Behavior: 4 queries
-- - Movie Performance: 5 queries
-- - Genre Analysis: 2 queries
-- - Cast & Director: 2 queries
-- - Recommendation System: 2 queries
-- - Time-Based: 2 queries
-- - Watchlist: 1 query
-- - Reviews: 2 queries
-- =============================================================================
