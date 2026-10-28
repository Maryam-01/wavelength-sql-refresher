-- queries.sql
-- Write your SQL queries here.
-- Run against the wavelength database with:
--   psql -d wavelength -f src/queries.sql



SELECT artists.genre,
SUM(tracks.play_count) AS total_play
FROM artists
JOIN tracks ON artists.artist_id = tracks.artist_id
GROUP BY artists.genre
ORDER BY total_play DESC;


SELECT users.username,
COUNT(listening_events.event_id) AS event_count
FROM users
JOIN listening_events
    ON listening_events.user_id = users.user_id
GROUP BY username
ORDER BY event_count DESC;


SELECT tracks.title,
artists.name,
tracks.play_count
FROM tracks
JOIN artists ON tracks.artist_id = artists.artist_id
WHERE tracks.play_count > (
        SELECT AVG(play_count)
        FROM tracks
);


SELECT tracks.title,
artists.name
FROM tracks
JOIN artists ON tracks.track_id = artists.artist_id
WHERE NOT EXISTS (
        SELECT listening_events.track_id
        FROM listening_events
        WHERE listening_events.track_id = tracks.track_id
)



SELECT users.username,
listening_total
FROM (
        SELECT listening_events.user_id,
        SUM(tracks.duration_secs) AS total_listening_secs
        FROM listening_events
        JOIN tracks
           ON listening_events.track_id = tracks.track_id
        GROUP BY listening_events.user_id
) AS listening_totals
JOIN users
   ON users.user_id = listening_totals.user_id
WHERE listening_totals.total_listening_secs > 1500;









SELECT artists.genre,
SUM(tracks.play_count) AS total_play
FROM artists
JOIN tracks ON artists.artist_id = tracks.artist_id
GROUP BY artists.genre
ORDER BY total_play DESC;

SELECT users.username,
COUNT(listening_events.event_id) AS event_count
FROM users
JOIN listening_events ON listening_events.user_id = users.user_id
GROUP BY users.username
ORDER BY event_count DESC;

SELECT tracks.title,
artists.name,
tracks.play_count
FROM tracks
JOIN artists ON artists.artist_id = tracks.artist_id
WHERE tracks.play_count > (SELECT AVG(tracks.play_count) FROM tracks);

SELECT tracks.title,
artists.name
FROM tracks 
JOIN artists ON artists.artist_id = tracks.artist_id
LEFT JOIN listening_events ON listening_events.track_id = tracks.track_id
WHERE listening_events.event_id IS NULL;


SELECT users.username,
popular_tracks.total_listening_time
FROM (
    SELECT listening_events.user_id,
    SUM(duration_secs) AS total_listening_time
    FROM listening_events
    JOIN tracks ON tracks.track_id = listening_events.track_id
    GROUP BY listening_events.user_id
) popular_tracks
JOIN users ON popular_tracks.user_id = users.user_id
WHERE popular_tracks.total_listening_time > 800;




SELECT tracks.title,
        artists.name,
        top_5_tracks.average_completion_pct
    FROM(
        SELECT listening_events.track_id,
        AVG(listening_events.completion_pct) AS average_completion_pct
        FROM listening_events
        GROUP BY listening_events.track_id
        ORDER BY average_completion_pct DESC LIMIT 5
    ) top_5_tracks
JOIN tracks ON top_5_tracks.track_id = tracks.track_id
JOIN artists ON artists.artist_id = tracks.artist_id;
    
    

WITH  average_plays AS (
    SELECT AVG(play_count) AS average_play_count
    FROM tracks
)
SELECT
  tracks.title,
  artists.name AS artist_name,
  tracks.play_count
FROM tracks
JOIN artists ON tracks.artist_id = artists.artist_id
WHERE tracks.play_count > (SELECT average_play_count FROM average_plays)
ORDER BY tracks.play_count DESC;

-- DISTINCT USER COUNT PER TRACK --
WITH unique_listeners AS (
    SELECT listening_events.track_id,
            COUNT(DISTINCT listening_events.user_id) AS unique_users
    FROM listening_events
    GROUP BY listening_events.track_id
)
SELECT tracks.title, 
        artists.name,
        unique_listeners.unique_users
FROM unique_listeners
JOIN tracks ON unique_listeners.track_id = tracks.track_id
JOIN artists ON artists.artist_id = tracks.artist_id
ORDER BY unique_users DESC LIMIT 5;


SELECT tracks.title,
        artists.name,
        tracks.play_count,
        RANK() OVER (ORDER BY play_count ASC) AS least_popular
FROM tracks
JOIN artists ON artists.artist_id = tracks.artist_id;

SELECT artists.genre,
        tracks.title,
        tracks.play_count,
        RANK() OVER (PARTITION BY artists.genre ORDER BY tracks.play_count) AS ranked_tracks
FROM tracks
JOIN artists ON artists.artist_id = tracks.artist_id;

SELECT listening_events.user_id,
        listening_events.listened_at,
        tracks.title,
        ROW_NUMBER() OVER (PARTITION BY listening_events.user_id ORDER BY listening_events.listened_at ASC) AS rows_number
FROM listening_events
JOIN tracks ON tracks.track_id = listening_events.track_id;



SELECT listening_events.listened_at,
        COUNT(*) OVER (ORDER BY listening_events.listened_at ASC) AS running_total
FROM listening_events 
ORDER BY listening_events.listened_at;


    



