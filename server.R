server <- function(input, output, session) {
  
  # reactive values----
  a <- reactiveValues(
    ev = 1, # event # for events
    r = 0, # the restaurant selected (1 to 3)
    s = 1, # song selected to play
    v = 0, # selected video
    m = 0, # match pct 
    e = 0,
    b = 0 # the hotel selected (1 to 3)
  )
  
  m <- reactiveValues(
    i = 0, # member selected (1 to 7)
  )
  
  g <- reactiveValues(
    i = 1, # game selected (1 to 3)
  )
  
  p <- reactiveValues(
    i = 0, # partner selected (1 to 6)
  )
  
  concert_dates <- data.frame(
    date = c('15 Jun 2024',
             '05 Jul 2024',
             '25 Jul 2024',
             '15 Aug 2024',
             '05 Sep 2024',
             '25 Sep 2024',
             '15 Oct 2024',
             '05 Nov 2024',
             '25 Nov 2024',
             '05 Dec 2024'),
    venue = c('Staples Center - LOS ANGELES, CALIFORNIA, USA',
              'Bridgestone Arena - NASHVILLE, TENNESSEE, USA',
              'Verizon Center - WASHINGTON, DC, USA',
              'Wembley Stadium - LONDON, ENGLAND, UK',
              'Veltins - Arena - GELSENKIRCHEN, GERMANY',
              'The 02 Dublin - DUBLIN, IRELAND',
              'Ullevi - GOTHENBURG, SWEDEN',
              'Stade De France - PARIS, FRANCE',
              'Etihad Stadium - MELBOURNE, VIC, AUSTRALIA',
              'Madison Square Garden - NEW YORK CITY, NEW YORK, USA'),
    stringsAsFactors = FALSE
  )
  # >>>>>>>>>>>>>>>>>>----
  # ui background----
  output$uiBkgrd <- renderUI(
    if (input$tabs == 1) {
      setBackgroundImage('background.gif')
    } else if (input$tabs == 2) {
      setBackgroundImage('bg2.jpg')
    } else if (input$tabs == 3) {
      setBackgroundImage('hotel.jpg')
    } else if (input$tabs == 4) {
      setBackgroundImage('bg3.jpeg')
    } else if (input$tabs == 5) {
      setBackgroundImage('bg8.jpg')
    } else if (input$tabs == 6) {
      setBackgroundImage('bg7.jpg')
    } else if (input$tabs == 7) {
      setBackgroundImage('bg4.jpg')
    } else if (input$tabs == 8) {
      setBackgroundImage('bg9.jpg')
    } else if (input$tabs == 9) {
      setBackgroundImage('about.jpg')
    }
    
  )
  # >>>>>>>>>>>>>>>>>>----
  # ui button (vv) 
  observeEvent(input$btnconcert,
               {
                 updateTabsetPanel(session, 'tabs', selected = '2')
               })
  observeEvent(input$btndiscography,
               {
                 updateTabsetPanel(session, 'tabs', selected = '6')
               })
  
  observeEvent(
    eventExpr = input$submitEmail,
    {
      sendSweetAlert(
        title = 'Thank you!',
        text = paste0(
          'You have successfully joined our mailing list!'
        )
      )
    }
  )
  
  # >>>>>>>>>>>>>>>>>>----
  # ui concert----
  output$uiConcerts <- renderUI({
    # Define your concert dates and details here
    concert_dates <- data.frame(
      date = c('15 Jun 2024',
               '05 Jul 2024',
               '25 Jul 2024',
               '15 Aug 2024',
               '05 Sep 2024',
               '25 Sep 2024',
               '15 Oct 2024',
               '05 Nov 2024',
               '25 Nov 2024',
               '05 Dec 2024'),
      venue = c('Staples Center - LOS ANGELES, CALIFORNIA, USA',
                'Bridgestone Arena - NASHVILLE, TENNESSEE, USA',
                'Verizon Center - WASHINGTON, DC, USA',
                'Wembley Stadium - LONDON, ENGLAND, UK',
                'Veltins - Arena - GELSENKIRCHEN, GERMANY',
                'The 02 Dublin - DUBLIN, IRELAND',
                'Ullevi - GOTHENBURG, SWEDEN',
                'Stade De France - PARIS, FRANCE',
                'Etihad Stadium - MELBOURNE, VIC, AUSTRALIA',
                'Madison Square Garden - NEW YORK CITY, NEW YORK, USA'),
      stringsAsFactors = FALSE
    )
    
    # Now, create the UI elements for the concerts
    concert_ui <- lapply(1:nrow(concert_dates), function(i) {
      fluidRow(
        div(style = "margin-bottom: 30px", # Increase bottom margin for each row
            column(3, style = "padding-right: 20px;", # Increase right padding
                   div(class = "concert-date", strong(concert_dates$date[i]), style = "color: white; margin-left: 200px; margin-bottom: 10px; font-family: monospace;")
            ),
            column(4,
                   div(class = "concert-venue", style = "color: white; font-family: monospace; margin-left: 20px; margin-right: 30px;", concert_dates$venue[i])
            ),
            column(2, 
                   pickerInput(inputId = paste0("ticket", i), label = NULL,
                               choices = c("General - $150", "General Plus - $300", "VIP - $550", "Platinum - $1300"),
                               options = list(title = "Ticket Price"))
            ),
            column(2,
                   div(style = "width: 70px;",  # Apply margin style to div wrapper
                       numericInput(inputId = paste0("qty", i), label = NULL,value = 1, min = 1))
            ),
            column(1, # Adjusted column width to fit all buttons in one line
                   actionBttn(inputId = paste0('buyTix', i), label = 'Buy Ticket', 
                              style = 'simple', color = 'default', size = 'xs')
            )
        ),
        hr(style = "margin-top: 60px; margin-bottom: 30px;") # Increase spacing around <hr>
      )
    })
    
    do.call(tagList, concert_ui)
  })
  
    lapply(1:nrow(concert_dates), function(i) {
      observeEvent(input[[paste0('buyTix', i)]], {
        num_tickets <- input[[paste0('qty', i)]]
        showModal(modalDialog(
          title = "Purchase Successful",
          paste("Your", num_tickets, "tickets have been successfully purchased!"),
          easyClose = TRUE,
          footer = modalButton("Close")
        ))
      })
    })

  # >>>>>>>>>>>>>>>>>>----
  # ui hotels----
  output$uiHotels <- renderUI(
    {
      div(
        style = 'padding:100px 15% 0 15%;',
        align = 'center',
        radioGroupButtons(
          inputId = 'hotelLocs',
          choices = c(
            'Los Angeles' = 1,
            'Nashville' = 2,
            'Washington' = 3,
            'Saint-Denis' = 18,
            'Gelsenkirchen' = 5,
            'Dublin' = 6,
            'SGöteborg' = 17,
            'Paris' = 8,
            'Melbourne' = 9,
            'New York' = 10
          ),
          selected = character(0)
        ),
        uiOutput("uihotel2")
      )
    }
  )
  
  output$uihotel2 = renderUI(
    if (!is.null(input$hotelLocs)) {
      print(input$hotelLocs)
      fluidRow(
        column(
          width = 6,
          leafletOutput(
            outputId = 'hotelMap',
            height = '70vh'
          )
        ),
        column(
          width = 6,
          uiOutput('hotelList'),
          uiOutput('hotelOpts')
        )
      )
    }
  )
  
  # _ui hotel map----
  output$hotelMap <- renderLeaflet(
    {
      w <- dbGetQuery(
        conn = con,
        paste0('SELECT h.lat, h.lng, h.name, h.address_1, l1.city,h.url
            FROM hotels h
            LEFT JOIN LOCS l1 on h.city_id = l1.loc_id
            LEFT JOIN VENUES v ON v.venue_id = h.venue_id
            LEFT JOIN LOCS l2 on v.loc_id = l2.loc_id
            WHERE l2.loc_id = ', input$hotelLocs, ';')
      )
      # Retrieve venue data
      venues_data1 <- dbGetQuery(
        conn = con,
        paste0('SELECT v.lat, v.lng, v.venue, l.city
            FROM venues v
            JOIN locs l ON v.loc_id = l.loc_id
            WHERE l.loc_id = ', input$hotelLocs, ';')
      )
      # Check for NULL values in the data
      if (is.null(w) || nrow(w) == 0 ||
          is.null(venues_data1) || nrow(venues_data1) == 0) {
        return(NULL)  # Stop execution if there's no data
      }
      
      leaflet_map3 <- leaflet(
        data = w
      ) %>% 
        addTiles() %>% 
        addAwesomeMarkers(
          popup = ~paste0(
                        '<style>div.leaflet-popup-content {width:auto !important;}</style>',
                        '<h4 style = "color:black;">', w$name, '</h4>',
                        '<a href = "',
                        url,
                        '" target = "_blank">',
                        '<button id = "resvBtn" class = "btn action-button">',
                        '<h5 style = "color:black;">Booking</h5></button></a>'
                      ),
          icon = awesomeIcons(
            markerColor = 'green',
            text = 1:nrow(w)
          )
        ) 
      leaflet_map3 <- leaflet_map3 %>%
        addAwesomeMarkers(
          lng = ~lng, lat = ~lat,
          popup = ~venue,
          icon = ~awesomeIcons(
            markerColor = 'red',
            text = 'V'
          ),
          data = venues_data1
        )
      leaflet_map3
    }
  )

  # _ui hotel list----
  output$hotelList <- renderUI(
    {
      c <- dbGetQuery(
        conn = con,
        paste0('SELECT lat, lng, name
        FROM hotels
        where city_id = ',input$hotelLocs,';')
      )
      lapply(
        1:5,
        function(i) {
          wellPanel(
            fluidRow(
              column(
                width = 6,
                align = 'left',
                h4(style = "font-size: 16px;",
                  paste0(i,') ', c$name[i]))
              ),
              column(
                width = 3,
                actionBttn(
                  inputId = paste0('hotel', i),
                  label = 'Information',
                  style = 'simple',
                  color = 'success'
                )
              )
            )
          )
        }
      )
    }
  )
  
  # _events hotel buttons----
  observeEvent(eventExpr = input$hotel1, {a$b <- 1; flytohotel()})
  observeEvent(eventExpr = input$hotel2, {a$b <- 2; flytohotel()})
  observeEvent(eventExpr = input$hotel3, {a$b <- 3; flytohotel()})
  flytohotel <- function() {
    hotel_data <- dbGetQuery(
      conn = con,
      paste0('SELECT lat, lng, name, rating, address_1, phone
        FROM hotels WHERE city_id = ', input$hotelLocs,";")
    )
    leafletProxy(
      mapId = 'hotelMap'
    ) %>% 
      flyTo(
        lat = hotel_data$lat[a$b],
        lng = hotel_data$lng[a$b],
        zoom = 17
      )
    print(hotel_data$address_1[a$b])
    shinyalert(
      title = hotel_data$name[a$b],
      text = paste0('<style>.h4a {color:black;text-align: left;}</style>',
                    '<h4 class = "h4a">Address: ', hotel_data$address_1[a$b], '</h4>', 
                    '<h4 class = "h4a">Rating: ', hotel_data$rating[a$b], '</h4>',
                    '<h4 class = "h4a">Phone: ', hotel_data$phone[a$b], '</h4>'
      ), 
      html = TRUE
    )
  }
  
  # >>>>>>>>>>>>>>>>>>----
  # ui dining----
  output$uiDining <- renderUI(
    {
      div(
        style = 'padding:100px 15% 0 15%;',
        align = 'center',
        radioGroupButtons(
          inputId = 'dinLocs',
          choices = c(
            'Los Angeles' = 1,
            'Nashville' = 2,
            'Washington' = 3,
            'London' = 4,
            'Gelsenkirchen' = 5,
            'Dublin' = 6,
            'Gothenburg' = 7,
            'Paris' = 8,
            'Melbourne' = 9,
            'New York' = 10
          ),
          selected = character(0)
        ),
        uiOutput("uidining2")
        
      )
    }
  )
  
  output$uidining2 = renderUI(
    if (!is.null(input$dinLocs)) { 
      print(input$dinLocs)
      fluidRow(
        column(
          width = 6,
          leafletOutput(
            outputId = 'restMap',
            height = '70vh'
          )
        ),
        column(
          width = 6,
          uiOutput('restList'),
          uiOutput('restOpts')
        )
      )
    }
  )
  
  # _rest map----
  output$restMap <- renderLeaflet({
    # Retrieve restaurant data
    restaurants_data <- dbGetQuery(
      conn = con,
      paste0('SELECT r.lat, r.lng, r.name, r.address_1, l1.city, r.url
            FROM restaurants r
            LEFT JOIN LOCS l1 on r.city_id = l1.loc_id
            LEFT JOIN VENUES v ON v.venue_id = r.venue_id
            LEFT JOIN LOCS l2 on v.loc_id = l2.loc_id
            WHERE l2.loc_id = ', input$dinLocs, ';')
    )
    
    # Retrieve venue data
    venues_data <- dbGetQuery(
      conn = con,
      paste0('SELECT v.lat, v.lng, v.venue, l.city
            FROM venues v
            JOIN locs l ON v.loc_id = l.loc_id
            WHERE l.loc_id = ', input$dinLocs, ';')
    )
    
    # Check for NULL values in the data
    if (is.null(restaurants_data) || nrow(restaurants_data) == 0 ||
        is.null(venues_data) || nrow(venues_data) == 0) {
      return(NULL)  # Stop execution if there's no data
    }
    
    # Initialize leaflet map
    leaflet_map <- leaflet() %>%
      addTiles()
    
    # Add markers for restaurants (green)
    leaflet_map <- leaflet_map %>%
      addAwesomeMarkers(
        lng = ~lng, lat = ~lat,
        popup = ~paste0(
          '<style>div.leaflet-popup-content {width:auto !important;}</style>',
          '<h4 style = "color:black;">', restaurants_data$name, '</h4>',
          '<a href = "',
          url,
          '" target = "_blank">',
          '<button id = "resvBtn" class = "btn action-button">',
          '<h5 style = "color:black;">Reserve Table</h5></button></a>'
        ),
        icon = ~awesomeIcons(
          markerColor = 'green',
          text=1:10 #matching with the list
        ),
        data = restaurants_data  # Use restaurant data
      )
    
    # Add markers for venues (red)
    leaflet_map <- leaflet_map %>%
      addAwesomeMarkers(
        lng = ~lng, lat = ~lat,
        popup = ~venue,
        icon = ~awesomeIcons(
          markerColor = 'red',
          text = 'V'
        ),
        data = venues_data
      )
    
    leaflet_map
  })
  
  observeEvent(input$resvBtn, {print('Hello')})
  #########the modification ends here ~v 4/22
  # _ui rest list----
  output$restList <- renderUI(
    {
      z <- dbGetQuery(
        conn = con,
        paste0('SELECT r.lat, r.lng, r.name
        FROM RESTAURANTS r
        LEFT JOIN LOCS l1 on r.city_id = l1.loc_id
        LEFT JOIN VENUES v ON v.venue_id = r.venue_id
        LEFT JOIN LOCS l2 on v.loc_id = l2.loc_id
        where l2.loc_id  = ',input$dinLocs,';')
      )
      lapply(
        1:10,
        function(i) {
          div(
            tags$button(
              style = 'text-align:left; width:90%; background-color:rgba(0,0,0,0.8);',
              id = paste0('rest', i),
              class = 'btn action-button',
              h5(paste0(i, ' - ', z$name[i]))
            )
          )
        }
      )
    }
  )
  
  # _ui rest opts----
  output$restOpts <- renderUI(
    if (a$r > 0) {
      wellPanel(
        dateInput(
          inputId = 'restDate',
          label = 'Date',
          value = Sys.Date(),
          min = Sys.Date(),
          width = '50%'
        ),
        pickerInput(
          inputId = 'restTime',
          label = 'Time',
          choices = paste0(c(12:23), ':00'),
          selected = '12:00',
          width = '50%',
          inline = FALSE
        ),
        radioGroupButtons(
          inputId = 'restSize',
          label = 'Party Size',
          choices = c(1:6),
          selected = 2
        ),
        actionBttn(
          inputId = 'restConf',
          label = 'Confirm Booking',
          style = 'gradient',
          color = 'primary'
        )
      )
    }
  )
  
  # _event rest conf button----
  observeEvent(
    eventExpr = input$restConf,
    {
      z <- dbGetQuery(
        conn = con,
        'SELECT lat, lng, name, rating
        FROM restaurants;'
      )
      sendSweetAlert(
        title = 'Thank you!',
        text = paste0(
          'Your reservation for a party of ',
          input$restSize,
          ' at ',
          z$name[a$r], 
          ' is confirmed. See you on ',
          input$restDate,
          ' at ',
          input$restTime, '!'
        )
      )
    }
  )
  # _events rest buttons----
  observeEvent(eventExpr = input$rest1, {a$r <- 1; flytorest()})
  observeEvent(eventExpr = input$rest2, {a$r <- 2; flytorest()})
  observeEvent(eventExpr = input$rest3, {a$r <- 3; flytorest()})
  observeEvent(eventExpr = input$rest4, {a$r <- 4; flytorest()})
  observeEvent(eventExpr = input$rest5, {a$r <- 5; flytorest()})
  observeEvent(eventExpr = input$rest6, {a$r <- 6; flytorest()})
  observeEvent(eventExpr = input$rest7, {a$r <- 7; flytorest()})
  observeEvent(eventExpr = input$rest8, {a$r <- 8; flytorest()})
  
  flytorest <- function() {
    z1 <- dbGetQuery(
      conn = con,
      'SELECT r.lat, r.lng, r.name,r.rating,r.phone,r.address_1, cu.type
       FROM restaurants r
       left join cusines cu on r.cusine_id = cu.cusine_id;'
    )
    leafletProxy(
      mapId = 'restMap'
    ) %>%
      flyTo(
        lat = z1$lat[a$r],
        lng = z1$lng[a$r],
        zoom = 17
      )
    print(z1$address_1[a$r])
    shinyalert(
      title = z1$name[a$r],
      text = paste0('<style>.h4a {color:black;text-align: left;}</style>',
                    '<h4 class = "h4a">Address: ', z1$address_1[a$r], '</h4>', 
                    '<h4 class = "h4a">Rating: ', z1$rating[a$r], '</h4>',
                    '<h4 class = "h4a">Phone: ', z1$phone[a$r], '</h4>',
                    '<h4 class = "h4a">Type: ', z1$type[a$r], '</h4>'
      ), 
      html = TRUE
    )
  }
  # >>>>>>>>>>>>>>>>>>----
  # ui entertainment----
  output$uiEntertainments <- renderUI(
    {
      div(
        style = 'padding:100px 10% 0 10%;',
        align = 'center',
        radioGroupButtons(
          inputId = 'entLocs',
          choices = c(
            'Staples Center' = 1,
            'Bridgestone Arena' = 2,
            'Verizon Center' = 3,
            'Wembley Stadium' = 4,
            'Veltins-Arena' = 5,
            'The O2 Dublin' = 6,
            'Ullevi' = 7,
            'Stade De France' = 8,
            'Etihad Stadium' = 9,
            'Madison Square Garden' = 10
          ),
          selected = character(0)
        ),
        uiOutput("uienter2")
        
      )
    }
  )
  
  output$uienter2 = renderUI(
    if (!is.null(input$entLocs)) { 
      print(input$entLocs)
      fluidRow(
        column(
          width = 6,
          leafletOutput(
            outputId = 'entMap',
            height = '70vh'
          )
        ),
        column(
          width = 5,
          uiOutput('entList'),
          uiOutput('entOpts')
        )
      )
    }
  )
  # _ent map----
  output$entMap <- renderLeaflet(
    {
      q <- dbGetQuery(
        conn = con,
        paste0('SELECT e.lat, e.lng, e.name, e.address_1, l1.city
            FROM entertainments e
            LEFT JOIN LOCS l1 on e.city_id = l1.loc_id
            LEFT JOIN VENUES v ON v.venue_id = e.venue_id
            LEFT JOIN LOCS l2 on v.loc_id = l2.loc_id
            WHERE l2.loc_id = ', input$entLocs, ';')
      )
      # Retrieve venue data
      venue_data <- dbGetQuery(
        conn = con,
        paste0('SELECT v.lat, v.lng, v.venue, l.city
            FROM venues v
            JOIN locs l ON v.loc_id = l.loc_id
            WHERE l.loc_id = ', input$entLocs, ';')
      )
      # Check for NULL values in the data
      if (is.null(q) || nrow(q) == 0 ||
          is.null(venue_data) || nrow(venue_data) == 0) {
        return(NULL)  # Stop execution if there's no data
      }
      
      leaflet_map1 <- leaflet(
        data = q
      ) %>% 
        addTiles() %>% 
        addAwesomeMarkers(
          popup = ~paste0('<style>div.leaflet-popup-content {width:auto !important;}</style>',
                    '<h4 style = "color:black;">', q$name, '</h4>',
                    '<a href = "',
                    'https://www.google.com/maps/place/The+Bloc/@34.0475959,-118.2615775,17z/data=!3m2!4b1!5s0x80dd2d16b9ba2367:0x42dcb3a15edcb1fc!4m6!3m5!1s0x80c2c7b6af26cb6f:0x2870abf530e7b2dd!8m2!3d34.0475959!4d-118.2590026!16s%2Fg%2F11cs1lcwm1?entry=ttu', 
                    '" target = "_blank">',
                    '<button id = "resvBtn" class = "btn action-button">',
                    '<h5 style = "color:black;">Direction</h5></button></a>'
              ),
          icon = awesomeIcons(
            markerColor = 'green',
            text = 1:nrow(q)
          )
        ) 
      leaflet_map2 <- leaflet_map1 %>%
        addAwesomeMarkers(
          lng = ~lng, lat = ~lat,
          popup = ~venue,
          icon = ~awesomeIcons(
            markerColor = 'red',
            text = 'V'
          ),
          data = venue_data
        )
      leaflet_map2
    }
  )
  
  # _ui entertainment list----
  output$entList <- renderUI({
    # Execute the SQL query
    q <- dbGetQuery(
      conn = con,
      paste0("SELECT lat, lng, name, rating FROM entertainments WHERE venue_id = "
             , input$entLocs, ";")
    )
    
    # Check if the query returned any rows
    if (nrow(q) > 0) {
      # Use the number of rows to iterate over all results
      lapply(
        1:nrow(q),
        function(i) {
          wellPanel(
            fluidRow(
              column(
                width = 6,
                align = 'left',
                h4(style = "font-size: 16px;",
                   paste0(i, ') ', q$name[i]))
              ),
              column(
                width = 3,
                actionBttn(
                  inputId = paste0('ent', i),
                  label = 'Information',
                  style = 'simple',
                  color = 'success'
                )
              )
            )
          )
        }
      )
    } else {
      h4("No entertainment places found for the selected city.")
    }
  })
  
  # _events ent buttons----
  observeEvent(eventExpr = input$ent1, {a$e <- 1; flytoent()})
  observeEvent(eventExpr = input$ent2, {a$e <- 2; flytoent()})
  observeEvent(eventExpr = input$ent3, {a$e <- 3; flytoent()})
  flytoent <- function() {
    q <- dbGetQuery(
      conn = con,
      paste0('SELECT lat, lng, name, rating, address_1, rating, phone
        FROM entertainments WHERE venue_id = ', input$entLocs,";")
      )
    leafletProxy(
      mapId = 'entMap'
    ) %>% 
      flyTo(
        lat = q$lat[a$e],
        lng = q$lng[a$e],
        zoom = 17
      )
    print(q$address_1[a$e])
    shinyalert(
      title = q$name[a$e],
      text = paste0('<style>.h4a {color:black;text-align: left;}</style>',
                    '<h4 class = "h4a">Address: ', q$address_1[a$e], '</h4>', 
                    '<h4 class = "h4a">Rating: ', q$rating[a$e], '</h4>',
                    '<h4 class = "h4a">Phone: ', q$phone[a$e], '</h4>'
      ), 
      html = TRUE
    )
  }
  
  # _ui vid----
  output$uiVid = renderUI(
    if (a$v > 0) {
      div(
        align = 'center',
        h4(
          style = 'color:white;',
          c(
            'Galway Girl',
            'Antisocial',
            'Supermarket Flowers',
            'Perfect',
            'Photograph'
          )[a$v]
        ),
        tags$video(
          src = c(
            'galway.mp4',
            'Antisocial.mp4',
            'Supermarket.mp4',
            'Perfect.mp4',
            'photograph.mp4'
          )[a$v],
          width = '60%',
          height = '450px',
          controls = TRUE
        )
      )
    }
  )
  
  # _match animator----
  recMatch = function(x) {
    observe(
      {
        invalidateLater(50, session)
        isolate(
          if (a$m < x) {
            a$m = a$m + sample(1:5, 1)
          }
        )
      }
    )
  }
  
  # _ui match----
  output$uiMatch = renderUI(
    if (a$v > 0) {
      div(
        align = 'center',
        h4('Music Recommender',
           style = 'color:white;',
           paste0(
             'Match: ',
             a$m, '%'
           )
        )
      )
    }
  )
  
  # >>>>>>>>>>>>>>>>>>----
  # ui discography----
  output$uiDiscography <- renderUI(
    div(
      style = 'padding:100px 15% 0 15%;',
      align = 'center',
      fluidRow(
        column(
          width = 6,
          div(
            h4("Perfect", style = 'color: white;fontfamily:monospace'),
            tags$video(src = 'perfect.mp4',
                       controls = TRUE,
                       height = '450px',
                       width = '100%')
          )
        ),
        column(
          width = 6,
          h4("Thinking Out Loud", style = 'color: white;fontfamily:monospace'),
          tags$video(src = 'Thinking.mp4',
                     controls = TRUE,
                     height = '450px',
                     width = '100%')
        )
      ),
      fluidRow(
        column(
          width = 6,
          h4("Galway Girl", style = 'color:white;fontfamily:monospace'),
          tags$video(
            src = 'galway.mp4',  
            controls = TRUE,
            height = '450px',
            width = '100%'
          )
        ),
        column(
          width = 6,
          h4("Photograph", style = 'color:white;fontfamily:monospace'),
          tags$video(
            src = 'photograph.mp4',  
            controls = TRUE,
            height = '450px',
            width = '100%'
          )
        )
      ) 
    )
  )
  
  # >>>>>>>>>>>>>>>>>>----
  # ui recommender----
  output$uiRecommender <- renderUI(
    {
      div(
        style = 'padding:150px 5% 0 5%;',
        fluidRow(
          column(1),
          lapply(
            1:5,
            function(i) {
              column(
                width = 2,
                actionBttn(
                  inputId = paste0('mood', i),
                  label = c(
                    '\U1F601 Joy',
                    '\U1F4A2 Anger',
                    '\U1F62D Sadness',
                    '\U1F63B Love',
                    '\U1F616 Nostalgia'
                  )[i],
                  style = 'simple',
                  color = c(
                    'danger',
                    'warning',
                    'success',
                    'primary',
                    'royal'
                  )[i],
                  size = 'md',
                  block = TRUE
                )
              )
            }
          )
        ),
        hr(),
        uiOutput('uiVid'),
        uiOutput('uiMatch')
      )
    }
  )
  
  output$uiVid <- renderUI({
    # Retrieve which mood button was pressed
    active_mood <- sapply(1:5, function(i) {
      input[[paste0('mood', i)]]
    })
    
    # Determine which set of videos to display based on the mood button pressed
    if (!is.null(active_mood) && any(active_mood)) {
      mood_index <- which(active_mood == TRUE)[1]
      videos <- switch(
        mood_index,
        list( # Joy
          fluidRow(
            column(width = 6, div(h4("Galway Girl", style = 'color: white;font-family:monospace'), tags$video(src = 'galway.mp4', controls = TRUE, height = '450px', width = '100%'))),
            column(width = 6, div(h4("Collide", style = 'color: white;font-family:monospace'), tags$video(src = 'collide.mp4', controls = TRUE, height = '450px', width = '100%')))
          ),
          fluidRow(
            column(width = 6, div(h4("Sandman", style = 'color: white;font-family:monospace'), tags$video(src = 'sandman.mp4', controls = TRUE, height = '450px', width = '100%'))),
            column(width = 6, div(h4("Life Goes On", style = 'color: white;font-family:monospace'), tags$video(src = 'life.mp4', controls = TRUE, height = '450px', width = '100%')))
          )
        ),
        list( # Anger
          fluidRow(
            column(width = 6, div(h4("You Need Me, I Don't Need You", style = 'color: white;font-family:monospace'), tags$video(src = "need.mp4", controls = TRUE, height = '450px', width = '100%'))),
            column(width = 6, div(h4("Runaway", style = 'color: white;font-family:monospace'), tags$video(src = 'runaway.mp4', controls = TRUE, height = '450px', width = '100%')))
          ),
          fluidRow(
            column(width = 6, div(h4("Cross Me", style = 'color: white;font-family:monospace'), tags$video(src = 'cross.mp4', controls = TRUE, height = '450px', width = '100%'))),
            column(width = 6, div(h4("Antisocial", style = 'color: white;font-family:monospace'), tags$video(src = 'Antisocial.mp4', controls = TRUE, height = '450px', width = '100%')))
          )
        ),
        list( # Sadness
          fluidRow(
            column(width = 6, div(h4("Supermakert Flower", style = 'color: white;font-family:monospace'), tags$video(src = 'supermarket.mp4', controls = TRUE, height = '450px', width = '100%'))),
            column(width = 6, div(h4("Way To Break My Heart", style = 'color: white;font-family:monospace'), tags$video(src = 'way.mp4', controls = TRUE, height = '450px', width = '100%')))
          ),
          fluidRow(
            column(width = 6, div(h4("Blue", style = 'color: white;font-family:monospace'), tags$video(src = 'blue.mp4', controls = TRUE, height = '450px', width = '100%'))),
            column(width = 6, div(h4("Afire Love", style = 'color: white;font-family:monospace'), tags$video(src = 'afire.mp4', controls = TRUE, height = '450px', width = '100%')))
          )
        ),
        list( # Love
          fluidRow(
            column(width = 6, div(h4("Perfect", style = 'color: white;font-family:monospace'), tags$video(src = 'perfect.mp4', controls = TRUE, height = '450px', width = '100%'))),
            column(width = 6, div(h4("Thinking Out Loud", style = 'color: white;font-family:monospace'), tags$video(src = 'Thinking.mp4', controls = TRUE, height = '450px', width = '100%')))
          ),
          fluidRow(
            column(width = 6, div(h4("Wake Me Up", style = 'color: white;font-family:monospace'), tags$video(src = 'wake.mp4', controls = TRUE, height = '450px', width = '100%'))),
            column(width = 6, div(h4("Put It All On Me", style = 'color: white;font-family:monospace'), tags$video(src = 'put.mp4', controls = TRUE, height = '450px', width = '100%')))
          )
        ),
        list( # Nostalgia
          fluidRow(
            column(width = 6, div(h4("Castle On The Hill", style = 'color: white;font-family:monospace'), tags$video(src = 'castle.mp4', controls = TRUE, height = '450px', width = '100%'))),
            column(width = 6, div(h4("End of Youth", style = 'color: white;font-family:monospace'), tags$video(src = 'end', controls = TRUE, height = '450px', width = '100%')))
          ),
          fluidRow(
            column(width = 6, div(h4("Photograph", style = 'color: white;font-family:monospace'), tags$video(src = 'photograh.mp4', controls = TRUE, height = '450px', width = '100%'))),
            column(width = 6, div(h4("The City", style = 'color: white;font-family:monospace'), tags$video(src = 'city.mp4', controls = TRUE, height = '450px', width = '100%')))
          )
        )
      )
      return(videos) # This will render the correct video rows for the active mood
    }
  }
  )
  
  # _events mood----
  observeEvent(input$mood1, {a$v = 1; a$m = 0; recMatch(85)})
  observeEvent(input$mood2, {a$v = 2; a$m = 0; recMatch(90)})
  observeEvent(input$mood3, {a$v = 3; a$m = 0; recMatch(80)})
  observeEvent(input$mood4, {a$v = 4; a$m = 0; recMatch(75)})
  observeEvent(input$mood5, {a$v = 5; a$m = 0; recMatch(90)})
  
  # ui sponsors----
  output$uiSponsors <- renderUI({
    tags$div(
      style = 'display: flex; justify-content: center; align-items: center; height: 100vh;',
      tags$div(
        style = 'display: flex; flex-direction: row; flex-wrap: wrap; justify-content: center; align-items: center; max-width: 500px; margin: 0 auto;', # This container has a maximum width and is centered
        lapply(1:4, function(i) {
          tags$div(
            style = 'margin: 20px;', # Provides space between images
            tags$img(
              src = paste0('sponsor', i, '.jpg'), 
              style = 'height: auto; max-height: 100px; object-fit: contain;' # Reduces the max-height to make images smaller
            )
          )
        })
      )
    )
  })
  # >>>>>>>>>>>>>>>>>>----
  # ui about us----
  output$uiAbout <- renderUI({
    div(
      style = 'padding:20vh 5% 0 5%; text-align: center;',
      h3(
        style = 'color:white;',
        'Our Team'
      ),
      hr(),
      fluidRow(
        lapply(
          1:4, 
          function(i) {
            column(
              width = 2,
              offset = ifelse(i == 1, 2, 0),
              div(
                img(
                  src = paste0('member', i, '.jpg'),
                  style = 'width:90%; height:auto; max-height:170px;'
                ),
                style = 'overflow:hidden;'
              ),
              h4(
                style = 'color:white; font-size:14px;', 
                mems[i]
              )
            )
          }
        )
      ),
      fluidRow(
        lapply(
          5:7, 
          function(i) {
            column(
              width = 2,
              offset = ifelse(i == 5, 3, 0),
              div(
                img(
                  src = paste0('member', i, '.jpg'),
                  style = 'width:90%; height:auto; max-height:170px;'
                ),
                style = 'overflow:hidden;'
              ),
              h4(
                style = 'color:white; font-size:14px;',  
                mems[i]
              )
            )
          }
        )
      )
    )
  })
}