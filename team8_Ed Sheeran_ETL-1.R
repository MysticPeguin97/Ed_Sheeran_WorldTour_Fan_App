library(tidyverse)
library(RPostgres)

# CREATE DB----
# _connect to proj24a_team8 database----
con<-dbConnect(
  drv = dbDriver('Postgres'),
  dbname = 'xxxxxxxxxx',
  host = 'db-postgresql-nyc1-44203-do-user-8018943-0.b.db.ondigitalocean.com',
  port = 25061,
  user = 'proj8',
  password = 'xxxxxxxxxxxxx'
)

# drop the tables if needed
dbExecute(con, 'DROP TABLE IF EXISTS concert_dates; ')
dbExecute(con, 'DROP TABLE IF EXISTS songs; ')
dbExecute(con, 'DROP TABLE IF EXISTS albums; ')
dbExecute(con, 'DROP TABLE IF EXISTS tickets; ')
dbExecute(con, 'DROP TABLE IF EXISTS entertainments; ')
dbExecute(con, 'DROP TABLE IF EXISTS entertainment_types; ') 
dbExecute(con, 'DROP TABLE IF EXISTS restaurants; ')  
dbExecute(con, 'DROP TABLE IF EXISTS cusines; ')  
dbExecute(con, 'DROP TABLE IF EXISTS hotels; ') 
dbExecute(con, 'DROP TABLE IF EXISTS hotel_types; ')  
dbExecute(con, 'DROP TABLE IF EXISTS venues; ')  
dbExecute(con, 'DROP TABLE IF EXISTS locs; ') 

# _create locs table----
stmt <- 'CREATE TABLE locs (
          loc_id int NOT NULL,
          city varchar(50) NOT NULL,
          st varchar(50),
          country varchar(50),
          PRIMARY KEY(loc_id)
        );'
dbExecute(con, stmt)  

# _create venues table----
stmt <- 'CREATE TABLE venues (
          venue_id int NOT NULL,
          venue varchar(50) NOT NULL,
          loc_id int NOT NULL,
          lat NUMERIC(20, 15),
          lng NUMERIC(20, 15),
          PRIMARY KEY(venue_id),
          FOREIGN KEY(loc_id) REFERENCES locs
        );'
dbExecute(con, stmt)  

# _create hotel_types table----
stmt <- 'CREATE TABLE hotel_types (
          hotel_type_id int NOT NULL,
          hotel_type varchar(250) NOT NULL,
          PRIMARY KEY(hotel_type_id)
        );'
dbExecute(con, stmt)  

# _create hotels table----
stmt <- 'CREATE TABLE hotels (
          hotel_id INT NOT NULL,
          name VARCHAR(250) NOT NULL,
          venue_id INT NOT NULL,
          hotel_type_id INT NOT NULL,
          address_1 VARCHAR (250) NOT NULL,
          address_2 VARCHAR (250),
          city_id INT NOT NULL,
          zip VARCHAR (50),
          lat NUMERIC(20, 15),
          lng NUMERIC(20, 15),
          rating NUMERIC(3, 2),
          phone VARCHAR(50),
          url VARCHAR(1000),
          PRIMARY KEY(hotel_id),
          FOREIGN KEY(venue_id) REFERENCES venues,
          FOREIGN KEY(hotel_type_id) REFERENCES hotel_types,
          FOREIGN KEY(city_id) REFERENCES locs(loc_id)
        );'
dbExecute(con, stmt)  

# _create cusines table----
stmt <- 'CREATE TABLE cusines (
          cusine_id int NOT NULL,
          type varchar(250) NOT NULL,
          PRIMARY KEY(cusine_id)
        );'
dbExecute(con, stmt)  

# _create restaurants table----
stmt <- 'CREATE TABLE restaurants (
          restaurant_id INT NOT NULL,
          name VARCHAR(250) NOT NULL,
          cusine_id INT NOT NULL,
          venue_id INT NOT NULL,
          address_1 VARCHAR (250) NOT NULL,
          address_2 VARCHAR (250),
          city_id INT NOT NULL,
          zip VARCHAR (50),
          lat NUMERIC(20, 15),
          lng NUMERIC(20, 15),
          rating NUMERIC(3, 2),
          phone VARCHAR(50),
          url VARCHAR(1000),
          PRIMARY KEY(restaurant_id),
          FOREIGN KEY(venue_id) REFERENCES venues,
          FOREIGN KEY(cusine_id) REFERENCES cusines,
          FOREIGN KEY(city_id) REFERENCES locs(loc_id)
        );'
dbExecute(con, stmt)  

# _create entertainment_types table----
stmt <- 'CREATE TABLE Entertainment_types (
          entert_type_id int NOT NULL,
          entert_Type varchar(250) NOT NULL,
          PRIMARY KEY(entert_type_id)
        );'
dbExecute(con, stmt)  

# _create entertainments table----
stmt <- 'CREATE TABLE entertainments (
          ent_id INT NOT NULL,
          name VARCHAR(250) NOT NULL,
          entert_type_id INT NOT NULL,
          venue_id INT NOT NULL,
          address_1 VARCHAR (250) NOT NULL,
          address_2 VARCHAR (250),
          city_id INT NOT NULL,
          zip VARCHAR (50),
          lat NUMERIC(20, 15),
          lng NUMERIC(20, 15),
          rating NUMERIC(3, 2),
          phone VARCHAR(50),
          PRIMARY KEY(ent_id),
          FOREIGN KEY(venue_id) REFERENCES venues,
          FOREIGN KEY(entert_type_id) REFERENCES entertainment_types,
          FOREIGN KEY(city_id) REFERENCES locs(loc_id)
        );'
dbExecute(con, stmt)  

# _create tickets table----
stmt <- 'CREATE TABLE tickets (
          venue_id int NOT NULL,
          ticket_type varchar(250) NOT NULL,
          ticket_price int NOT NULL,
          PRIMARY KEY(venue_id,ticket_type),
          FOREIGN KEY(venue_id) REFERENCES venues
        );'
dbExecute(con, stmt)  

# _create albums table----
stmt <- 'CREATE TABLE albums (
          album_id int NOT NULL,
          album varchar(50) NOT NULL,
          release_date date NOT NULL,
          PRIMARY KEY(album_id)
        );'
dbExecute(con, stmt)

# _create songs table----
stmt <- 'CREATE TABLE songs (
          song_id varchar(20) NOT NULL,
          song_name varchar(250) NOT NULL,
          song_mood varchar(250) NOT NULL,
          album_id int NOT NULL,
          lyrics varchar(500),
          PRIMARY KEY(song_id),
          FOREIGN KEY(album_id) REFERENCES albums
        );'
dbExecute(con, stmt)

# _create concert_dates table----
stmt <- 'CREATE TABLE concert_dates (
          venue_id int NOT NULL,
          concert_date date NOT NULL,
          PRIMARY KEY(venue_id),
          FOREIGN KEY(venue_id) REFERENCES venues
        );'
dbExecute(con, stmt)


# ****************************----
# EXTRACT----
# change working directory
setwd('C:/Users/Wuwx/Downloads')

# _read source data----
library(readxl)
df_loc = read_excel('Normalization.xlsx', sheet = 'loc', skip = 2, col_names = T)
df_venue = read_excel('Normalization.xlsx', sheet = 'Venue', skip = 3, col_names = T)
df_hotel_type = read_excel('Normalization.xlsx', sheet = 'hotel', skip = 109, col_names = T)
df_hotel = read_excel('Normalization.xlsx', sheet = 'hotel', range = 'A6:M106', col_names = T)
df_cusine = read_excel('Normalization.xlsx', sheet = 'Restaurant', skip = 111, col_names = T)
df_restaurant = read_excel('Normalization.xlsx', sheet = 'Restaurant', range = 'A6:M106', col_names = T)
df_entertainment_type = read_excel('Normalization.xlsx', sheet = 'Entertainment', skip = 59, col_names = T)
df_entertainment = read_excel('Normalization.xlsx', sheet = 'Entertainment', range = 'A6:L56', col_names = T)
df_ticket = read_excel('Normalization.xlsx', sheet = 'ticket', skip = 3, col_names = T)
df_song = read_excel('Normalization.xlsx', sheet = 'Songs & Album', range = 'A4:E96', col_names = T)
df_album = read_excel('Normalization.xlsx', sheet = 'Songs & Album', range = 'G4:I11', col_names = T)
df_concert_date = read_excel('Normalization.xlsx', sheet = 'Concert Date', skip = 3, col_names = T)

# ****************************----
# TRANSFORM----
# delete '.0' in the zip column from df_hotel, df_resraurant, df_entertainment
df_hotel$zip <- gsub("\\.0$", "", df_hotel$zip)
df_restaurant$zip <- gsub("\\.0$", "", df_restaurant$zip)
df_entertainment$zip <- gsub("\\.0$", "", df_entertainment$zip)

# ****************************----
# LOAD----
# _load locs table----
# change the column names
library(dplyr)
dfl = df_loc %>% 
  select(loc_id, city = City, st = St, country = Country)

# dfl: loc_id primary key
dbWriteTable(
  conn = con,
  name = 'locs',
  value = dfl,
  row.names = FALSE,
  append = TRUE
)


# _load venues table----
# change the column names
dfv = df_venue %>% 
  select(venue_id = Venue_id, venue = Venue, loc_id, lat, lng)

# dfv: venue_id primary key, loc_id foreign key
dbWriteTable(
  conn = con,
  name = 'venues',
  value = dfv,
  row.names = FALSE,
  append = TRUE
)


# _load hotel_types table----
# change the column names
dfht = df_hotel_type %>% 
  select(hotel_type_id = Hotel_type_id, hotel_type = Hotel_type)

# dfht: hotel_type_id primary key
dbWriteTable(
  conn = con,
  name = 'hotel_types',
  value = dfht,
  row.names = FALSE,
  append = TRUE
)


# _load hotels table----
# change the column names
dfh = df_hotel %>% 
  select(hotel_id = Hotel_id, name = Name, venue_id = Venue_id,
         hotel_type_id = Hotel_type_id,
         address_1, address_2, city_id = City_id, zip, lat, lng,
         rating = Rating, phone = Phone, url)

# dfh: hotel_id primary key, venue_id, hotel_type_id and city_id foreign key
dbWriteTable(
  conn = con,
  name = 'hotels',
  value = dfh,
  row.names = FALSE,
  append = TRUE
)


# _load cusines table----
# change the column names
dfc = df_cusine %>%
  select(cusine_id, type = Type)

# dfc: cusine_id primary key
dbWriteTable(
  conn = con,
  name = 'cusines',
  value = dfc,
  row.names = FALSE,
  append = TRUE
)

# _load restaurants table----
# change the column names
dfr = df_restaurant %>%
  select(restaurant_id = Restaurant_id, name = Name, cusine_id, venue_id = Venue_id,
         address_1, address_2, city_id = City_id, zip, lat, lng,
         rating = Rating, phone = Phone, url)

# dfr: restaurant_id primary key, venue_id, cusine_id and city_id foreign key
dbWriteTable(
  conn = con,
  name = 'restaurants',
  value = dfr,
  row.names = FALSE,
  append = TRUE
)

# _load entertainment_types table----
# change column names
dfet = df_entertainment_type %>% 
  select(entert_type_id = Entert_type_id,	entert_type = Entert_Type)

# dfet: entert_type_id primary key
dbWriteTable(
  conn = con,
  name = 'entertainment_types',
  value = dfet,
  row.names = FALSE,
  append = TRUE
)


# _load entertainments table----
# change the column names
dfe = df_entertainment %>%
  select(ent_id, name = Name, entert_type_id = Entert_type_id, venue_id = Venue_id,
         address_1, address_2, city_id = City_id, zip, lat, lng,
         rating = Rating, phone = Phone)

# dfe: ent_id primary key, venue_id, entert_type_id and city_id foreign key
dbWriteTable(
  conn = con,
  name = 'entertainments',
  value = dfe,
  row.names = FALSE,
  append = TRUE
)

# _load tickets table----
dft = df_ticket 

# dfr: venue_id and ticket_type primary key, venue_id foreign key
dbWriteTable(
  conn = con,
  name = 'tickets',
  value = dft,
  row.names = FALSE,
  append = TRUE
)



# _load albums table----
dfa = df_album

# dfa: album_id primary key
dbWriteTable(
  conn = con,
  name = 'albums',
  value = dfa,
  row.names = FALSE,
  append = TRUE
)

# _load songs table----
# change the column names
dfs = df_song %>%
  select(song_id = Song_id, song_name, song_mood, album_id, lyrics)

# dfs: song_id primary key, album_id foreign key
dbWriteTable(
  conn = con,
  name = 'songs',
  value = dfs,
  row.names = FALSE,
  append = TRUE
)

# _load concert_dates table----
# change the column names
dfcd = df_concert_date %>%
  select(venue_id = Venue_id, concert_date)

# dfcd: venue_id primary key, venue_id foreign key
dbWriteTable(
  conn = con,
  name = 'concert_dates',
  value = dfcd,
  row.names = FALSE,
  append = TRUE
)



# ****************************----
