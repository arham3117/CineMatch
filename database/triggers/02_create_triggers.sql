-- CineMatch Triggers
-- Automated data updates and integrity maintenance

DELIMITER $$

-- =============================================================================
-- RATING TRIGGERS: Auto-update movie statistics when ratings are added/updated/deleted
-- =============================================================================

-- Trigger: Update movie statistics after INSERT rating
DROP TRIGGER IF EXISTS after_rating_insert$$
CREATE TRIGGER after_rating_insert
AFTER INSERT ON Ratings
FOR EACH ROW
BEGIN
    UPDATE Movies
    SET
        average_rating = (
            SELECT ROUND(AVG(rating), 2)
            FROM Ratings
            WHERE movie_id = NEW.movie_id
        ),
        total_ratings = (
            SELECT COUNT(*)
            FROM Ratings
            WHERE movie_id = NEW.movie_id
        ),
        updated_at = CURRENT_TIMESTAMP
    WHERE movie_id = NEW.movie_id;
END$$

-- Trigger: Update movie statistics after UPDATE rating
DROP TRIGGER IF EXISTS after_rating_update$$
CREATE TRIGGER after_rating_update
AFTER UPDATE ON Ratings
FOR EACH ROW
BEGIN
    UPDATE Movies
    SET
        average_rating = (
            SELECT ROUND(AVG(rating), 2)
            FROM Ratings
            WHERE movie_id = NEW.movie_id
        ),
        updated_at = CURRENT_TIMESTAMP
    WHERE movie_id = NEW.movie_id;
END$$

-- Trigger: Update movie statistics after DELETE rating
DROP TRIGGER IF EXISTS after_rating_delete$$
CREATE TRIGGER after_rating_delete
AFTER DELETE ON Ratings
FOR EACH ROW
BEGIN
    UPDATE Movies
    SET
        average_rating = COALESCE((
            SELECT ROUND(AVG(rating), 2)
            FROM Ratings
            WHERE movie_id = OLD.movie_id
        ), 0.00),
        total_ratings = (
            SELECT COUNT(*)
            FROM Ratings
            WHERE movie_id = OLD.movie_id
        ),
        updated_at = CURRENT_TIMESTAMP
    WHERE movie_id = OLD.movie_id;
END$$

-- =============================================================================
-- REVIEW TRIGGERS: Auto-update review count when reviews are added/deleted
-- =============================================================================

-- Trigger: Update review count after INSERT review
DROP TRIGGER IF EXISTS after_review_insert$$
CREATE TRIGGER after_review_insert
AFTER INSERT ON Reviews
FOR EACH ROW
BEGIN
    UPDATE Movies
    SET
        total_reviews = (
            SELECT COUNT(*)
            FROM Reviews
            WHERE movie_id = NEW.movie_id
        ),
        updated_at = CURRENT_TIMESTAMP
    WHERE movie_id = NEW.movie_id;
END$$

-- Trigger: Update review count after DELETE review
DROP TRIGGER IF EXISTS after_review_delete$$
CREATE TRIGGER after_review_delete
AFTER DELETE ON Reviews
FOR EACH ROW
BEGIN
    UPDATE Movies
    SET
        total_reviews = (
            SELECT COUNT(*)
            FROM Reviews
            WHERE movie_id = OLD.movie_id
        ),
        updated_at = CURRENT_TIMESTAMP
    WHERE movie_id = OLD.movie_id;
END$$

-- =============================================================================
-- WATCHLIST TRIGGERS: Auto-set watched_at timestamp
-- =============================================================================

-- Trigger: Set watched_at timestamp when watched flag is set to TRUE
DROP TRIGGER IF EXISTS before_watchlist_update$$
CREATE TRIGGER before_watchlist_update
BEFORE UPDATE ON Watchlist
FOR EACH ROW
BEGIN
    IF NEW.watched = TRUE AND OLD.watched = FALSE THEN
        SET NEW.watched_at = CURRENT_TIMESTAMP;
    END IF;

    IF NEW.watched = FALSE THEN
        SET NEW.watched_at = NULL;
    END IF;
END$$

-- =============================================================================
-- USER TRIGGERS: Validate and normalize user data
-- =============================================================================

-- Trigger: Normalize email to lowercase before insert
DROP TRIGGER IF EXISTS before_user_insert$$
CREATE TRIGGER before_user_insert
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(NEW.email);
    SET NEW.username = LOWER(NEW.username);
END$$

-- Trigger: Normalize email to lowercase before update
DROP TRIGGER IF EXISTS before_user_update$$
CREATE TRIGGER before_user_update
BEFORE UPDATE ON Users
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(NEW.email);
    SET NEW.username = LOWER(NEW.username);
END$$

-- =============================================================================
-- RATING VALIDATION TRIGGERS: Prevent invalid ratings
-- =============================================================================

-- Trigger: Validate rating before insert
DROP TRIGGER IF EXISTS before_rating_insert$$
CREATE TRIGGER before_rating_insert
BEFORE INSERT ON Ratings
FOR EACH ROW
BEGIN
    -- Round rating to nearest 0.5
    SET NEW.rating = ROUND(NEW.rating * 2) / 2;

    -- Ensure rating is within valid range
    IF NEW.rating < 0.0 THEN
        SET NEW.rating = 0.0;
    ELSEIF NEW.rating > 5.0 THEN
        SET NEW.rating = 5.0;
    END IF;
END$$

-- Trigger: Validate rating before update
DROP TRIGGER IF EXISTS before_rating_update$$
CREATE TRIGGER before_rating_update
BEFORE UPDATE ON Ratings
FOR EACH ROW
BEGIN
    -- Round rating to nearest 0.5
    SET NEW.rating = ROUND(NEW.rating * 2) / 2;

    -- Ensure rating is within valid range
    IF NEW.rating < 0.0 THEN
        SET NEW.rating = 0.0;
    ELSEIF NEW.rating > 5.0 THEN
        SET NEW.rating = 5.0;
    END IF;
END$$

DELIMITER ;

-- =============================================================================
-- SUMMARY
-- =============================================================================
-- Total Triggers: 11
-- Rating Triggers: 5 (3 for stats updates, 2 for validation)
-- Review Triggers: 2
-- Watchlist Triggers: 1
-- User Triggers: 2
-- Purpose: Maintain data integrity, auto-compute statistics, normalize data
-- =============================================================================
