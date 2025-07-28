-- Created a table spotifydataUpdated to store Spotify data with columns for track details, streaming statistics, and cover image URLs.
-- Used BIGINT for streams because the values can exceed the INT range.
CREATE TABLE spotifydataUpdated (
     pk     INT PRIMARY KEY,
    track_name            VARCHAR(255) NOT NULL,
    artist_name           VARCHAR(255) NOT NULL,
    artist_count          INT,
    released_year         YEAR,
    released_month        TINYINT,
    released_day          TINYINT,
    in_spotify_playlists  INT,
    in_spotify_charts     INT,
    streams               BIGINT,
    in_apple_playlists    INT,
    in_apple_charts       INT,
    in_deezer_playlists   INT,
    in_deezer_charts      INT,
    in_shazam_charts      INT,
    bpm                   INT,
    `key`                 VARCHAR(10),
    mode                  VARCHAR(10),
    danceability_pct      INT,
    valence_pct           INT,
    energy_pct            INT,
    acousticness_pct      INT,
    instrumentalness_pct  INT,
    liveness_pct          INT,
    speechiness_pct       INT,
    cover_url             VARCHAR(500)
);
-- IMPORTED SPOTIFY DATA --

SELECT COUNT(*) FROM spotifydataupdated;
-- Enable safe update mode
 SET SQL_SAFE_UPDATE_MODE=1;
 
-- Update cover_url values which are "Not Found" to NULL
UPDATE spotifydataupdated
SET cover_url=null
WHERE cover_url="Not Found";

-- Make sure the number of updated rows is the same as the number of rows with NULL cover_url

SELECT COUNT(*) FROM( SELECT track_name,cover_url FROM spotifydataupdated
 WHERE cover_url is null) AS sub;
 -- -- Identify duplicate cover URLs for artists (for filling missing covers)
 WITH cte AS 
(SELECT artist_name  ,cover_url, count(cover_url) as repeat_cov FROM spotifydataupdated
group by artist_name, cover_url 
HAVING repeat_cov>1
)
SELECT cte.artist_name,cte.cover_url,t2.artist_name,t2.cover_url FROM cte JOIN 
spotifydataupdated as t2
ON cte.artist_name=t2.artist_name AND 
 cte.cover_url IS NOT NULL AND t2.cover_url IS NULL
;
-- Update missing urls with urls repeated more then once 
WITH cte AS 
(SELECT artist_name ,cover_url, count(cover_url) as repeat_cov FROM spotifydataupdated
group by artist_name,cover_url 
HAVING repeat_cov>1
)
update spotifydataupdated as t2 JOIN
cte ON cte.artist_name=t2.artist_name 
SET t2.cover_url= cte.cover_url 
WHERE cte.cover_url IS NOT NULL AND t2.cover_url IS NULL
;
-- lastly see the table 
USE spotify;
SELECT * FROM spotifydataupdated;

 WITH cte AS 
(SELECT artist_name  ,cover_url, count(cover_url) as repeat_cov FROM spotifydataupdated
group by artist_name, cover_url 
HAVING repeat_cov>1
)
SELECT cte.artist_name,cte.cover_url,t2.artist_name,t2.cover_url FROM cte JOIN 
spotifydataupdated as t2
ON cte.artist_name=t2.artist_name AND 
 cte.cover_url IS NOT NULL AND t2.cover_url IS NOT NULL
;
