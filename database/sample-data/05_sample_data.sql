-- CineMatch Sample Data
-- Realistic test data for demonstration and testing

-- =============================================================================
-- GENRES
-- =============================================================================

INSERT INTO Genres (genre_name, description) VALUES
('Action', 'High-energy films featuring physical stunts, chases, and battles'),
('Comedy', 'Films designed to elicit laughter and amusement'),
('Drama', 'Serious narratives focusing on character development and emotional themes'),
('Horror', 'Films intended to frighten and invoke fear'),
('Science Fiction', 'Futuristic or speculative fiction with scientific elements'),
('Romance', 'Stories centered on romantic relationships'),
('Thriller', 'Suspenseful films with tension and excitement'),
('Fantasy', 'Magical or supernatural elements in fictional worlds'),
('Mystery', 'Films involving investigation and solving puzzles'),
('Animation', 'Films created using animated techniques'),
('Documentary', 'Non-fiction films documenting reality'),
('Adventure', 'Exciting journeys and exploration'),
('Crime', 'Films centered on criminal activities'),
('Biography', 'Films based on real people''s lives'),
('War', 'Films depicting warfare and military conflict');

-- =============================================================================
-- USERS (Sample user accounts)
-- =============================================================================

INSERT INTO Users (username, email, password_hash, first_name, last_name, date_of_birth, country, is_active) VALUES
('moviefan2024', 'john.doe@email.com', '$2y$10$abcdef1234567890', 'John', 'Doe', '1995-03-15', 'USA', TRUE),
('cinephile_sarah', 'sarah.jones@email.com', '$2y$10$abcdef1234567891', 'Sarah', 'Jones', '1988-07-22', 'UK', TRUE),
('filmcritic_mike', 'mike.wilson@email.com', '$2y$10$abcdef1234567892', 'Mike', 'Wilson', '1992-11-08', 'Canada', TRUE),
('emily_loves_movies', 'emily.brown@email.com', '$2y$10$abcdef1234567893', 'Emily', 'Brown', '1998-01-30', 'Australia', TRUE),
('alex_cinema', 'alex.taylor@email.com', '$2y$10$abcdef1234567894', 'Alex', 'Taylor', '1990-05-17', 'USA', TRUE),
('movie_buff_lisa', 'lisa.anderson@email.com', '$2y$10$abcdef1234567895', 'Lisa', 'Anderson', '1985-09-12', 'Germany', TRUE),
('david_reviews', 'david.thomas@email.com', '$2y$10$abcdef1234567896', 'David', 'Thomas', '1993-04-25', 'France', TRUE),
('jessica_films', 'jessica.martin@email.com', '$2y$10$abcdef1234567897', 'Jessica', 'Martin', '1996-12-03', 'Spain', TRUE),
('chris_moviegoer', 'chris.garcia@email.com', '$2y$10$abcdef1234567898', 'Chris', 'Garcia', '1991-08-19', 'Mexico', TRUE),
('amy_cinelover', 'amy.rodriguez@email.com', '$2y$10$abcdef1234567899', 'Amy', 'Rodriguez', '1994-06-28', 'USA', TRUE),
('tom_filmmaker', 'tom.lee@email.com', '$2y$10$abcdef1234567900', 'Tom', 'Lee', '1987-02-14', 'South Korea', TRUE),
('nina_screens', 'nina.kumar@email.com', '$2y$10$abcdef1234567901', 'Nina', 'Kumar', '1999-10-05', 'India', TRUE),
('robert_flicks', 'robert.chen@email.com', '$2y$10$abcdef1234567902', 'Robert', 'Chen', '1989-03-21', 'China', TRUE),
('maria_cinema', 'maria.silva@email.com', '$2y$10$abcdef1234567903', 'Maria', 'Silva', '1997-07-18', 'Brazil', TRUE),
('kevin_movies', 'kevin.white@email.com', '$2y$10$abcdef1234567904', 'Kevin', 'White', '1986-11-30', 'Ireland', TRUE);

-- =============================================================================
-- CAST MEMBERS (Actors, Directors, etc.)
-- =============================================================================

INSERT INTO `Cast` (name, birth_date, country, biography) VALUES
-- Directors
('Christopher Nolan', '1970-07-30', 'UK', 'British-American filmmaker known for complex narratives and visual innovation'),
('Steven Spielberg', '1946-12-18', 'USA', 'Legendary American director and producer'),
('Quentin Tarantino', '1963-03-27', 'USA', 'American filmmaker known for nonlinear storylines and stylized violence'),
('Martin Scorsese', '1942-11-17', 'USA', 'American director known for crime dramas'),
('Greta Gerwig', '1983-08-04', 'USA', 'American actress and filmmaker'),
('Denis Villeneuve', '1967-10-03', 'Canada', 'Canadian filmmaker known for thoughtful sci-fi'),
('Jordan Peele', '1979-02-21', 'USA', 'American filmmaker and comedian'),
('Bong Joon-ho', '1969-09-14', 'South Korea', 'South Korean filmmaker'),

-- Actors
('Leonardo DiCaprio', '1974-11-11', 'USA', 'American actor and environmental activist'),
('Meryl Streep', '1949-06-22', 'USA', 'American actress with record Oscar nominations'),
('Denzel Washington', '1954-12-28', 'USA', 'American actor and filmmaker'),
('Cate Blanchett', '1969-05-14', 'Australia', 'Australian actress and producer'),
('Tom Hanks', '1956-07-09', 'USA', 'American actor and filmmaker'),
('Scarlett Johansson', '1984-11-22', 'USA', 'American actress and singer'),
('Ryan Gosling', '1980-11-12', 'Canada', 'Canadian actor and musician'),
('Margot Robbie', '1990-07-02', 'Australia', 'Australian actress and producer'),
('Timothée Chalamet', '1995-12-27', 'USA', 'American and French actor'),
('Zendaya', '1996-09-01', 'USA', 'American actress and singer'),
('Christian Bale', '1974-01-30', 'UK', 'British actor known for method acting'),
('Amy Adams', '1974-08-20', 'USA', 'American actress'),
('Brad Pitt', '1963-12-18', 'USA', 'American actor and producer'),
('Samuel L. Jackson', '1948-12-21', 'USA', 'American actor'),
('Robert Downey Jr.', '1965-04-04', 'USA', 'American actor'),
('Song Kang-ho', '1967-01-17', 'South Korea', 'South Korean actor');

-- =============================================================================
-- MOVIES
-- =============================================================================

INSERT INTO Movies (title, original_title, release_date, runtime, language, country, budget, revenue, plot_summary, imdb_id, average_rating, total_ratings) VALUES
-- Christopher Nolan films
('Inception', 'Inception', '2010-07-16', 148, 'English', 'USA', 160000000, 829895144, 'A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.', 'tt1375666', 0, 0),
('The Dark Knight', 'The Dark Knight', '2008-07-18', 152, 'English', 'USA', 185000000, 1004558444, 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests.', 'tt0468569', 0, 0),
('Interstellar', 'Interstellar', '2014-11-07', 169, 'English', 'USA', 165000000, 677471339, 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity''s survival.', 'tt0816692', 0, 0),
('Oppenheimer', 'Oppenheimer', '2023-07-21', 180, 'English', 'USA', 100000000, 952000000, 'The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb.', 'tt15398776', 0, 0),

-- Denis Villeneuve films
('Dune', 'Dune', '2021-10-22', 155, 'English', 'USA', 165000000, 400671789, 'Paul Atreides unites with Chani and the Fremen while seeking revenge against those who destroyed his family.', 'tt1160419', 0, 0),
('Arrival', 'Arrival', '2016-11-11', 116, 'English', 'USA', 47000000, 203388186, 'A linguist works with the military to communicate with alien lifeforms after twelve mysterious spacecraft appear around the world.', 'tt2543164', 0, 0),
('Blade Runner 2049', 'Blade Runner 2049', '2017-10-06', 164, 'English', 'USA', 150000000, 267716090, 'Young Blade Runner K discovers a secret that could plunge what is left of society into chaos.', 'tt1856101', 0, 0),

-- Greta Gerwig films
('Barbie', 'Barbie', '2023-07-21', 114, 'English', 'USA', 145000000, 1445638421, 'Barbie and Ken are having the time of their lives in Barbie Land. However, when they get a chance to go to the real world, they discover the joys and perils of living among humans.', 'tt1517268', 0, 0),
('Lady Bird', 'Lady Bird', '2017-11-10', 94, 'English', 'USA', 10000000, 79000000, 'A coming-of-age story about a high school senior''s turbulent relationship with her mother.', 'tt4925292', 0, 0),

-- Bong Joon-ho films
('Parasite', 'Gisaengchung', '2019-05-30', 132, 'Korean', 'South Korea', 11400000, 258817447, 'Greed and class discrimination threaten the newly formed symbiotic relationship between a wealthy family and the destitute Kim clan.', 'tt6751668', 0, 0),

-- Quentin Tarantino films
('Pulp Fiction', 'Pulp Fiction', '1994-10-14', 154, 'English', 'USA', 8000000, 213928762, 'The lives of two mob hitmen, a boxer, a gangster and his wife intertwine in four tales of violence and redemption.', 'tt0110912', 0, 0),
('Django Unchained', 'Django Unchained', '2012-12-25', 165, 'English', 'USA', 100000000, 425368238, 'With the help of a German bounty-hunter, a freed slave sets out to rescue his wife from a brutal plantation owner.', 'tt1853728', 0, 0),

-- Jordan Peele films
('Get Out', 'Get Out', '2017-02-24', 104, 'English', 'USA', 4500000, 255407969, 'A young African-American visits his white girlfriend''s parents for the weekend, where his simmering uneasiness about their reception evolves into a nightmare.', 'tt5052448', 0, 0),
('Nope', 'Nope', '2022-07-22', 130, 'English', 'USA', 68000000, 171207371, 'The residents of a lonely gulch in California bear witness to an uncanny and chilling discovery.', 'tt10954984', 0, 0),

-- Steven Spielberg films
('Schindler''s List', 'Schindler''s List', '1993-12-15', 195, 'English', 'USA', 22000000, 322161245, 'In German-occupied Poland, industrialist Oskar Schindler saves the lives of more than 1,100 Jews during the Holocaust.', 'tt0108052', 0, 0),
('Jurassic Park', 'Jurassic Park', '1993-06-11', 127, 'English', 'USA', 63000000, 1029939903, 'During a preview tour, a theme park suffers a major power breakdown that allows its cloned dinosaur exhibits to run amok.', 'tt0107290', 0, 0),

-- Martin Scorsese films
('The Wolf of Wall Street', 'The Wolf of Wall Street', '2013-12-25', 180, 'English', 'USA', 100000000, 392000694, 'Based on the true story of Jordan Belfort, from his rise to a wealthy stock-broker living the high life to his fall involving crime, corruption and the federal government.', 'tt0993846', 0, 0),
('Killers of the Flower Moon', 'Killers of the Flower Moon', '2023-10-20', 206, 'English', 'USA', 200000000, 156249668, 'When oil is discovered in 1920s Oklahoma under Osage Nation land, the Osage people are murdered one by one—until the FBI steps in to unravel the mystery.', 'tt5537002', 0, 0),

-- Additional popular movies
('The Shawshank Redemption', 'The Shawshank Redemption', '1994-09-23', 142, 'English', 'USA', 25000000, 28341469, 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.', 'tt0111161', 0, 0),
('Forrest Gump', 'Forrest Gump', '1994-07-06', 142, 'English', 'USA', 55000000, 678226465, 'The presidencies of Kennedy and Johnson, the Vietnam War, and other historical events unfold from the perspective of an Alabama man with an IQ of 75.', 'tt0109830', 0, 0),
('The Matrix', 'The Matrix', '1999-03-31', 136, 'English', 'USA', 63000000, 465343787, 'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.', 'tt0133093', 0, 0);

-- =============================================================================
-- MOVIE-GENRE RELATIONSHIPS
-- =============================================================================

-- Inception: Action, Sci-Fi, Thriller
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(1, 1), (1, 5), (1, 7);

-- The Dark Knight: Action, Crime, Drama
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(2, 1), (2, 13), (2, 3);

-- Interstellar: Sci-Fi, Drama, Adventure
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(3, 5), (3, 3), (3, 12);

-- Oppenheimer: Biography, Drama, War
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(4, 14), (4, 3), (4, 15);

-- Dune: Sci-Fi, Adventure, Action
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(5, 5), (5, 12), (5, 1);

-- Arrival: Sci-Fi, Drama, Mystery
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(6, 5), (6, 3), (6, 9);

-- Blade Runner 2049: Sci-Fi, Thriller
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(7, 5), (7, 7);

-- Barbie: Comedy, Fantasy, Adventure
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(8, 2), (8, 8), (8, 12);

-- Lady Bird: Comedy, Drama
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(9, 2), (9, 3);

-- Parasite: Thriller, Drama, Crime
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(10, 7), (10, 3), (10, 13);

-- Pulp Fiction: Crime, Drama
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(11, 13), (11, 3);

-- Django Unchained: Drama, Action
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(12, 3), (12, 1);

-- Get Out: Horror, Thriller, Mystery
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(13, 4), (13, 7), (13, 9);

-- Nope: Horror, Sci-Fi, Mystery
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(14, 4), (14, 5), (14, 9);

-- Schindler's List: Biography, Drama, War
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(15, 14), (15, 3), (15, 15);

-- Jurassic Park: Action, Adventure, Sci-Fi
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(16, 1), (16, 12), (16, 5);

-- The Wolf of Wall Street: Biography, Crime, Drama
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(17, 14), (17, 13), (17, 3);

-- Killers of the Flower Moon: Crime, Drama, Mystery
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(18, 13), (18, 3), (18, 9);

-- The Shawshank Redemption: Drama
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(19, 3);

-- Forrest Gump: Drama, Romance
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(20, 3), (20, 6);

-- The Matrix: Action, Sci-Fi
INSERT INTO MovieGenre (movie_id, genre_id) VALUES
(21, 1), (21, 5);

-- =============================================================================
-- MOVIE-CAST RELATIONSHIPS
-- =============================================================================

-- Inception
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(1, 1, 'Director', NULL, 1),
(1, 9, 'Actor', 'Dom Cobb', 1);

-- The Dark Knight
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(2, 1, 'Director', NULL, 1),
(2, 19, 'Actor', 'Bruce Wayne / Batman', 1);

-- Interstellar
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(3, 1, 'Director', NULL, 1);

-- Oppenheimer
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(4, 1, 'Director', NULL, 1);

-- Dune
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(5, 6, 'Director', NULL, 1),
(5, 17, 'Actor', 'Paul Atreides', 1),
(5, 18, 'Actor', 'Chani', 2);

-- Arrival
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(6, 6, 'Director', NULL, 1),
(6, 20, 'Actor', 'Louise Banks', 1);

-- Blade Runner 2049
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(7, 6, 'Director', NULL, 1),
(7, 15, 'Actor', 'K', 1);

-- Barbie
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(8, 5, 'Director', NULL, 1),
(8, 16, 'Actor', 'Barbie', 1),
(8, 15, 'Actor', 'Ken', 2);

-- Lady Bird
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(9, 5, 'Director', NULL, 1),
(9, 14, 'Actor', 'Marion McPherson', 1);

-- Parasite
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(10, 8, 'Director', NULL, 1),
(10, 24, 'Actor', 'Ki-taek', 1);

-- Pulp Fiction
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(11, 3, 'Director', NULL, 1),
(11, 22, 'Actor', 'Jules Winnfield', 1);

-- Django Unchained
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(12, 3, 'Director', NULL, 1),
(12, 9, 'Actor', 'Calvin Candie', 1);

-- Get Out
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(13, 7, 'Director', NULL, 1);

-- Nope
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(14, 7, 'Director', NULL, 1);

-- Schindler's List
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(15, 2, 'Director', NULL, 1);

-- Jurassic Park
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(16, 2, 'Director', NULL, 1);

-- The Wolf of Wall Street
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(17, 4, 'Director', NULL, 1),
(17, 9, 'Actor', 'Jordan Belfort', 1);

-- Killers of the Flower Moon
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(18, 4, 'Director', NULL, 1),
(18, 9, 'Actor', 'Ernest Burkhart', 1);

-- The Shawshank Redemption
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(19, 13, 'Actor', 'Andy Dufresne', 1);

-- Forrest Gump
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(20, 2, 'Director', NULL, 1),
(20, 13, 'Actor', 'Forrest Gump', 1);

-- The Matrix
INSERT INTO MovieCast (movie_id, cast_id, role_type, character_name, billing_order) VALUES
(21, 19, 'Actor', 'Neo', 1);

-- =============================================================================
-- RATINGS (Sample user ratings - will trigger updates to Movies table)
-- =============================================================================

-- User 1 ratings (sci-fi lover)
INSERT INTO Ratings (user_id, movie_id, rating) VALUES
(1, 1, 5.0),  -- Inception
(1, 3, 5.0),  -- Interstellar
(1, 5, 4.5),  -- Dune
(1, 6, 4.5),  -- Arrival
(1, 7, 4.0),  -- Blade Runner 2049
(1, 21, 5.0), -- The Matrix
(1, 16, 4.0); -- Jurassic Park

-- User 2 ratings (drama lover)
INSERT INTO Ratings (user_id, movie_id, rating) VALUES
(2, 10, 5.0), -- Parasite
(2, 15, 5.0), -- Schindler's List
(2, 19, 5.0), -- Shawshank Redemption
(2, 20, 4.5), -- Forrest Gump
(2, 9, 4.5),  -- Lady Bird
(2, 4, 4.5),  -- Oppenheimer
(2, 18, 4.0); -- Killers of the Flower Moon

-- User 3 ratings (Nolan fan)
INSERT INTO Ratings (user_id, movie_id, rating) VALUES
(3, 1, 5.0),  -- Inception
(3, 2, 5.0),  -- The Dark Knight
(3, 3, 4.5),  -- Interstellar
(3, 4, 4.5),  -- Oppenheimer
(3, 5, 4.0),  -- Dune
(3, 10, 4.5); -- Parasite

-- User 4 ratings (comedy and light films)
INSERT INTO Ratings (user_id, movie_id, rating) VALUES
(4, 8, 5.0),  -- Barbie
(4, 9, 4.5),  -- Lady Bird
(4, 20, 4.5), -- Forrest Gump
(4, 16, 4.0); -- Jurassic Park

-- User 5 ratings (thriller fan)
INSERT INTO Ratings (user_id, movie_id, rating) VALUES
(5, 2, 5.0),  -- The Dark Knight
(5, 10, 5.0), -- Parasite
(5, 13, 4.5), -- Get Out
(5, 11, 4.5), -- Pulp Fiction
(5, 1, 4.0),  -- Inception
(5, 14, 4.0); -- Nope

-- User 6 ratings (varied tastes)
INSERT INTO Ratings (user_id, movie_id, rating) VALUES
(6, 1, 4.5),
(6, 5, 4.5),
(6, 10, 5.0),
(6, 15, 5.0),
(6, 8, 3.5);

-- User 7 ratings
INSERT INTO Ratings (user_id, movie_id, rating) VALUES
(7, 3, 5.0),
(7, 6, 4.5),
(7, 7, 4.5),
(7, 21, 4.0);

-- User 8 ratings
INSERT INTO Ratings (user_id, movie_id, rating) VALUES
(8, 8, 5.0),
(8, 9, 4.5),
(8, 11, 4.0),
(8, 17, 3.5);

-- User 9 ratings
INSERT INTO Ratings (user_id, movie_id, rating) VALUES
(9, 2, 5.0),
(9, 4, 4.5),
(9, 10, 5.0),
(9, 18, 4.5);

-- User 10 ratings
INSERT INTO Ratings (user_id, movie_id, rating) VALUES
(10, 5, 5.0),
(10, 1, 4.5),
(10, 3, 4.5),
(10, 21, 4.0);

-- Additional ratings from users 11-15
INSERT INTO Ratings (user_id, movie_id, rating) VALUES
(11, 1, 4.0), (11, 2, 4.5), (11, 10, 5.0),
(12, 8, 5.0), (12, 9, 4.0), (12, 20, 4.5),
(13, 5, 4.5), (13, 6, 4.0), (13, 7, 4.5),
(14, 13, 4.5), (14, 14, 4.0), (14, 10, 5.0),
(15, 15, 5.0), (15, 19, 5.0), (15, 4, 4.5);

-- =============================================================================
-- REVIEWS (Sample movie reviews)
-- =============================================================================

INSERT INTO Reviews (user_id, movie_id, review_title, review_text, is_spoiler) VALUES
(1, 1, 'Mind-Bending Masterpiece', 'Inception is a stunning achievement in filmmaking. The layered narrative and exceptional visual effects create an unforgettable experience. DiCaprio delivers a powerful performance.', FALSE),
(2, 10, 'A Modern Classic', 'Parasite brilliantly explores class divide with dark humor and shocking twists. The cinematography is gorgeous and every shot is purposeful. Deserved all its awards.', FALSE),
(3, 2, 'Best Superhero Film Ever', 'The Dark Knight transcends the superhero genre. Heath Ledger''s Joker is terrifying and mesmerizing. The action sequences and moral dilemmas elevate this beyond typical comic book fare.', FALSE),
(4, 8, 'Fun and Surprisingly Deep', 'Barbie is much more than expected. It''s visually stunning, hilarious, and actually has something meaningful to say. Margot Robbie and Ryan Gosling are perfect.', FALSE),
(5, 13, 'Terrifying Social Commentary', 'Get Out is a masterclass in suspense. Jordan Peele crafted a horror film that is both genuinely scary and deeply thought-provoking about race in America.', FALSE),
(1, 3, 'Epic Space Journey', 'Interstellar combines stunning visuals with emotional depth. The soundtrack is incredible and the science fiction concepts are fascinating.', FALSE),
(2, 19, 'Timeless Story of Hope', 'The Shawshank Redemption is perfection. Every scene matters, every character is well-developed. A film about hope that never gets old.', FALSE),
(6, 5, 'Visually Stunning Epic', 'Dune brings Herbert''s complex novel to life beautifully. The cinematography is breathtaking and the world-building is exceptional.', FALSE),
(7, 6, 'Thoughtful Sci-Fi', 'Arrival takes a unique approach to alien contact. Amy Adams is phenomenal and the story is both intelligent and emotional.', FALSE),
(8, 9, 'Heartfelt Coming-of-Age Story', 'Lady Bird perfectly captures the complexity of mother-daughter relationships. Greta Gerwig''s directorial debut is authentic and moving.', FALSE);

-- =============================================================================
-- WATCHLIST (Sample watchlists)
-- =============================================================================

INSERT INTO Watchlist (user_id, movie_id, watched) VALUES
-- User 1 wants to watch
(1, 4, FALSE),  -- Oppenheimer
(1, 10, FALSE), -- Parasite
(1, 8, FALSE),  -- Barbie
-- User 1 has watched
(1, 2, TRUE),   -- The Dark Knight
(1, 19, TRUE),  -- Shawshank

-- User 2 wants to watch
(2, 1, FALSE),  -- Inception
(2, 5, FALSE),  -- Dune
(2, 8, FALSE),  -- Barbie

-- User 3 wants to watch
(3, 6, FALSE),  -- Arrival
(3, 7, FALSE),  -- Blade Runner 2049
(3, 8, FALSE),  -- Barbie

-- User 4 wants to watch
(4, 1, FALSE),  -- Inception
(4, 5, FALSE),  -- Dune
(4, 10, FALSE); -- Parasite

-- =============================================================================
-- SUMMARY
-- =============================================================================
-- Users: 15
-- Genres: 15
-- Movies: 21
-- Cast Members: 24
-- Ratings: 73 (from multiple users)
-- Reviews: 10
-- Watchlist Items: 13
-- Movie-Genre Links: 43
-- Movie-Cast Links: 27
-- =============================================================================
