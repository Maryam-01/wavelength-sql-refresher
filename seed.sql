-- seed.sql
-- Drops and recreates the wavelength schema, then inserts all data.
-- Run with: psql -d wavelength -f seed.sql
-- If the database does not exist yet, create it first:
--   psql -c "CREATE DATABASE wavelength;"

-- Drop tables in reverse dependency order
DROP TABLE IF EXISTS listening_events;
DROP TABLE IF EXISTS user_playlist_follows;
DROP TABLE IF EXISTS playlist_tracks;
DROP TABLE IF EXISTS playlists;
DROP TABLE IF EXISTS tracks;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS artists;

-- Create tables in dependency order

CREATE TABLE artists (
  artist_id   SERIAL PRIMARY KEY,
  name        VARCHAR(255) NOT NULL,
  country     VARCHAR(255),
  genre       VARCHAR(255)
);

CREATE TABLE tracks (
  track_id      SERIAL PRIMARY KEY,
  title         VARCHAR(255) NOT NULL,
  artist_id     INTEGER REFERENCES artists(artist_id),
  duration_secs INTEGER,
  release_date  DATE,
  play_count    INTEGER DEFAULT 0
);

CREATE TABLE users (
  user_id   SERIAL PRIMARY KEY,
  username  VARCHAR(255) NOT NULL,
  join_date DATE
);

CREATE TABLE playlists (
  playlist_id  SERIAL PRIMARY KEY,
  title        VARCHAR(255) NOT NULL,
  owner_id     INTEGER REFERENCES users(user_id),
  created_date DATE
);

CREATE TABLE playlist_tracks (
  playlist_id INTEGER REFERENCES playlists(playlist_id),
  track_id    INTEGER REFERENCES tracks(track_id),
  PRIMARY KEY (playlist_id, track_id)
);

CREATE TABLE user_playlist_follows (
  user_id     INTEGER REFERENCES users(user_id),
  playlist_id INTEGER REFERENCES playlists(playlist_id),
  PRIMARY KEY (user_id, playlist_id)
);

CREATE TABLE listening_events (
  event_id       SERIAL PRIMARY KEY,
  user_id        INTEGER REFERENCES users(user_id),
  track_id       INTEGER REFERENCES tracks(track_id),
  listened_at    TIMESTAMPTZ,
  completion_pct INTEGER,
  device_type    VARCHAR(50)
);

-- Seed data

INSERT INTO artists (artist_id, name, country, genre) VALUES
  (1, 'ABBA',     'Sweden',         'Pop'),
  (2, 'Blondie',  'United States',  'New Wave'),
  (3, 'The Cure', 'United Kingdom', 'Post-Punk');

INSERT INTO tracks (track_id, title, artist_id, duration_secs, release_date, play_count) VALUES
  (1,  'Dancing Queen',          1, 232, '1976-08-16', 4821),
  (2,  'Mamma Mia',              1, 213, '1975-08-27', 3902),
  (3,  'The Winner Takes It All',1, 295, '1980-07-21', 5103),
  (4,  'Waterloo',               1, 168, '1974-03-04', 6234),
  (5,  'Heart of Glass',         2, 258, '1979-01-20', 7654),
  (6,  'Call Me',                2, 243, '1980-02-01', 5490),
  (7,  'One Way or Another',     2, 191, '1979-09-01', 9102),
  (8,  'Atomic',                 2, 237, '1980-09-08', 4120),
  (9,  'Lovesong',               3, 201, '1989-08-12', 6721),
  (10, 'Friday I''m in Love',    3, 219, '1992-05-01', 8901),
  (11, 'Close to Me',            3, 213, '1985-09-20', 3301),
  (12, 'Boys Don''t Cry',        3, 156, '1979-06-28', 2890);

INSERT INTO users (user_id, username, join_date) VALUES
  (1, 'nova_ears',    '2022-03-14'),
  (2, 'rhythmbox',    '2021-07-09'),
  (3, 'waveform99',   '2023-01-15'),
  (4, 'deeplistener', '2020-11-22'),
  (5, 'trackjunkie',  '2022-08-03');

INSERT INTO playlists (playlist_id, title, owner_id, created_date) VALUES
  (1, 'Late Night Drift', 1, '2022-04-01'),
  (2, 'Commute Mix',      2, '2021-09-15'),
  (3, 'Sunday Slow',      3, '2023-02-20'),
  (4, 'Focus Zone',       4, '2021-01-10');

INSERT INTO playlist_tracks (playlist_id, track_id) VALUES
  (1, 1), (1, 5), (1, 10), (1, 9),
  (2, 2), (2, 7), (2, 3),  (2, 6),
  (3, 4), (3, 11),(3, 5),  (3, 12),
  (4, 7), (4, 9), (4, 3),  (4, 1), (4, 6);

INSERT INTO user_playlist_follows (user_id, playlist_id) VALUES
  (1, 2), (1, 3), (1, 4),
  (2, 1), (2, 4),
  (3, 1), (3, 2),
  (4, 2), (4, 3),
  (5, 1), (5, 4);

INSERT INTO listening_events (event_id, user_id, track_id, listened_at, completion_pct, device_type) VALUES
  (1,  1, 1,  '2024-11-01 22:14:00+00', 87,  'mobile'),
  (2,  1, 1,  '2024-11-02 23:01:00+00', 100, 'desktop'),
  (3,  2, 2,  '2024-11-03 08:22:00+00', 45,  'mobile'),
  (4,  3, 7,  '2024-11-03 12:05:00+00', 100, 'desktop'),
  (5,  4, 6,  '2024-11-04 09:11:00+00', 73,  'mobile'),
  (6,  1, 3,  '2024-11-04 21:30:00+00', 100, 'desktop'),
  (7,  2, 9,  '2024-11-05 07:45:00+00', 62,  'mobile'),
  (8,  5, 7,  '2024-11-05 14:22:00+00', 100, 'desktop'),
  (9,  3, 4,  '2024-11-05 18:30:00+00', 88,  'tablet'),
  (10, 4, 1,  '2024-11-06 11:00:00+00', 100, 'desktop'),
  (11, 1, 9,  '2024-11-06 22:15:00+00', 55,  'mobile'),
  (12, 2, 5,  '2024-11-07 08:00:00+00', 100, 'mobile'),
  (13, 5, 3,  '2024-11-07 16:45:00+00', 90,  'desktop'),
  (14, 3, 12, '2024-11-08 13:20:00+00', 78,  'tablet'),
  (15, 4, 7,  '2024-11-08 20:00:00+00', 100, 'desktop'),
  (16, 1, 6,  '2024-11-09 23:10:00+00', 100, 'mobile'),
  (17, 2, 10, '2024-11-10 07:30:00+00', 42,  'mobile'),
  (18, 5, 9,  '2024-11-10 12:00:00+00', 100, 'desktop');
