-- CineMatch CRUD Stored Procedures
-- Create, Read, Update, Delete operations for all entities

DELIMITER $$

-- =============================================================================
-- USER PROCEDURES
-- =============================================================================

-- Create new user
DROP PROCEDURE IF EXISTS CreateUser$$
CREATE PROCEDURE CreateUser(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_password_hash VARCHAR(255),
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_date_of_birth DATE,
    IN p_country VARCHAR(50)
)
BEGIN
    INSERT INTO Users (username, email, password_hash, first_name, last_name, date_of_birth, country)
    VALUES (p_username, p_email, p_password_hash, p_first_name, p_last_name, p_date_of_birth, p_country);

    SELECT LAST_INSERT_ID() AS user_id;
END$$

-- Get user by ID
DROP PROCEDURE IF EXISTS GetUserById$$
CREATE PROCEDURE GetUserById(IN p_user_id INT)
BEGIN
    SELECT
        user_id, username, email, first_name, last_name,
        date_of_birth, country, created_at, last_login, is_active
    FROM Users
    WHERE user_id = p_user_id AND is_active = TRUE;
END$$

-- Update user profile
DROP PROCEDURE IF EXISTS UpdateUserProfile$$
CREATE PROCEDURE UpdateUserProfile(
    IN p_user_id INT,
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_country VARCHAR(50)
)
BEGIN
    UPDATE Users
    SET
        first_name = p_first_name,
        last_name = p_last_name,
        country = p_country
    WHERE user_id = p_user_id;
END$$

-- Update last login timestamp
DROP PROCEDURE IF EXISTS UpdateLastLogin$$
CREATE PROCEDURE UpdateLastLogin(IN p_user_id INT)
BEGIN
    UPDATE Users
    SET last_login = CURRENT_TIMESTAMP
    WHERE user_id = p_user_id;
END$$

-- Deactivate user (soft delete)
DROP PROCEDURE IF EXISTS DeactivateUser$$
CREATE PROCEDURE DeactivateUser(IN p_user_id INT)
BEGIN
    UPDATE Users
    SET is_active = FALSE
    WHERE user_id = p_user_id;
END$$

-- =============================================================================
-- MOVIE PROCEDURES
-- =============================================================================

-- Create new movie
DROP PROCEDURE IF EXISTS CreateMovie$$
CREATE PROCEDURE CreateMovie(
    IN p_title VARCHAR(255),
    IN p_original_title VARCHAR(255),
    IN p_release_date DATE,
    IN p_runtime INT,
    IN p_language VARCHAR(50),
    IN p_country VARCHAR(50),
    IN p_budget DECIMAL(15,2),
    IN p_revenue DECIMAL(15,2),
    IN p_plot_summary TEXT,
    IN p_poster_url VARCHAR(500),
    IN p_trailer_url VARCHAR(500),
    IN p_imdb_id VARCHAR(20)
)
BEGIN
    INSERT INTO Movies (
        title, original_title, release_date, runtime, language,
        country, budget, revenue, plot_summary, poster_url,
        trailer_url, imdb_id
    )
    VALUES (
        p_title, p_original_title, p_release_date, p_runtime, p_language,
        p_country, p_budget, p_revenue, p_plot_summary, p_poster_url,
        p_trailer_url, p_imdb_id
    );

    SELECT LAST_INSERT_ID() AS movie_id;
END$$

-- Get movie by ID with full details
DROP PROCEDURE IF EXISTS GetMovieById$$
CREATE PROCEDURE GetMovieById(IN p_movie_id INT)
BEGIN
    SELECT
        m.*,
        GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres
    FROM Movies m
    LEFT JOIN MovieGenre mg ON m.movie_id = mg.movie_id
    LEFT JOIN Genres g ON mg.genre_id = g.genre_id
    WHERE m.movie_id = p_movie_id
    GROUP BY m.movie_id;
END$$

-- Update movie details
DROP PROCEDURE IF EXISTS UpdateMovie$$
CREATE PROCEDURE UpdateMovie(
    IN p_movie_id INT,
    IN p_title VARCHAR(255),
    IN p_plot_summary TEXT,
    IN p_runtime INT,
    IN p_poster_url VARCHAR(500),
    IN p_trailer_url VARCHAR(500)
)
BEGIN
    UPDATE Movies
    SET
        title = p_title,
        plot_summary = p_plot_summary,
        runtime = p_runtime,
        poster_url = p_poster_url,
        trailer_url = p_trailer_url
    WHERE movie_id = p_movie_id;
END$$

-- Delete movie
DROP PROCEDURE IF EXISTS DeleteMovie$$
CREATE PROCEDURE DeleteMovie(IN p_movie_id INT)
BEGIN
    DELETE FROM Movies WHERE movie_id = p_movie_id;
END$$

-- =============================================================================
-- GENRE PROCEDURES
-- =============================================================================

-- Create genre
DROP PROCEDURE IF EXISTS CreateGenre$$
CREATE PROCEDURE CreateGenre(
    IN p_genre_name VARCHAR(50),
    IN p_description TEXT
)
BEGIN
    INSERT INTO Genres (genre_name, description)
    VALUES (p_genre_name, p_description);

    SELECT LAST_INSERT_ID() AS genre_id;
END$$

-- Get all genres
DROP PROCEDURE IF EXISTS GetAllGenres$$
CREATE PROCEDURE GetAllGenres()
BEGIN
    SELECT * FROM Genres ORDER BY genre_name;
END$$

-- =============================================================================
-- RATING PROCEDURES
-- =============================================================================

-- Add or update rating
DROP PROCEDURE IF EXISTS AddOrUpdateRating$$
CREATE PROCEDURE AddOrUpdateRating(
    IN p_user_id INT,
    IN p_movie_id INT,
    IN p_rating DECIMAL(2,1)
)
BEGIN
    -- Check if rating exists
    IF EXISTS (SELECT 1 FROM Ratings WHERE user_id = p_user_id AND movie_id = p_movie_id) THEN
        -- Update existing rating
        UPDATE Ratings
        SET rating = p_rating, rated_at = CURRENT_TIMESTAMP
        WHERE user_id = p_user_id AND movie_id = p_movie_id;
    ELSE
        -- Insert new rating
        INSERT INTO Ratings (user_id, movie_id, rating)
        VALUES (p_user_id, p_movie_id, p_rating);
    END IF;

    -- Return the rating
    SELECT * FROM Ratings
    WHERE user_id = p_user_id AND movie_id = p_movie_id;
END$$

-- Get user's rating for a movie
DROP PROCEDURE IF EXISTS GetUserRating$$
CREATE PROCEDURE GetUserRating(
    IN p_user_id INT,
    IN p_movie_id INT
)
BEGIN
    SELECT * FROM Ratings
    WHERE user_id = p_user_id AND movie_id = p_movie_id;
END$$

-- Delete rating
DROP PROCEDURE IF EXISTS DeleteRating$$
CREATE PROCEDURE DeleteRating(
    IN p_user_id INT,
    IN p_movie_id INT
)
BEGIN
    DELETE FROM Ratings
    WHERE user_id = p_user_id AND movie_id = p_movie_id;
END$$

-- Get all ratings by user
DROP PROCEDURE IF EXISTS GetUserRatings$$
CREATE PROCEDURE GetUserRatings(IN p_user_id INT)
BEGIN
    SELECT
        r.*,
        m.title,
        m.release_date,
        m.poster_url
    FROM Ratings r
    JOIN Movies m ON r.movie_id = m.movie_id
    WHERE r.user_id = p_user_id
    ORDER BY r.rated_at DESC;
END$$

-- =============================================================================
-- REVIEW PROCEDURES
-- =============================================================================

-- Create review
DROP PROCEDURE IF EXISTS CreateReview$$
CREATE PROCEDURE CreateReview(
    IN p_user_id INT,
    IN p_movie_id INT,
    IN p_review_title VARCHAR(200),
    IN p_review_text TEXT,
    IN p_is_spoiler BOOLEAN
)
BEGIN
    INSERT INTO Reviews (user_id, movie_id, review_title, review_text, is_spoiler)
    VALUES (p_user_id, p_movie_id, p_review_title, p_review_text, p_is_spoiler);

    SELECT LAST_INSERT_ID() AS review_id;
END$$

-- Get reviews for a movie
DROP PROCEDURE IF EXISTS GetMovieReviews$$
CREATE PROCEDURE GetMovieReviews(
    IN p_movie_id INT,
    IN p_limit INT
)
BEGIN
    SELECT
        r.*,
        u.username,
        u.first_name,
        u.last_name
    FROM Reviews r
    JOIN Users u ON r.user_id = u.user_id
    WHERE r.movie_id = p_movie_id
    ORDER BY r.helpful_count DESC, r.created_at DESC
    LIMIT p_limit;
END$$

-- Update review
DROP PROCEDURE IF EXISTS UpdateReview$$
CREATE PROCEDURE UpdateReview(
    IN p_review_id INT,
    IN p_review_title VARCHAR(200),
    IN p_review_text TEXT,
    IN p_is_spoiler BOOLEAN
)
BEGIN
    UPDATE Reviews
    SET
        review_title = p_review_title,
        review_text = p_review_text,
        is_spoiler = p_is_spoiler
    WHERE review_id = p_review_id;
END$$

-- Delete review
DROP PROCEDURE IF EXISTS DeleteReview$$
CREATE PROCEDURE DeleteReview(IN p_review_id INT)
BEGIN
    DELETE FROM Reviews WHERE review_id = p_review_id;
END$$

-- =============================================================================
-- WATCHLIST PROCEDURES
-- =============================================================================

-- Add movie to watchlist
DROP PROCEDURE IF EXISTS AddToWatchlist$$
CREATE PROCEDURE AddToWatchlist(
    IN p_user_id INT,
    IN p_movie_id INT
)
BEGIN
    INSERT IGNORE INTO Watchlist (user_id, movie_id)
    VALUES (p_user_id, p_movie_id);
END$$

-- Remove movie from watchlist
DROP PROCEDURE IF EXISTS RemoveFromWatchlist$$
CREATE PROCEDURE RemoveFromWatchlist(
    IN p_user_id INT,
    IN p_movie_id INT
)
BEGIN
    DELETE FROM Watchlist
    WHERE user_id = p_user_id AND movie_id = p_movie_id;
END$$

-- Mark movie as watched
DROP PROCEDURE IF EXISTS MarkAsWatched$$
CREATE PROCEDURE MarkAsWatched(
    IN p_user_id INT,
    IN p_movie_id INT
)
BEGIN
    UPDATE Watchlist
    SET watched = TRUE
    WHERE user_id = p_user_id AND movie_id = p_movie_id;
END$$

-- Get user's watchlist
DROP PROCEDURE IF EXISTS GetUserWatchlist$$
CREATE PROCEDURE GetUserWatchlist(
    IN p_user_id INT,
    IN p_watched_filter VARCHAR(10) -- 'all', 'watched', 'unwatched'
)
BEGIN
    SELECT
        w.*,
        m.title,
        m.release_date,
        m.average_rating,
        m.poster_url,
        m.plot_summary
    FROM Watchlist w
    JOIN Movies m ON w.movie_id = m.movie_id
    WHERE w.user_id = p_user_id
        AND (
            p_watched_filter = 'all'
            OR (p_watched_filter = 'watched' AND w.watched = TRUE)
            OR (p_watched_filter = 'unwatched' AND w.watched = FALSE)
        )
    ORDER BY w.added_at DESC;
END$$

-- =============================================================================
-- CAST PROCEDURES
-- =============================================================================

-- Add cast member
DROP PROCEDURE IF EXISTS AddCastMember$$
CREATE PROCEDURE AddCastMember(
    IN p_name VARCHAR(100),
    IN p_birth_date DATE,
    IN p_country VARCHAR(50),
    IN p_biography TEXT,
    IN p_photo_url VARCHAR(500)
)
BEGIN
    INSERT INTO `Cast` (name, birth_date, country, biography, photo_url)
    VALUES (p_name, p_birth_date, p_country, p_biography, p_photo_url);

    SELECT LAST_INSERT_ID() AS cast_id;
END$$

-- Link cast member to movie
DROP PROCEDURE IF EXISTS AddMovieCast$$
CREATE PROCEDURE AddMovieCast(
    IN p_movie_id INT,
    IN p_cast_id INT,
    IN p_role_type VARCHAR(20),
    IN p_character_name VARCHAR(100),
    IN p_billing_order INT
)
BEGIN
    INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order)
    VALUES (p_movie_id, p_cast_id, p_role_type, p_character_name, p_billing_order);
END$$

-- Get cast for a movie
DROP PROCEDURE IF EXISTS GetMovieCast$$
CREATE PROCEDURE GetMovieCast(IN p_movie_id INT)
BEGIN
    SELECT
        c.*,
        mc.role_type,
        mc.character_name,
        mc.billing_order
    FROM MovieCast mc
    JOIN `Cast` c ON mc.cast_id = c.cast_id
    WHERE mc.movie_id = p_movie_id
    ORDER BY mc.billing_order;
END$$

-- Link movie to genre
DROP PROCEDURE IF EXISTS AddMovieGenre$$
CREATE PROCEDURE AddMovieGenre(
    IN p_movie_id INT,
    IN p_genre_id INT
)
BEGIN
    INSERT IGNORE INTO MovieGenre (movie_id, genre_id)
    VALUES (p_movie_id, p_genre_id);
END$$

DELIMITER ;

-- =============================================================================
-- SUMMARY
-- =============================================================================
-- User Procedures: 5 (Create, Get, Update, UpdateLogin, Deactivate)
-- Movie Procedures: 4 (Create, Get, Update, Delete)
-- Genre Procedures: 2 (Create, GetAll)
-- Rating Procedures: 4 (AddOrUpdate, Get, Delete, GetUserRatings)
-- Review Procedures: 4 (Create, GetMovie, Update, Delete)
-- Watchlist Procedures: 4 (Add, Remove, MarkWatched, GetList)
-- Cast Procedures: 4 (Add, Link, GetMovieCast, AddMovieGenre)
-- Total: 27 CRUD Procedures
-- =============================================================================
