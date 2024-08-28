library(readxl)
library(tidyverse)
###Load the data####
raw_venue<- read_excel('~/Downloads/Venue_Final use.xlsx')
raw_hotels <- read_excel('~/Downloads/hotels_original.xlsx')
raw_enter<- read_excel('~/Downloads/Entertainment_original.xlsx')
raw_rest<- read_excel('~/Downloads/restaurants_original.xlsx')


#processing the different address for venue
process_addresses <- function(address) {
  parts <- str_split(address, ",\\s*")[[1]]
  
  if (length(parts) == 3) {
    list(city = parts[1], state = parts[2], country = parts[3])
  } else if (length(parts) == 2) {
    # Check if the second part is a state abbreviation (US)
    if (str_detect(parts[2], "^[A-Z]{2}$")) {
      list(city = parts[1], state = parts[2], country = "US")
    } else {
      list(city = parts[1], state = NA, country = parts[2])
    }
  } else {
    list(city = NA, state = NA, country = NA)
  }
}
#####Venue cleaning#### 
head(raw_venue)

# Apply the function to each address in the correct column 'Address'
raw_venue <- raw_venue %>%
  mutate(processing = map(Address, process_addresses),
         city = map_chr(processing, "city"),
         state = map_chr(processing, "state"),
         country = map_chr(processing, "country")) %>%
  select(-processing)

venue <- raw_venue %>%select(-Address)
venue<-venue%>%rename(Venue_id = Locn_id)

# change working directory
# setwd('/Users/chenyongting/Desktop/哥大/2024Spring/APAN5310/group project/Normalization')

# read raw data about hotels info
#install.packages('readxl')


raw_hotels

# PK:change the first column name as 'Hotel_id' and add consecutive value as id for each hoetl
library(dplyr)
raw_hotels <- raw_hotels %>%
rename(Hotel_id = names(raw_hotels)[1]) %>%
mutate(Hotel_id = 1:n())
# clean column 'Address'
# remove []
Address_clean <- gsub('[][]','',raw_hotels$Address)
# remove '
Address_clean <- gsub("'",'',Address_clean)
print(Address_clean)
# Replace with the old address
raw_hotels$Address <- Address_clean

# Process with address in USA
# Select rows in USA excep Hotel_id=28
USA1_data <- raw_hotels %>%
filter(Hotel_id %in% c(1:27, 29:30, 91:100))%>%
separate(Address, into = c("address_1", "City", "St", "Country"),
         sep = ",\\s*", extra = "merge", fill = "right") %>%
mutate(Country = "US")%>%
separate(St, into = c("St", "Zip"), sep = " ")
# Select rows in USA and Hotel_id=28
USA2_data <- raw_hotels %>%
filter(Hotel_id %in% c(28))%>%
separate(Address, into = c("address_1", "address_2", "City", "St", "Country"),
         sep = ",\\s*", extra = "merge", fill = "right") %>%
mutate(Country = "US")%>%
separate(St, into = c("St", "Zip"), sep = " ")%>%
mutate(City = "Washington") 
# Combining USA1_data and USA2_data into a single data frame
USA_data <- bind_rows(USA1_data, USA2_data) %>%
mutate(address_2 = if_else(is.na(address_2), NA, address_2))%>%  # Fill missing address_2 with NA
select(Hotel_id, Name, Latitude, Longitude, Rating, Phone, Type, address_1, address_2, City, St, Zip, Country, Near_Venue, Venue_location, url) # Rearrange the columns to move address_2 following address_1

# Process with address in UK
UK_data <- raw_hotels %>%
filter(Hotel_id %in% c(31:40))%>%
separate(Address, into = c("address_1", "City", "Country"),
         sep = ",\\s*", extra = "merge", fill = "right") %>%
mutate(Country = "UK")%>%
separate(City, into = c("City", "Zip"), sep = " ", remove = FALSE, extra = "merge")

# Process with address in Germany 
Germany_data <- raw_hotels %>%
filter(Hotel_id %in% c(41:50))%>%
separate(Address, into = c("address_1", "City", "Country"),
         sep = ",\\s*", extra = "merge", fill = "right")%>%
separate(City, into = c("Zip", "City"), sep = " ", remove = FALSE, extra = "merge")

# Process with address in Republic of Ireland
# Hotel_id = 51,56,57
Ireland1_data <- raw_hotels %>%
filter(Hotel_id %in% c(51,56,57))%>%
separate(Address, into = c("address_1", "Zip", "Country","City"),
         sep = ",\\s*", extra = "merge", fill = "right") %>%
mutate(Country = "Ireland")%>%
mutate(City = "Dublin")
# Hotel_id = 52,53,54,58,59
Ireland2_data <- raw_hotels %>%
filter(Hotel_id %in% c(52,53,54,58,59))%>%
separate(Address, into = c("address_1", "address_2", "Zip", "Country","City"),
         sep = ",\\s*", extra = "merge", fill = "right") %>%
mutate(Country = "Ireland")%>%
mutate(City = "Dublin")
# Hotel_id = 55,60
Ireland3_data <- raw_hotels %>%
filter(Hotel_id %in% c(55,60))%>%
separate(Address, into = c("address_1", "address_2", "City", "Country"),
         sep = ",\\s*", extra = "merge", fill = "right") %>%
mutate(Country = "Ireland")%>%
mutate(City = "Dublin")
#Combining all data frame into a single data frame
Ireland_data <- bind_rows(Ireland1_data, Ireland2_data,Ireland3_data) %>%
mutate(address_2 = if_else(is.na(address_2), NA, address_2))%>%  # Fill missing address_2 with NA
select(Hotel_id, Name, Latitude, Longitude, Rating, Phone, Type, address_1, address_2, City, Zip, Country, Near_Venue, Venue_location, url) # Rearrange the columns to move address_2 following address_1

# Process with address in Sweden
Sweden_data <- raw_hotels %>%
filter(Hotel_id %in% c(61:70))%>%
separate(Address, into = c("address_1", "City", "Country","Zip"),
         sep = ",\\s*", extra = "merge", fill = "right") 
# extract zip
Zip <- str_extract(Sweden_data$City, "^\\S+\\s+\\S+")
# Remove the zip code from the City column
City <- str_replace(Sweden_data$City, "^\\S+\\s+", "")
City <- substring(City, first = 4)
# replace city with correct city name
Sweden_data['City'] = City
Sweden_data['Zip'] = Zip

# Process with address in France
# Hotel_id = 71,72,74,76:80
France1_data <- raw_hotels %>%
filter(Hotel_id %in% c(71,72,74,76:80))%>%
separate(Address, into = c("address_1", "City", "Country"),
         sep = ",\\s*", extra = "merge", fill = "right") %>%
mutate(Country = "France")%>%
separate(City, into = c("Zip", "City"), sep = " ", remove = FALSE, extra = "merge")
# Hotel_id = 73,75
France2_data <- raw_hotels %>%
filter(Hotel_id %in% c(73,75))%>%
separate(Address, into = c("address_1", "address_2", "City", "Country"),
         sep = ",\\s*", extra = "merge", fill = "right") %>%
mutate(Country = "France")%>%
separate(City, into = c("Zip", "City"), sep = " ", remove = FALSE, extra = "merge")
#Combining all data frame into a single data frame
France_data <- bind_rows(France1_data, France2_data) %>%
mutate(address_2 = if_else(is.na(address_2), NA, address_2))%>%  # Fill missing address_2 with NA
select(Hotel_id, Name, Latitude, Longitude, Rating, Phone, Type, address_1, address_2, City, Zip, Country, Near_Venue, Venue_location, url) # Rearrange the columns to move address_2 following address_1

# Process with address in Australia
# Hotel_id = 81,88,90
Australia1_data <- raw_hotels %>%
filter(Hotel_id %in% c(81,88,90))%>%
separate(Address, into = c("address_1", "address_2", "City", "Country"),
         sep = ",\\s*", extra = "merge", fill = "right")%>%
separate(City, into = c("City", "St", "Zip"), sep = " ", remove = FALSE, extra = "merge")
# Hotel_id = 82:87,89
Australia2_data <- raw_hotels %>%
filter(Hotel_id %in% c(82:87,89))%>%
separate(Address, into = c("address_1", "City", "Country"),
         sep = ",\\s*", extra = "merge", fill = "right")%>%
separate(City, into = c("City", "St", "Zip"), sep = " ", remove = FALSE, extra = "merge")
#Combining all data frame into a single data frame
Australia_data <- bind_rows(Australia1_data, Australia2_data) %>%
mutate(address_2 = if_else(is.na(address_2), NA, address_2))%>%  # Fill missing address_2 with NA
select(Hotel_id, Name, Latitude, Longitude, Rating, Phone, Type, address_1, address_2, City,St, Zip, Country, Near_Venue, Venue_location, url) # Rearrange the columns to move address_2 following address_1

#Final cleaned Data frame
Hotel_new <- bind_rows(USA_data, UK_data, Germany_data, Ireland_data, Sweden_data, France_data, Australia_data) %>%
mutate(address_2 = if_else(is.na(address_2), NA, address_2))%>% 
mutate(St = if_else(is.na(St), NA, St))%>% 
select(Hotel_id, Name, Latitude, Longitude, Rating, Phone, Type, address_1, address_2, City, St, Zip, Country, Near_Venue, Venue_location, url) # Rearrange the columns to move address_2 following address_1
Hotel_new <- Hotel_new[order(Hotel_new$Hotel_id), ]
Hotel_new
# Export as CSV file
# write.csv(Hotel_new, file = "/Users/chenyongting/Desktop/哥大/2024Spring/APAN5310/group project/Normalization/Hotel_new.csv", row.names = FALSE)




######hotel type table###########
hotel_type<-data.frame(Hotel_new$Type)%>%distinct()
hotel_type<-bind_cols('hotel_type_id'=1:nrow(hotel_type),'hotel_type'=hotel_type$Hotel_new.Type)


######adding the foreign key###########
Hotel_new<- Hotel_new %>%
left_join(hotel_type, by = c("Type" = "hotel_type"))%>%select(-Type)

## apending the near_venue 
Hotel_new<- Hotel_new %>%
left_join(venue%>%select(Venue,Venue_id), by = c("Near_Venue" = "Venue"))%>%select(-Near_Venue)%>%select(-Venue_location)



######## Restaurant##############

raw_rest <- raw_rest %>%
  rename(Restaurant_id = names(raw_rest)[1]) %>%
  mutate(Restaurant_id = 1:n())
# clean column 'Address'
# remove []
Address_clean <- gsub('[][]','',raw_rest$Address)
# remove '
Address_clean <- gsub("'",'',Address_clean)
print(Address_clean)
# Replace with the old address
raw_rest$Address <- Address_clean

#install.packages('tidyr')
library(tidyr)
# Process with address in USA
# Select rows in USA except Restaurant_id=1:4, 9:10,17,19,95,97
library(tidyverse)
USA1_data <- raw_rest %>%
  filter(Restaurant_id %in% c(1:4, 9:10,17,19,95,97))%>%
  separate(Address, into = c("address_1", "address_2", "City", "St", "Country"),
           sep = ",\\s*", extra = "merge", fill = "right") %>%
  mutate(Country = "US")%>%
  separate(St, into = c("St", "Zip"), sep = " ")
# Select rows in USA and Restaurant_id=5:8,11:16,18,20:30,91:94,96,98:100
USA2_data <- raw_rest %>%
  filter(Restaurant_id %in% c(5:8,11:16,18,20:30,91:94,96,98:100))%>%
  separate(Address, into = c("address_1", "City", "St", "Country"),
           sep = ",\\s*", extra = "merge", fill = "right") %>%
  mutate(Country = "US")%>%
  separate(St, into = c("St", "Zip"), sep = " ")
# Combining USA1_data and USA2_data into a single data frame
USA_data <- bind_rows(USA1_data, USA2_data) %>%
  mutate(address_2 = if_else(is.na(address_2), NA, address_2))%>%  # Fill missing address_2 with NA
  select(Restaurant_id, Name, Latitude, Longitude, Rating, Phone, Type, address_1, address_2, City, St, Zip, Country, Near_Venue, Venue_location, url) # Rearrange the columns to move address_2 following address_1

# Process with address in UK
UK1_data <- raw_rest %>%
  filter(Restaurant_id %in% c(31,33,38,40))%>%
  separate(Address, into = c("address_1","address_2","City", "Country"),
           sep = ",\\s*", extra = "merge", fill = "right") %>%
  mutate(Country = "UK")%>%
  separate(City, into = c("City", "Zip"), sep = " ", remove = FALSE, extra = "merge")
UK2_data <- raw_rest %>%
  filter(Restaurant_id %in% c(32,34:37,39))%>%
  separate(Address, into = c("address_1","City", "Country"),
           sep = ",\\s*", extra = "merge", fill = "right") %>%
  mutate(Country = "UK")%>%
  separate(City, into = c("City", "Zip"), sep = " ", remove = FALSE, extra = "merge")
UK_data <- bind_rows(UK1_data, UK2_data) %>%
  mutate(address_2 = if_else(is.na(address_2), NA, address_2))%>%  # Fill missing address_2 with NA
  select(Restaurant_id, Name, Latitude, Longitude, Rating, Phone, Type, address_1, address_2, City, Zip, Country, Near_Venue, Venue_location, url) # Rearrange the columns to move address_2 following address_1


# Process with address in Germany 
Germany_data <- raw_rest %>%
  filter(Restaurant_id %in% c(41:50))%>%
  separate(Address, into = c("address_1", "City", "Country"),
           sep = ",\\s*", extra = "merge", fill = "right")%>%
  separate(City, into = c("Zip", "City"), sep = " ", remove = FALSE, extra = "merge")

# Process with address in Republic of Ireland
# Restaurant_id = 52,60
Ireland1_data <- raw_rest %>%
  filter(Restaurant_id %in% c(52,60))%>%
  separate(Address, into = c("address_1", "Zip", "Country","City"),
           sep = ",\\s*", extra = "merge", fill = "right") %>%
  mutate(Country = "Ireland")%>%
  mutate(City = "Dublin")
# Restaurant_id = 52,53,54,58,59
Ireland2_data <- raw_rest %>%
  filter(Restaurant_id %in% c(51,53,54:59))%>%
  separate(Address, into = c("address_1", "address_2", "Zip", "Country","City"),
           sep = ",\\s*", extra = "merge", fill = "right") %>%
  mutate(Country = "Ireland")%>%
  mutate(City = "Dublin")
#Combining all data frame into a single data frame
Ireland_data <- bind_rows(Ireland1_data, Ireland2_data) %>%
  mutate(address_2 = if_else(is.na(address_2), NA, address_2))%>%  # Fill missing address_2 with NA
  select(Restaurant_id, Name, Latitude, Longitude, Rating, Phone, Type, address_1, address_2, City, Zip, Country, Near_Venue, Venue_location, url) # Rearrange the columns to move address_2 following address_1

# Process with address in Sweden
Sweden_data <- raw_rest %>%
  filter(Restaurant_id %in% c(61:70))%>%
  separate(Address, into = c("address_1", "City", "Country","Zip"),
           sep = ",\\s*", extra = "merge", fill = "right") 
# extract zip
Zip <- str_extract(Sweden_data$City, "^\\S+\\s+\\S+")
# Remove the zip code from the City column
City <- str_replace(Sweden_data$City, "^\\S+\\s+", "")
City <- substring(City, first = 4)
# replace city with correct city name
Sweden_data['City'] = City
Sweden_data['Zip'] = Zip

# Process with address in France
# Restaurant_id = 71:80
France_data <- raw_rest %>%
  filter(Restaurant_id %in% c(71:80))%>%
  separate(Address, into = c("address_1", "City", "Country"),
           sep = ",\\s*", extra = "merge", fill = "right") %>%
  mutate(Country = "France")%>%
  separate(City, into = c("Zip", "City"), sep = " ", remove = FALSE, extra = "merge")

# Process with address in Australia
# Restaurant_id = 88,90
Australia1_data <- raw_rest %>%
  filter(Restaurant_id %in% c(88,90))%>%
  separate(Address, into = c("address_1", "address_2", "City", "Country"),
           sep = ",\\s*", extra = "merge", fill = "right")%>%
  separate(City, into = c("City", "St", "Zip"), sep = " ", remove = FALSE, extra = "merge")
# Restaurant_id = 81:87,89
Australia2_data <- raw_rest %>%
  filter(Restaurant_id %in% c(81:87,89))%>%
  separate(Address, into = c("address_1", "City", "Country"),
           sep = ",\\s*", extra = "merge", fill = "right")%>%
  separate(City, into = c("City", "St", "Zip"), sep = " ", remove = FALSE, extra = "merge")
#Combining all data frame into a single data frame
Australia_data <- bind_rows(Australia1_data, Australia2_data) %>%
  mutate(address_2 = if_else(is.na(address_2), NA, address_2))%>%  # Fill missing address_2 with NA
  select(Restaurant_id, Name, Latitude, Longitude, Rating, Phone, Type, address_1, address_2, City,St, Zip, Country, Near_Venue, Venue_location, url) # Rearrange the columns to move address_2 following address_1

#Final cleaned Data frame
Restaurant_cleaned <- bind_rows(USA_data, UK_data, Germany_data, Ireland_data, Sweden_data, France_data, Australia_data) %>%
  mutate(address_2 = if_else(is.na(address_2), NA, address_2))%>% 
  mutate(St = if_else(is.na(St), NA, St))%>% 
  select(Restaurant_id, Name, Latitude, Longitude, Rating, Phone, Type, address_1, address_2, City, St, Zip, Country, Near_Venue, Venue_location, url) # Rearrange the columns to move address_2 following address_1
Restaurant_cleaned <- Restaurant_cleaned[order(Restaurant_cleaned$Restaurant_id), ]

#####cusine table#####
cusine<-data.frame(Restaurant_cleaned$Type)%>%distinct()
cusine<-bind_cols('cusine_id'=1:nrow(cusine),'Type'=cusine$Restaurant_cleaned)

######adding the foreign key###########
Restaurant_cleaned<- Restaurant_cleaned %>%
  left_join(cusine, by = c("Type" = "Type"))%>%select(-Type)

## apending the near_venue 
Restaurant_cleaned<- Restaurant_cleaned %>%
  left_join(venue%>%select(Venue,Venue_id), by = c("Near_Venue" = "Venue"))%>%select(-Near_Venue)%>%select(-Venue_location)

################################
#######Entertainment###########
                                       

# PK:change the first column name as 'ent_id' and add consecutive value as id for each Entertainment
library(dplyr)
raw_enter <- raw_enter %>%
  rename(ent_id = names(raw_enter)[1]) %>%
  mutate(ent_id = 1:n())
# clean column 'Address'
# remove []
Address_clean <- gsub('[][]','',raw_enter$Address)
# remove '
Address_clean <- gsub("'",'',Address_clean)
print(Address_clean)
# Replace with the old address
raw_enter$Address <- Address_clean


# Process with address in USA
# Select rows in USA and ent_id=1:15,46:50
USA_data <- raw_enter %>%
  filter(ent_id %in% c(1:15,46:50))%>%
  separate(Address, into = c("address_1", "City", "St", "Country"),
           sep = ",\\s*", extra = "merge", fill = "right") %>%
  mutate(Country = "US")%>%
  separate(St, into = c("St", "Zip"), sep = " ")

# Process with address in UK
UK1_data <- raw_enter %>%
  filter(ent_id %in% c(17,19))%>%
  separate(Address, into = c("address_1","address_2","City", "Country"),
           sep = ",\\s*", extra = "merge", fill = "right") %>%
  mutate(Country = "UK")%>%
  separate(City, into = c("City", "Zip"), sep = " ", remove = FALSE, extra = "merge")
UK2_data <- raw_enter %>%
  filter(ent_id %in% c(16,18,20))%>%
  separate(Address, into = c("address_1","City", "Country"),
           sep = ",\\s*", extra = "merge", fill = "right") %>%
  mutate(Country = "UK")%>%
  separate(City, into = c("City", "Zip"), sep = " ", remove = FALSE, extra = "merge")
UK_data <- bind_rows(UK1_data, UK2_data) %>%
  mutate(address_2 = if_else(is.na(address_2), NA, address_2))%>%  # Fill missing address_2 with NA
  select(ent_id, Name, Latitude, Longitude, Rating, Phone, Type, address_1, address_2, City, Zip, Country, Near_Venue, Venue_Location) # Rearrange the columns to move address_2 following address_1

# Process with address in Germany 
Germany_data <- raw_enter %>%
  filter(ent_id %in% c(21:25))%>%
  separate(Address, into = c("address_1", "City", "Country"),
           sep = ",\\s*", extra = "merge", fill = "right")%>%
  separate(City, into = c("Zip", "City"), sep = " ", remove = FALSE, extra = "merge")

# Process with address in Republic of Ireland
# ent_id = 25,28
Ireland1_data <- raw_enter %>%
  filter(ent_id %in% c(25,28))%>%
  separate(Address, into = c("address_1", "Zip", "Country","City"),
           sep = ",\\s*", extra = "merge", fill = "right") %>%
  mutate(Country = "Ireland")%>%
  mutate(City = "Dublin")
# ent_id = 26,27,29,30
Ireland2_data <- raw_enter %>%
  filter(ent_id %in% c(26,27,29,30))%>%
  separate(Address, into = c("address_1", "address_2", "Zip", "Country","City"),
           sep = ",\\s*", extra = "merge", fill = "right") %>%
  mutate(Country = "Ireland")%>%
  mutate(City = "Dublin")
#Combining all data frame into a single data frame
Ireland_data <- bind_rows(Ireland1_data, Ireland2_data) %>%
  mutate(address_2 = if_else(is.na(address_2), NA, address_2))%>%  # Fill missing address_2 with NA
  select(ent_id, Name, Latitude, Longitude, Rating, Phone, Type, address_1, address_2, City, Zip, Country, Near_Venue, Venue_Location) # Rearrange the columns to move address_2 following address_1

# Process with address in Sweden
Sweden_data <- raw_enter %>%
  filter(ent_id %in% c(31:35))%>%
  separate(Address, into = c("address_1", "City", "Country","Zip"),
           sep = ",\\s*", extra = "merge", fill = "right") 
# extract zip
Zip <- str_extract(Sweden_data$City, "^\\S+\\s+\\S+")
# Remove the zip code from the City column
City <- str_replace(Sweden_data$City, "^\\S+\\s+", "")
City <- substring(City, first = 4)
# replace city with correct city name
Sweden_data['City'] = City
Sweden_data['Zip'] = Zip

# Process with address in France
# ent_id = 36:40
France_data <- raw_enter %>%
  filter(ent_id %in% c(36:40))%>%
  separate(Address, into = c("address_1", "City", "Country"),
           sep = ",\\s*", extra = "merge", fill = "right") %>%
  mutate(Country = "France")%>%
  separate(City, into = c("Zip", "City"), sep = " ", remove = FALSE, extra = "merge")

# Process with address in Australia
# ent_id = 41:45
Australia_data <- raw_enter %>%
  filter(ent_id %in% c(41:45))%>%
  separate(Address, into = c("address_1", "City", "Country"),
           sep = ",\\s*", extra = "merge", fill = "right")%>%
  separate(City, into = c("City", "St", "Zip"), sep = " ", remove = FALSE, extra = "merge")

#Final cleaned Data frame
ent_cleaned <- bind_rows(USA_data, UK_data, Germany_data, Ireland_data, Sweden_data, France_data, Australia_data) %>%
  mutate(address_2 = if_else(is.na(address_2), NA, address_2))%>% 
  mutate(St = if_else(is.na(St), NA, St))%>% 
  select(ent_id, Name, Latitude, Longitude, Rating, Phone, Type, address_1, address_2, City, St, Zip, Country, Near_Venue, Venue_Location) # Rearrange the columns to move address_2 following address_1
ent_cleaned <- ent_cleaned[order(ent_cleaned$ent_id), ]



#####ent_type table#####
Entertainment_type<-data.frame(ent_cleaned$Type)%>%distinct()
Entertainment_type<-bind_cols('Enter_type_id'=1:nrow(Entertainment_type),'Type'=Entertainment_type$ent_cleaned.Type)

######adding the foreign key###########
ent_cleaned<- ent_cleaned %>%
  left_join(Entertainment_type, by = c("Type" = "Type"))%>%select(-Type)

## apending the near_venue 
ent_cleaned<- ent_cleaned %>%
  left_join(venue%>%select(Venue,Venue_id), by = c("Near_Venue" = "Venue"))%>%select(-Near_Venue)%>%select(-Venue_Location)




           

######add loc###########
####Initiating the loc/city table###
loc<-venue%>%select(City = city,St = state,Country = country) %>%distinct()

####update loc info from hotel###
loc<-bind_rows(loc,Hotel_new%>%select(City, St,Country)%>%distinct())
loc<-loc%>%select(City,St,Country)%>%distinct()

####update loc info from restaurant###
loc<-bind_rows(loc,Restaurant_cleaned%>%select(City, St,Country)%>%distinct())
loc<-loc%>%select(City,St,Country)%>%distinct()
####update loc info from ent###
loc<-bind_rows(loc,ent_cleaned%>%select(City, St,Country)%>%distinct())
loc<-loc%>%select(City,St,Country)%>%distinct()


############adding loc_id to loc table#############
loc<-bind_cols('loc_id'=1:nrow(loc),loc)


####update loc info from entertainment###

######final outcome#############
Hotel_new<- Hotel_new %>%
  left_join(loc%>%select(City,loc_id), by = c("City" = "City"))%>%select(-City)%>%
  select(-St)%>%select(-Country)
Hotel_new=Hotel_new%>%select(Hotel_id,Name,hotel_type_id,Venue_id,address_1,address_2,city_id =loc_id, Zip, lat=Latitude,log=Longitude,Rating,Phone)




Restaurant_cleaned<- Restaurant_cleaned %>%
  left_join(loc%>%select(City,loc_id), by = c("City" = "City"))%>%select(-City)%>%
  select(-St)%>%select(-Country)
Restaurant_cleaned=Restaurant_cleaned%>%select(Restaurant_id,Name,cusine_id,Venue_id,address_1,address_2,city_id =loc_id, Zip, lat=Latitude,log=Longitude,Rating,Phone)




ent_cleaned<- ent_cleaned %>%
  left_join(loc%>%select(City,loc_id), by = c("City" = "City"))%>%select(-City)%>%
  select(-St)%>%select(-Country)
ent_cleaned=ent_cleaned%>%select(ent_id,Name,Enter_type_id,Venue_id,address_1,address_2,city_id =loc_id, Zip, lat=Latitude,log=Longitude,Rating,Phone)


