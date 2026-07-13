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
    
    



