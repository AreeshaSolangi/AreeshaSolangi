-- Artist & Track Performance
-- Which artists have the highest total streams?
USE spotify;
select artist_name,sum(streams) as streams FROM spotify.spotifydataupdated
GROUP BY artist_name
ORDER BY streams DESC;

-- Which artists have released the most tracks?
SELECT artist_name, count(distinct track_name) as track_count  FROM spotify.spotifydataupdated
GROUP BY artist_name
ORDER BY track_count DESC
;
-- Which individual tracks have the highest streams?
SELECT  track_name,streams as streams FROM spotify.spotifydataupdated
ORDER BY streams DESC
LIMIT 1;

-- Do artists with more tracks always have higher overall streams?
SELECT artist_name,sum(streams) as streams, count( distinct track_name) as count_of_track FROM spotify.spotifydataupdated
GROUP BY artist_name
ORDER BY count_of_track DESC;
-- avg steams per track 
SELECT artist_name, sum(streams)/(count(distinct(track_name))) as avg_streams FROM spotify.spotifydataupdated
GROUP BY artist_name
ORDER BY avg_streams DESC;

-- Release Timing & Patterns
-- How do total streams vary by release year?

alter table spotify.spotifydataupdated
ADD COLUMN released_date date;
SET SQL_SAFE_UPDATES=0;
UPDATE spotify.spotifydataupdated
SET released_date=concat(released_year,"-",released_month,"-",released_day);

UPDATE spotify.spotifydataupdated
SET released_date=str_to_date(released_date,"%Y-%m-%d");

SET SQL_SAFE_UPDATES=0;
SELECT year(released_date) AS years, sum(streams) as streams FROM spotify.spotifydataupdated
GROUP BY years 
ORDER BY years DESC;
-- Which year had the highest average streams per track?
SELECT year(released_date) as years, sum(streams)/count(distinct track_name) as avg_streams FROM spotify.spotifydataupdated
WHERE year(released_date)>2013
GROUP BY years 
ORDER BY avg_streams DESC;

-- Are newer tracks catching up to older tracks in terms of streams?
SELECT year(released_date) as years, sum(streams) streams FROM spotify.spotifydataupdated
WHERE year(released_date)>2013
GROUP BY years 
ORDER BY streams DESC;

-- Playlist & Popularity Impact
-- Do tracks with more Spotify playlist placements get higher streams?
SELECT  track_name , sum(in_apple_playlists) as playlists,sum(streams), 
dense_rank() OVER( ORDER  by SUM(streams) DESC) as streams FROM spotify.spotifydataupdated
GROUP BY track_name 
ORDER BY playlists DESC;

-- How many tracks appear in multiple platforms’ charts (Apple, Deezer, Shazam)?
SELECT COUNT(*) FROM (SELECT track_name,in_shazam_charts,in_apple_charts,in_deezer_charts FROM spotify.spotifydataupdated
WHERE in_shazam_charts>0 AND 
 in_apple_charts>0 AND in_deezer_charts>0
 AND released_year>2013) AS sub;


-- Which platform (Apple, Deezer, Shazam) correlates most with higher streams?
SELECT track_name, in_apple_playlists,in_deezer_playlists,in_spotify_playlists,streams FROM spotify.spotifydataupdated
WHERE released_year>2013
ORDER BY streams DESC;

-- Track Characteristics & Popularity
-- Do high danceability tracks have more streams than low danceability tracks?
SELECT CASE WHEN danceability_pct>50 THEN "High Danceabiity"
               WHEN danceability_pct<=50 THEN "Low danceability" end Danceability_Rate, sum(streams),round(avg(streams),0) FROM spotify.spotifydataupdated
               GROUP BY Danceability_Rate;


-- Is there a relationship between valence (happiness) and streams?
SELECT track_name, valence_pct, streams FROM spotify.spotifydataupdated
ORDER BY streams DESC;

-- Do high-energy songs perform better than low-energy ones?
SELECT CASE WHEN energy_pct>50 THEN "High energy" 
WHEN energy_pct<=50 THEN "low energy" END as energy, sum(streams) as streams, avg(streams) as avg_streams
 FROM spotify.spotifydataupdated
 GROUP BY energy 
 ORDER BY streams DESC;
 
-- Are highly instrumental tracks streamed less or more than vocal-heavy ones?
SELECT CASE WHEN instrumentalness_pct>50 THEN  "instrumental" 
ELSE "Vocal Heavy" END as instrumental, sum(streams) as streams, avg(streams) as avg_streams
 FROM spotify.spotifydataupdated
 GROUP BY instrumental 
 ORDER BY streams DESC;
-- Does speechiness (like rap/spoken word) affect streams?
SELECT CASE WHEN speechiness_pct>50 THEN  "more speechiness" 
ELSE "Less speechiness" END as speechiness, sum(streams) as streams, avg(streams) as avg_streams
 FROM spotify.spotifydataupdated
 GROUP BY speechiness 
 ORDER BY streams DESC;

-- Artist Exposure & Trends
-- Are top tracks concentrated with a few artists or evenly distributed?
SELECT artist_name,count(*) FROM( SELECT artist_name,track_name, streams FROM spotify.spotifydataupdated
WHERE released_year>2013
ORDER BY streams DESC
LIMIT 100) AS sub
GROUP BY artist_name
ORDER by count(*) DESC



;

-- Which artists consistently release high-performing tracks?
WITH cte AS(
SELECT artist_name,avg(streams) as avg_stream_per_artist, 
count(distinct track_name) as tracks FROM spotify.spotifydataupdated
WHERE released_year>2013
GROUP BY artist_name)
SELECT s.artist_name, count(distinct track_name)  as track_count,
sum(streams) as streams FROM cte JOIN spotify.spotifydataupdated as s
ON cte.artist_name= s.artist_name
where s.streams> avg_stream_per_artist
GROUP BY s.artist_name
HAVING count(distinct track_name)>3
ORDER BY track_count DESC

;
 
-- Are songs released in recent years making it to the top streamed tracks faster?
WITH cte AS(
SELECT track_name, streams, released_year FROM spotify.spotifydataupdated
WHERE released_year>2013
ORDER BY streams DESC 
LIMIT 100)
SELECT released_year,count(track_name) as track_count FROM cte
GROUP BY released_year
ORDER BY track_count DESC;
