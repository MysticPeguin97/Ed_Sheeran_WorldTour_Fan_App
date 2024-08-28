### Ed Sheeran World Tour Fan App 

🔗App Demo: https://vivianry.shinyapps.io/Ed_Sheeran_World_Tour_Fan_APP/

📊 Presentation: [Fan App  Presentation.pptx](https://github.com/user-attachments/files/16776834/Fan.App.Presentation.pptx)

#### Project Overview:
In this project, we created a fan app for a globally famous artist, Ed Sheeran, in anticipation of his hypothetical world tour, the Integral Tour. We specifically chose Ed Sheeran and developed the app using R Shiny to offer essential information for fans attending his concerts at different stadiums worldwide. The app is designed to elevate the concert experience by providing comprehensive details about amenities near each stadium, such as restaurants, hotels, and local attractions.

#### Business Use Case:
This project models the creation of a user-focused application designed to boost fan engagement and tackle logistical issues at large-scale concerts. The app showcases how technology can enhance the fan experience by providing personalized services and opens up opportunities through collaborations with local businesses, hotels, and restaurants.

By centering on a globally recognized artist like Ed Sheeran, we examined how this platform could benefit both fans and businesses in the events, hospitality, and entertainment industries, creating possibilities for sponsorships, advertising, and additional revenue streams.

![alt text](https://github.com/user-attachments/assets/231273d4-a00b-4d4e-936e-dabf9025e558)
(Tour Poster, *Courtesy of Wenqing Huang and Wenxuan Wu*)

#### Key Features:
- **Concert Information:** This app offers fans comprehensive concert details for a global tour by a singer like Ed Sheeran, including tour locations, venue information, dates, and links to ticket purchase pages.
  
- **Nearby Amenities:** The app offers a curated list of nearby restaurants, hotels, and local attractions for each stadium. Through the interactive map, users can make restaurant reservations, book hotels, and find directions to nearby entertainment spots, enabling fans to easily plan their visit with access to dining, accommodation, and entertainment options close to the concert venue.
  
- **Artist Information:** Users can explore information about the artist in the app, primarily featuring details about his past albums, popular songs, and more. We also introduced a unique feature called the Recommender, which suggests songs based on the user’s current mood, such as sadness, happiness, or nostalgia. These features are designed to appeal not only to loyal fans but also to give new listeners a chance to discover the artist’s work.

- **User-Friendly Interface:** This app offers great convenience for potential audiences interested in exploring Ed Sheeran's world tour. Through detailed information collection and features like the interactive map, we provide users with a one-stop service that includes viewing concert details, purchasing tickets, booking accommodations, and exploring restaurants and entertainment facilities near the concert venues.

#### Technology Stack:
- **R Shiny:** For building the interactive web application.
- **HTML and CSS:** Used in conjunction with R Shiny to enhance the design and user experience.
- **PostgreSQL Database:** The data scraped from Yelp was stored in an SQL database to efficiently manage and query information related to the concerts, stadiums, and nearby amenities.
- **Data Sources:** The data on restaurants, hotels, and attractions were scraped from Yelp using APIs.

#### Database Schema
![alt text](https://github.com/user-attachments/assets/371ec637-78f3-44a5-a305-30f4d1c09b4e)

#### My Contribution and Reflection:
In this project, I was primarily responsible for designing the UI interface and creating front-end pages for concert information and nearby amenities. After gaining a thorough understanding of the data backend and the relationships between the tables, I efficiently used SQL queries to retrieve the necessary information and developed the front-end web pages and user interface using R Shiny, HTML, and CSS. For instance, I utilized queries to fetch details like the latitude, longitude, address, and ratings of various restaurants near the venue from the database to create an interactive map. Users can click on any restaurant on the map to view information such as the address, rating, and cuisine type.

This project provided me with a comprehensive and in-depth experience of the entire end 2 end process, from the data side to the customer-facing application side. It included data capture and collection, cleaning, normalization, database construction, querying, and using data to create front-end visualizations.

#### Developing Team:
This project was a collaborative effort of 7 Columbia students, with each team member contributing to different aspects of the app's development, including data scraping, front-end design, back-end functionality, and database management.

The work is breakdown as the following:
- Web Scrapping API & Data Collection - Wenxuan(Alice) Wu, Wendy Chen, Yuang Zhao
- Data Cleaning and Normalization - Vivian Yin & Wendy Chen
- Relational Database Design and Database Management - Vivian Yin & Wenxuan (Alice) Wu
- Data Loading - Wenxuan (Alice) Wu
- Shiny App Development - Vivian Yin (Home Page & App UI Design), Wenqing Huang (Restaurant & Hotel page, Interactive map & app UI Design), Shuwen Chen (Discography & Music Recommendation page), Yifei Pan (Ticket Sale & About us page)

 🎉 Special thanks to Prof. Day Yi for his invaluable support in helping us construct and enhance the features of the app. We could not have accomplished this without his guidance and expertise.
 
#### *Disclaimer*
This fan app is a student project developed as part of an academic course. It is not affiliated with or endorsed by Ed Sheeran or any associated entities. The project was created for educational purposes only, simulating a real-world application to demonstrate technical skills in R Shiny, HTML, CSS, and data integration.
