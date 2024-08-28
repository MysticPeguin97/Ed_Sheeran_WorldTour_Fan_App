### Ed Sheeran World Tour Fan App 

🔗App Demo: https://vivianry.shinyapps.io/Ed_Sheeran_World_Tour_Fan_APP/

📊 Presentation: [Fan App  Presentation.pptx](https://github.com/user-attachments/files/16776834/Fan.App.Presentation.pptx)

#### Project Overview:
In this project, we developed a fan app for a world-renowned artist, Ed Sheeran, for his hypothetical world tour, the Integral Tour. We chose to focus on Ed Sheeran, creating a fan app using R Shiny that provides essential information for fans attending his concerts at various stadiums across the world. The app is designed to enhance the concert experience by offering detailed information on amenities near each stadium, including restaurants, hotels, and local attractions.

#### Business Objectives:
This project simulates the development of a user-centric application aimed at enhancing fan engagement and addressing logistical challenges at large-scale concerts. The app demonstrates how technology can improve the fan experience by offering personalized services, while also creating opportunities for monetization through partnerships with local businesses, hotels, and restaurants.

By focusing on a world-renowned artist like Ed Sheeran, we explored how such a platform can add value to both fans and businesses in the event, hospitality, and entertainment sectors, providing potential for sponsorships, advertising, and new revenue streams.

![alt text](https://github.com/user-attachments/assets/231273d4-a00b-4d4e-936e-dabf9025e558)
(Tour Poster, *Courtesy of Wenqing Huang and Wenxuan Wu*)

#### Key Features:
- **Stadium Information:** The app includes a list of major stadiums where an artist of Ed Sheeran's might perform. The app will provide each stadium's details such as location, and other relevant information.
  
- **Nearby Amenities:** For each stadium, the app provides a curated list of nearby restaurants, hotels, and local attractions. Through the interactive map, users can reserve restaurants, book hotels, and navigate to nearby entertainment venues, allowing fans to seamlessly plan their visit with access to dining, accommodation, and entertainment options near the concert venue.
  
- **Interactive Maps:** The app features interactive maps that show the location of each stadium and the surrounding amenities. Fans can explore the area visually and make informed decisions about where to eat, stay, and what to do before or after the concert.

- **User-Friendly Interface:** Built using R Shiny, the app is intuitive and easy to navigate, making it accessible to fans of all ages. The design is tailored to provide a seamless experience, allowing users to quickly find the information they need.

#### Technology Stack:
- **R Shiny:** For building the interactive web application.
- **HTML and CSS:** Used in conjunction with R Shiny to enhance the design and user experience.
- **PostgreSQL Database:** The data scraped from Yelp was stored in an SQL database to efficiently manage and query information related to the stadiums and nearby amenities.
- **Data Sources:** The data on restaurants, hotels, and attractions were scraped from Yelp using APIs.

#### Database Schema
![alt text](https://github.com/user-attachments/assets/371ec637-78f3-44a5-a305-30f4d1c09b4e)

#### Developing team:
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
