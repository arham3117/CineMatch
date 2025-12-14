-- CineMatch Movie Recommendation System Database Schema
-- CS-51550 Database Systems Project
-- Created: 2025-11-30

-- Drop existing tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS Watchlist;
DROP TABLE IF EXISTS MovieCast;
DROP TABLE IF EXISTS MovieGenre;
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS Ratings;
DROP TABLE IF EXISTS Cast;
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Genres;
DROP TABLE IF EXISTS Users;

-- =============================================================================
-- CORE ENTITIES
-- =============================================================================

-- Users Table: Store user information and authentication
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE,

    -- Constraints
    CONSTRAINT chk_email_format CHECK (email LIKE '%@%.%'),
    CONSTRAINT chk_username_length CHECK (CHAR_LENGTH(username) >= 3),
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_created_at (created_at)
);

-- Genres Table: Movie genre categories
CREATE TABLE Genres (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,

    INDEX idx_genre_name (genre_name)
);

-- Movies Table: Core movie information and metadata
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    original_title VARCHAR(255),
    release_date DATE,
    runtime INT, -- in minutes
    language VARCHAR(50),
    country VARCHAR(50),
    budget DECIMAL(15, 2),
    revenue DECIMAL(15, 2),
    plot_summary TEXT,
    poster_url VARCHAR(500),
    trailer_url VARCHAR(500),
    imdb_id VARCHAR(20),

    -- Computed/aggregated fields (updated by triggers)
    average_rating DECIMAL(3, 2) DEFAULT 0.00,
    total_ratings INT DEFAULT 0,
    total_reviews INT DEFAULT 0,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT chk_runtime CHECK (runtime > 0),
    CONSTRAINT chk_rating_range CHECK (average_rating >= 0.00 AND average_rating <= 5.00),
    -- Note: release_date validation removed due to MySQL 9.3+ restrictions on CURDATE() in CHECK constraints

    INDEX idx_title (title),
    INDEX idx_release_date (release_date),
    INDEX idx_average_rating (average_rating),
    INDEX idx_language (language),
    FULLTEXT idx_plot_search (title, plot_summary)
);

-- Cast Table: Actors, Directors, and Crew members
CREATE TABLE Cast (
    cast_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    country VARCHAR(50),
    biography TEXT,
    photo_url VARCHAR(500),

    INDEX idx_name (name)
);

-- Ratings Table: User ratings for movies
CREATE TABLE Ratings (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    rating DECIMAL(2, 1) NOT NULL,
    rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT fk_rating_user FOREIGN KEY (user_id)
        REFERENCES Users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_rating_movie FOREIGN KEY (movie_id)
        REFERENCES Movies(movie_id) ON DELETE CASCADE,
    CONSTRAINT chk_rating_value CHECK (rating >= 0.0 AND rating <= 5.0),
    CONSTRAINT unique_user_movie_rating UNIQUE (user_id, movie_id),

    INDEX idx_user_ratings (user_id),
    INDEX idx_movie_ratings (movie_id),
    INDEX idx_rating_value (rating),
    INDEX idx_rated_at (rated_at)
);

-- Reviews Table: User written reviews for movies
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    review_text TEXT NOT NULL,
    review_title VARCHAR(200),
    is_spoiler BOOLEAN DEFAULT FALSE,
    helpful_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT fk_review_user FOREIGN KEY (user_id)
        REFERENCES Users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_review_movie FOREIGN KEY (movie_id)
        REFERENCES Movies(movie_id) ON DELETE CASCADE,
    CONSTRAINT chk_review_length CHECK (CHAR_LENGTH(review_text) >= 10),

    INDEX idx_user_reviews (user_id),
    INDEX idx_movie_reviews (movie_id),
    INDEX idx_created_at (created_at),
    FULLTEXT idx_review_search (review_title, review_text)
);

-- =============================================================================
-- JUNCTION TABLES (Many-to-Many Relationships)
-- =============================================================================

-- MovieGenre: Links movies with their genres
CREATE TABLE MovieGenre (
    movie_id INT NOT NULL,
    genre_id INT NOT NULL,

    PRIMARY KEY (movie_id, genre_id),

    CONSTRAINT fk_mg_movie FOREIGN KEY (movie_id)
        REFERENCES Movies(movie_id) ON DELETE CASCADE,
    CONSTRAINT fk_mg_genre FOREIGN KEY (genre_id)
        REFERENCES Genres(genre_id) ON DELETE CASCADE,

    INDEX idx_genre_movies (genre_id)
);

-- MovieCast: Links movies with cast members (with role information)
CREATE TABLE MovieCast (
    movie_id INT NOT NULL,
    cast_id INT NOT NULL,
    role_type ENUM('Actor', 'Director', 'Producer', 'Writer', 'Composer') NOT NULL,
    character_name VARCHAR(100), -- for actors
    billing_order INT, -- order of appearance in credits

    PRIMARY KEY (movie_id, cast_id, role_type),

    CONSTRAINT fk_mc_movie FOREIGN KEY (movie_id)
        REFERENCES Movies(movie_id) ON DELETE CASCADE,
    CONSTRAINT fk_mc_cast FOREIGN KEY (cast_id)
        REFERENCES `Cast`(cast_id) ON DELETE CASCADE,

    INDEX idx_cast_movies (cast_id),
    INDEX idx_role_type (role_type)
);

-- Watchlist: User saved/bookmarked movies
CREATE TABLE Watchlist (
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    watched BOOLEAN DEFAULT FALSE,
    watched_at TIMESTAMP NULL,

    PRIMARY KEY (user_id, movie_id),

    CONSTRAINT fk_wl_user FOREIGN KEY (user_id)
        REFERENCES Users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_wl_movie FOREIGN KEY (movie_id)
        REFERENCES Movies(movie_id) ON DELETE CASCADE,

    INDEX idx_movie_watchlist (movie_id),
    INDEX idx_added_at (added_at)
);

-- =============================================================================
-- SUMMARY
-- =============================================================================
-- Core Tables: Users, Movies, Genres, Cast, Ratings, Reviews
-- Junction Tables: MovieGenre, MovieCast, Watchlist
-- Total Tables: 9
-- Features: Constraints, Foreign Keys, Indexes, Full-text Search
-- =============================================================================
