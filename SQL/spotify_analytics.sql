DROP DATABASE IF EXISTS spotify_analytics;

CREATE DATABASE spotify_analytics;

USE spotify_analytics;

SELECT DATABASE();

CREATE TABLE spotify_tracks (
    track_id VARCHAR(100),
    artists TEXT,
    album_name TEXT,
    track_name TEXT,
    popularity INT,
    duration_ms INT,
    explicit BOOLEAN,
    danceability DECIMAL(10,6),
    energy DECIMAL(10,6),
    `key` INT,
    loudness DECIMAL(10,6),
    mode INT,
    speechiness DECIMAL(10,6),
    acousticness DECIMAL(10,6),
    instrumentalness DECIMAL(10,6),
    liveness DECIMAL(10,6),
    valence DECIMAL(10,6),
    tempo DECIMAL(10,6),
    time_signature DECIMAL(10,6),
    track_genre VARCHAR(100),
    popularity_category VARCHAR(20),
    duration_minutes DECIMAL(10,2),
    explicit_label VARCHAR(20)
);

DESCRIBE spotify_tracks;

CREATE TABLE spotify_tracks_staging (
    track_id VARCHAR(100),
    artists TEXT,
    album_name TEXT,
    track_name TEXT,
    popularity VARCHAR(20),
    duration_ms VARCHAR(30),
    explicit VARCHAR(10),
    danceability VARCHAR(30),
    energy VARCHAR(30),
    `key` VARCHAR(20),
    loudness VARCHAR(30),
    mode VARCHAR(20),
    speechiness VARCHAR(30),
    acousticness VARCHAR(30),
    instrumentalness VARCHAR(30),
    liveness VARCHAR(30),
    valence VARCHAR(30),
    tempo VARCHAR(30),
    time_signature VARCHAR(30),
    track_genre VARCHAR(100),
    popularity_category VARCHAR(30),
    duration_minutes VARCHAR(30),
    explicit_label VARCHAR(30)
);

LOAD DATA LOCAL INFILE 'C:/Users/USER/Downloads/spotify_cleaned.csv'
INTO TABLE spotify_tracks_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/USER/Downloads/spotify_cleaned.csv'
INTO TABLE spotify_tracks_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS rows_in_staging
FROM spotify_tracks_staging;

SELECT COUNT(*) AS rows_in_staging
FROM spotify_tracks_staging;

INSERT INTO spotify_tracks (
    track_id,
    artists,
    album_name,
    track_name,
    popularity,
    duration_ms,
    explicit,
    danceability,
    energy,
    `key`,
    loudness,
    mode,
    speechiness,
    acousticness,
    instrumentalness,
    liveness,
    valence,
    tempo,
    time_signature,
    track_genre,
    popularity_category,
    duration_minutes,
    explicit_label
)
SELECT
    track_id,
    artists,
    album_name,
    track_name,
    CAST(popularity AS UNSIGNED),
    CAST(duration_ms AS UNSIGNED),
    CASE
        WHEN LOWER(TRIM(explicit)) = 'true' THEN 1
        ELSE 0
    END,
    CAST(danceability AS DECIMAL(10,6)),
    CAST(energy AS DECIMAL(10,6)),
    CAST(`key` AS UNSIGNED),
    CAST(loudness AS DECIMAL(10,6)),
    CAST(mode AS UNSIGNED),
    CAST(speechiness AS DECIMAL(10,6)),
    CAST(acousticness AS DECIMAL(10,6)),
    CAST(instrumentalness AS DECIMAL(10,6)),
    CAST(liveness AS DECIMAL(10,6)),
    CAST(valence AS DECIMAL(10,6)),
    CAST(tempo AS DECIMAL(10,6)),
    CAST(time_signature AS DECIMAL(10,6)),
    track_genre,
    popularity_category,
    CAST(duration_minutes AS DECIMAL(10,2)),
    explicit_label
FROM spotify_tracks_staging;

SELECT
    track_id,
    popularity,
    duration_ms,
    `key`,
    mode
FROM spotify_tracks_staging
WHERE popularity = '73.0'
   OR duration_ms = '73.0'
   OR `key` = '73.0'
   OR mode = '73.0';
   
   
INSERT INTO spotify_tracks (
    track_id,
    artists,
    album_name,
    track_name,
    popularity,
    duration_ms,
    explicit,
    danceability,
    energy,
    `key`,
    loudness,
    mode,
    speechiness,
    acousticness,
    instrumentalness,
    liveness,
    valence,
    tempo,
    time_signature,
    track_genre,
    popularity_category,
    duration_minutes,
    explicit_label
)
SELECT
    track_id,
    artists,
    album_name,
    track_name,

    CAST(CAST(popularity AS DECIMAL(10,2)) AS UNSIGNED),
    CAST(CAST(duration_ms AS DECIMAL(15,2)) AS UNSIGNED),

    CASE
        WHEN LOWER(TRIM(explicit)) = 'true' THEN 1
        ELSE 0
    END,

    CAST(danceability AS DECIMAL(10,6)),
    CAST(energy AS DECIMAL(10,6)),
    CAST(CAST(`key` AS DECIMAL(10,2)) AS UNSIGNED),
    CAST(loudness AS DECIMAL(10,6)),
    CAST(CAST(mode AS DECIMAL(10,2)) AS UNSIGNED),
    CAST(speechiness AS DECIMAL(10,6)),
    CAST(acousticness AS DECIMAL(10,6)),
    CAST(instrumentalness AS DECIMAL(10,6)),
    CAST(liveness AS DECIMAL(10,6)),
    CAST(valence AS DECIMAL(10,6)),
    CAST(tempo AS DECIMAL(10,6)),
    CAST(time_signature AS DECIMAL(10,6)),
    track_genre,
    popularity_category,
    CAST(duration_minutes AS DECIMAL(10,2)),
    explicit_label

FROM spotify_tracks_staging;

SELECT COUNT(*) AS total_tracks
FROM spotify_tracks;

SELECT
    track_genre,
    COUNT(*) AS track_count,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    MAX(popularity) AS max_popularity
FROM spotify_tracks
GROUP BY track_genre
ORDER BY avg_popularity DESC;

SELECT
    artists,
    COUNT(*) AS track_count,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    MAX(popularity) AS max_popularity
FROM spotify_tracks
GROUP BY artists
HAVING COUNT(*) >= 5
ORDER BY avg_popularity DESC
LIMIT 20;

SELECT
    track_name,
    artists,
    track_genre,
    popularity,
    duration_minutes,
    explicit_label
FROM spotify_tracks
ORDER BY popularity DESC, track_name
LIMIT 20;

SELECT
    explicit_label,
    COUNT(*) AS track_count,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    MAX(popularity) AS max_popularity,
    ROUND(AVG(danceability), 2) AS avg_danceability,
    ROUND(AVG(energy), 2) AS avg_energy
FROM spotify_tracks
GROUP BY explicit_label
ORDER BY avg_popularity DESC;

SELECT
    popularity_category,
    COUNT(*) AS track_count,
    ROUND(AVG(popularity), 2) AS avg_popularity
FROM spotify_tracks
GROUP BY popularity_category
ORDER BY avg_popularity;

SELECT
    track_genre,
    ROUND(AVG(danceability), 2) AS avg_danceability,
    ROUND(AVG(energy), 2) AS avg_energy,
    ROUND(AVG(acousticness), 2) AS avg_acousticness,
    ROUND(AVG(valence), 2) AS avg_valence,
    ROUND(AVG(tempo), 2) AS avg_tempo
FROM spotify_tracks
GROUP BY track_genre
ORDER BY avg_danceability DESC;

SELECT
    ROUND(AVG(popularity), 2) AS avg_popularity,
    ROUND(AVG(danceability), 2) AS avg_danceability,
    ROUND(AVG(energy), 2) AS avg_energy,
    ROUND(AVG(valence), 2) AS avg_valence,
    ROUND(AVG(acousticness), 2) AS avg_acousticness,
    ROUND(AVG(instrumentalness), 2) AS avg_instrumentalness
FROM spotify_tracks
WHERE popularity >= 75;