-- CineMatch Recommendation Engine
-- SQL-based recommendation algorithms using collaborative and content-based filtering

DELIMITER $$

-- =============================================================================
-- COLLABORATIVE FILTERING PROCEDURES
-- =============================================================================

-- Find users with similar taste (based on rating patterns)
DROP PROCEDURE IF EXISTS FindSimilarUsers$$
CREATE PROCEDURE FindSimilarUsers(
    IN p_user_id INT,
    IN p_limit INT
)
BEGIN
    -- Find users who rated the same movies similarly
    -- Uses Pearson correlation concept: users who gave similar ratings to the same movies
    SELECT
        r2.user_id AS similar_user_id,
        u.username,
        COUNT(*) AS common_movies,
        AVG(ABS(r1.rating - r2.rating)) AS avg_rating_difference,
        -- Similarity score: lower difference = higher similarity
        (5.0 - AVG(ABS(r1.rating - r2.rating))) AS similarity_score
    FROM Ratings r1
    JOIN Ratings r2 ON r1.movie_id = r2.movie_id
    JOIN Users u ON r2.user_id = u.user_id
    WHERE r1.user_id = p_user_id
        AND r2.user_id != p_user_id
        AND u.is_active = TRUE
    GROUP BY r2.user_id, u.username
    HAVING common_movies >= 3  -- At least 3 common movies
    ORDER BY similarity_score DESC, common_movies DESC
    LIMIT p_limit;
END$$

-- Get recommendations based on similar users (Collaborative Filtering)
DROP PROCEDURE IF EXISTS GetRecommendations$$
CREATE PROCEDURE GetRecommendations(
    IN p_user_id INT,
    IN p_limit INT
)
BEGIN
    -- Step 1: Find similar users
    -- Step 2: Get highly-rated movies from similar users
    -- Step 3: Exclude movies the user has already rated
    -- Step 4: Rank by weighted average rating

    SELECT DISTINCT
        m.movie_id,
        m.title,
        m.release_date,
        m.average_rating,
        m.total_ratings,
        m.poster_url,
        m.plot_summary,
        AVG(r.rating) AS predicted_rating,
        COUNT(DISTINCT r.user_id) AS recommended_by_count,
        GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres
    FROM (
        -- Find similar users (top 10 most similar)
        SELECT
            r2.user_id AS similar_user_id,
            (5.0 - AVG(ABS(r1.rating - r2.rating))) AS similarity_score
        FROM Ratings r1
        JOIN Ratings r2 ON r1.movie_id = r2.movie_id
        WHERE r1.user_id = p_user_id
            AND r2.user_id != p_user_id
        GROUP BY r2.user_id
        HAVING COUNT(*) >= 3
        ORDER BY similarity_score DESC
        LIMIT 10
    ) AS similar_users
    JOIN Ratings r ON r.user_id = similar_users.similar_user_id
    JOIN Movies m ON r.movie_id = m.movie_id
    LEFT JOIN MovieGenre mg ON m.movie_id = mg.movie_id
    LEFT JOIN Genres g ON mg.genre_id = g.genre_id
    WHERE r.rating >= 4.0  -- Only consider highly-rated movies
        AND m.movie_id NOT IN (
            -- Exclude movies already rated by the user
            SELECT movie_id FROM Ratings WHERE user_id = p_user_id
        )
    GROUP BY m.movie_id, m.title, m.release_date, m.average_rating,
             m.total_ratings, m.poster_url, m.plot_summary
    ORDER BY predicted_rating DESC, recommended_by_count DESC, m.average_rating DESC
    LIMIT p_limit;
END$$

-- =============================================================================
-- CONTENT-BASED FILTERING PROCEDURES
-- =============================================================================

-- Get similar movies based on genres and cast (Content-Based Filtering)
DROP PROCEDURE IF EXISTS GetSimilarMovies$$
CREATE PROCEDURE GetSimilarMovies(
    IN p_movie_id INT,
    IN p_limit INT
)
BEGIN
    -- Find movies with similar genres and cast members
    SELECT
        m.movie_id,
        m.title,
        m.release_date,
        m.average_rating,
        m.total_ratings,
        m.poster_url,
        m.plot_summary,
        -- Similarity metrics
        COUNT(DISTINCT mg.genre_id) AS common_genres,
        COUNT(DISTINCT mc.cast_id) AS common_cast,
        -- Weighted similarity score
        (COUNT(DISTINCT mg.genre_id) * 2 + COUNT(DISTINCT mc.cast_id)) AS similarity_score,
        GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres
    FROM Movies m
    -- Find common genres
    LEFT JOIN MovieGenre mg ON m.movie_id = mg.movie_id
        AND mg.genre_id IN (
            SELECT genre_id FROM MovieGenre WHERE movie_id = p_movie_id
        )
    -- Find common cast members
    LEFT JOIN MovieCast mc ON m.movie_id = mc.movie_id
        AND mc.cast_id IN (
            SELECT cast_id FROM MovieCast WHERE movie_id = p_movie_id
        )
    LEFT JOIN MovieGenre mg2 ON m.movie_id = mg2.movie_id
    LEFT JOIN Genres g ON mg2.genre_id = g.genre_id
    WHERE m.movie_id != p_movie_id
        AND (mg.genre_id IS NOT NULL OR mc.cast_id IS NOT NULL)
    GROUP BY m.movie_id, m.title, m.release_date, m.average_rating,
             m.total_ratings, m.poster_url, m.plot_summary
    HAVING similarity_score > 0
    ORDER BY similarity_score DESC, m.average_rating DESC
    LIMIT p_limit;
END$$

-- Get movies by genre preference
DROP PROCEDURE IF EXISTS GetMoviesByGenrePreference$$
CREATE PROCEDURE GetMoviesByGenrePreference(
    IN p_user_id INT,
    IN p_limit INT
)
BEGIN
    -- Find user's favorite genres based on their highest-rated movies
    -- Then recommend top-rated movies from those genres

    SELECT
        m.movie_id,
        m.title,
        m.release_date,
        m.average_rating,
        m.total_ratings,
        m.poster_url,
        m.plot_summary,
        GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres,
        COUNT(DISTINCT fav_genres.genre_id) AS matching_favorite_genres
    FROM (
        -- Find user's favorite genres
        SELECT
            mg.genre_id,
            AVG(r.rating) AS avg_user_rating
        FROM Ratings r
        JOIN MovieGenre mg ON r.movie_id = mg.movie_id
        WHERE r.user_id = p_user_id
        GROUP BY mg.genre_id
        HAVING avg_user_rating >= 4.0
        ORDER BY avg_user_rating DESC
        LIMIT 5
    ) AS fav_genres
    JOIN MovieGenre mg ON fav_genres.genre_id = mg.genre_id
    JOIN Movies m ON mg.movie_id = m.movie_id
    LEFT JOIN MovieGenre mg2 ON m.movie_id = mg2.movie_id
    LEFT JOIN Genres g ON mg2.genre_id = g.genre_id
    WHERE m.average_rating >= 3.5
        AND m.total_ratings >= 5
        AND m.movie_id NOT IN (
            SELECT movie_id FROM Ratings WHERE user_id = p_user_id
        )
    GROUP BY m.movie_id, m.title, m.release_date, m.average_rating,
             m.total_ratings, m.poster_url, m.plot_summary
    ORDER BY matching_favorite_genres DESC, m.average_rating DESC
    LIMIT p_limit;
END$$

-- Hybrid recommendation: Combines collaborative and content-based
DROP PROCEDURE IF EXISTS GetHybridRecommendations$$
CREATE PROCEDURE GetHybridRecommendations(
    IN p_user_id INT,
    IN p_limit INT
)
BEGIN
    -- Combines collaborative filtering with genre preference
    -- Weighted scoring system

    CREATE TEMPORARY TABLE IF NOT EXISTS temp_recommendations (
        movie_id INT PRIMARY KEY,
        title VARCHAR(255),
        release_date DATE,
        average_rating DECIMAL(3,2),
        total_ratings INT,
        poster_url VARCHAR(500),
        plot_summary TEXT,
        collaborative_score DECIMAL(5,2) DEFAULT 0,
        content_score DECIMAL(5,2) DEFAULT 0,
        hybrid_score DECIMAL(5,2) DEFAULT 0,
        genres TEXT
    );

    TRUNCATE TABLE temp_recommendations;

    -- Insert collaborative filtering recommendations
    INSERT INTO temp_recommendations (movie_id, title, release_date, average_rating, total_ratings, poster_url, plot_summary, collaborative_score, genres)
    SELECT
        m.movie_id,
        m.title,
        m.release_date,
        m.average_rating,
        m.total_ratings,
        m.poster_url,
        m.plot_summary,
        AVG(r.rating) AS collaborative_score,
        GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ')
    FROM (
        SELECT r2.user_id AS similar_user_id
        FROM Ratings r1
        JOIN Ratings r2 ON r1.movie_id = r2.movie_id
        WHERE r1.user_id = p_user_id AND r2.user_id != p_user_id
        GROUP BY r2.user_id
        HAVING COUNT(*) >= 3
        ORDER BY (5.0 - AVG(ABS(r1.rating - r2.rating))) DESC
        LIMIT 10
    ) AS similar_users
    JOIN Ratings r ON r.user_id = similar_users.similar_user_id
    JOIN Movies m ON r.movie_id = m.movie_id
    LEFT JOIN MovieGenre mg ON m.movie_id = mg.movie_id
    LEFT JOIN Genres g ON mg.genre_id = g.genre_id
    WHERE r.rating >= 4.0
        AND m.movie_id NOT IN (SELECT movie_id FROM Ratings WHERE user_id = p_user_id)
    GROUP BY m.movie_id, m.title, m.release_date, m.average_rating, m.total_ratings, m.poster_url, m.plot_summary
    ON DUPLICATE KEY UPDATE collaborative_score = VALUES(collaborative_score);

    -- Update with content-based scores
    -- Create temporary table for user's favorite genres (workaround for MySQL 9.3 LIMIT in subquery restriction)
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_user_genres (
        genre_id INT PRIMARY KEY
    );

    TRUNCATE TABLE temp_user_genres;

    INSERT INTO temp_user_genres (genre_id)
    SELECT mg2.genre_id
    FROM Ratings r
    JOIN MovieGenre mg2 ON r.movie_id = mg2.movie_id
    WHERE r.user_id = p_user_id AND r.rating >= 4.0
    GROUP BY mg2.genre_id
    ORDER BY AVG(r.rating) DESC
    LIMIT 5;

    UPDATE temp_recommendations tr
    SET content_score = (
        SELECT COUNT(DISTINCT mg.genre_id) * 2
        FROM MovieGenre mg
        WHERE mg.movie_id = tr.movie_id
            AND mg.genre_id IN (SELECT genre_id FROM temp_user_genres)
    );

    -- Calculate hybrid score (weighted combination)
    UPDATE temp_recommendations
    SET hybrid_score = (collaborative_score * 0.6) + (content_score * 0.4);

    -- Return results
    SELECT * FROM temp_recommendations
    ORDER BY hybrid_score DESC, average_rating DESC
    LIMIT p_limit;

    DROP TEMPORARY TABLE IF EXISTS temp_recommendations;
END$$

-- =============================================================================
-- DISCOVERY & EXPLORATION PROCEDURES
-- =============================================================================

-- Get trending movies (most rated recently)
DROP PROCEDURE IF EXISTS GetTrendingMovies$$
CREATE PROCEDURE GetTrendingMovies(
    IN p_days INT,
    IN p_limit INT
)
BEGIN
    SELECT
        m.movie_id,
        m.title,
        m.release_date,
        m.average_rating,
        m.total_ratings,
        m.poster_url,
        m.plot_summary,
        COUNT(r.rating_id) AS recent_ratings,
        AVG(r.rating) AS recent_average_rating,
        GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres
    FROM Movies m
    JOIN Ratings r ON m.movie_id = r.movie_id
    LEFT JOIN MovieGenre mg ON m.movie_id = mg.movie_id
    LEFT JOIN Genres g ON mg.genre_id = g.genre_id
    WHERE r.rated_at >= DATE_SUB(CURDATE(), INTERVAL p_days DAY)
    GROUP BY m.movie_id, m.title, m.release_date, m.average_rating,
             m.total_ratings, m.poster_url, m.plot_summary
    HAVING recent_ratings >= 3
    ORDER BY recent_ratings DESC, recent_average_rating DESC
    LIMIT p_limit;
END$$

-- Get top rated movies by genre
DROP PROCEDURE IF EXISTS GetTopRatedByGenre$$
CREATE PROCEDURE GetTopRatedByGenre(
    IN p_genre_name VARCHAR(50),
    IN p_limit INT
)
BEGIN
    SELECT
        m.movie_id,
        m.title,
        m.release_date,
        m.average_rating,
        m.total_ratings,
        m.poster_url,
        m.plot_summary
    FROM Movies m
    JOIN MovieGenre mg ON m.movie_id = mg.movie_id
    JOIN Genres g ON mg.genre_id = g.genre_id
    WHERE g.genre_name = p_genre_name
        AND m.total_ratings >= 5
    ORDER BY m.average_rating DESC, m.total_ratings DESC
    LIMIT p_limit;
END$$

-- Search movies by title or plot
DROP PROCEDURE IF EXISTS SearchMovies$$
CREATE PROCEDURE SearchMovies(
    IN p_search_term VARCHAR(255),
    IN p_limit INT
)
BEGIN
    SELECT
        m.movie_id,
        m.title,
        m.release_date,
        m.average_rating,
        m.total_ratings,
        m.poster_url,
        m.plot_summary,
        GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres
    FROM Movies m
    LEFT JOIN MovieGenre mg ON m.movie_id = mg.movie_id
    LEFT JOIN Genres g ON mg.genre_id = g.genre_id
    WHERE m.title LIKE CONCAT('%', p_search_term, '%')
        OR m.plot_summary LIKE CONCAT('%', p_search_term, '%')
    GROUP BY m.movie_id, m.title, m.release_date, m.average_rating,
             m.total_ratings, m.poster_url, m.plot_summary
    ORDER BY m.average_rating DESC
    LIMIT p_limit;
END$$

DELIMITER ;

-- =============================================================================
-- SUMMARY
-- =============================================================================
-- Collaborative Filtering: FindSimilarUsers, GetRecommendations
-- Content-Based Filtering: GetSimilarMovies, GetMoviesByGenrePreference
-- Hybrid: GetHybridRecommendations (combines both approaches)
-- Discovery: GetTrendingMovies, GetTopRatedByGenre, SearchMovies
-- Total: 8 Recommendation Procedures
--
-- Algorithms Used:
-- 1. User-based collaborative filtering (similarity by rating patterns)
-- 2. Content-based filtering (genre and cast matching)
-- 3. Hybrid approach (weighted combination)
-- 4. Trending analysis (recent activity)
-- =============================================================================
