# Spotify Streaming Analysis (2014–2023)

## Overview  
This project focuses on analyzing 10 years of Spotify streaming data (2014–2023) to uncover insights into streaming patterns, artist performance, and listener behavior. The analysis involved data cleaning, SQL processing, and creating interactive Power BI dashboards for visualization.

---

## Data Preparation  
- **[Spotify Raw Dataset](https://github.com/AreeshaSolangi/AreeshaSolangi/blob/main/Spotify_streaming_analysis/spotify_Raw_dataset.xlsx)**  
  Cleaned and formatted numerical values, applied filters to include only records from 2014–2023.  

- **[SQL Data Processing Script](https://github.com/AreeshaSolangi/AreeshaSolangi/blob/main/Spotify_streaming_analysis/SpotifyUpdated.sql)**  
  Replaced `"not found"` URLs with valid ones by identifying repeated URLs for the same artist using SQL logic.

- **[Updated Dataset](https://github.com/AreeshaSolangi/AreeshaSolangi/blob/main/Spotify_streaming_analysis/spotifyUpdated.csv)**  
  Final dataset after cleaning and URL replacement, ready for dashboard creation.  

- **[SQL Insights Queries](https://github.com/AreeshaSolangi/AreeshaSolangi/blob/main/Spotify_streaming_analysis/Spotify_queries.sql)**  
  Multiple SQL queries were executed to extract key insights related to streaming patterns, artist performance, and track characteristics.

---

## Dashboard  
- **[Power BI Dashboard](https://github.com/AreeshaSolangi/AreeshaSolangi/blob/main/Spotify_streaming_analysis/spotify%20dashboard.pbix)**  
  Interactive dashboard built in Power BI to visualize streaming patterns, artist performance, and listener behavior.

---

## Key Insights  
- Not all artists with a high number of track releases have the highest streams. Having more songs doesn’t always mean higher overall popularity.  
- Many top-performing songs don’t become hits immediately. They often take 2–3 years to reach peak popularity as they gradually gain listeners through playlists and fan engagement.  
- Upbeat, happy, and danceable tracks tend to dominate yearly charts. Listeners are more likely to stream tracks with energetic and positive vibes.  
- Some tracks with similar energy and danceability still didn’t perform as well, likely because of the artist’s popularity, promotion, or how often the track is featured in playlists.

---

## Tools Used  
- **Excel** → Initial filtering and formatting.  
- **MySQL** → Handling missing URLs and running multiple analytical queries.  
- **Power BI** → Dashboard creation and visualization.


