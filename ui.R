ui <- fluidPage(
  useShinyjs(), 
  tags$head(
    tags$link(rel = "shortcut icon", type = "image/png", href = "logo.jpg"), # added an integral sign as web logo modi 4/22 - V
    tags$style(HTML('
      @import url("https://fonts.googleapis.com/css2?family=Roboto+Mono:wght@400;700&display=swap");

      /* Extracting Typing animation */
      .typing {
        font-family: "Roboto Mono", monospace;
        white-space: nowrap;
        overflow: hidden;
        border-right: .15em solid orange;  /* The cursor */
        animation: typing 3.0s steps(30, end), blink-caret .35s step-end infinite;
      }

      /* Typing keyframes */
      @keyframes typing {
        from { width: 0 }
        to { width: 100% }
      }

      /* Cursor blink animation */
      @keyframes blink-caret {
        from, to { border-color: transparent }
        50% { border-color: orange; }
      }

        /* Adjusted Button styling for larger size and transparency */
        .btn-large {
        padding: 20px 40px; /* Large padding */
        font-size: 24px; /* Large font size */
        border-radius: 5px; /* Rounded corners */
        border: 2px solid white; /* White border */
        background-color: rgba(255, 87, 51, 0.3); /* Semi-transparent background */
        color: white; /* White text color */
      }
      /* Adjusted hover effect for button */
      .btn-large:hover {
        background-color: rgba(255, 87, 51, 0.6); /* Slightly less transparent on hover */
        box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2); /* Subtle shadow */
      }
    
      /* Ensure the primary button also carries the large styling */
      .btn-primary.btn-large {
        background-color: rgba(255, 87, 51, 0.7); /* Consistency in color and transparency */
      }
      
     /* Centering the container div for the text input */
      #email-container {
        display: flex;
        justify-content: center;
      }

      /* Styling for the text input to maintain a consistent look */
      #email {
        width: 300px;
        display: block;
      }


    '))
  ),
  navbarPage(
    id = 'tabs',
    windowTitle = '2024 Integral World Tour',
    position = 'fixed-top',
    collapsible = TRUE,
    inverse = FALSE,
    theme = shinytheme('cyborg'), 
    
    uiOutput('uiBkgrd'),
    
    tabPanel(
      value = 1,
      title = 'Home',
      fluidRow(
        column(
          width = 12,
          div(
            class = "text-center custom-font",
            h1("ED ∫HEERAN Integral World Tour",
               style = "color: white; padding-top:150px; margin-bottom: 10px; font-family:monospace"),
            h2("Coming to L.A. ...",class='typing',
               style = "color: white; padding-top:10px; margin-bottom: 10px; font-family:monospace"),
            h3("On June 15, 2024", class='typing',
               style = "color: white; padding-top:10px; margin-bottom: 20px; font-family:monospace"),
            actionButton("btnconcert", h5("\U1F3AB Get Your Ticket Today"), class = "btn btn-primary btn-large"),
            actionButton("btndiscography", h5("\U266A Checkout His Discography"), class = "btn-primary btn-large"),
            h6("Join our mailing list today", style = "color: white; margin-top: 20px; font-family:monospace"),
            div(class = "text-center custom-font",
                div(id = "email-container",
                    textInput("email", label = NULL, placeholder = "Enter email here")
                ),
                actionButton("submitEmail", "Subscribe", class = "btn-primary btn-large")
            ),
            style = "text-align: center;"  # Ensure all contents within the div are centered
          )
        )
      )
    ),
    tabPanel(
      value = 2,
      title = '\U1F3AB Concerts',
      fluidRow(
        column(12,
               div(
                 class = "text-center custom-font", 
                 h3("2024 INTERGRAL WORLD TOUR", 
                    style = "color: white; padding-top:100px;
                        margin-bottom: 50px;font-family:monospace;font-weight: bold;",
                    style="margin-left: 80px;"
                 )
               )
        )
      ),
      uiOutput('uiConcerts')
      
    ),
    
    tabPanel(
      value = 3,
      title = '\U1F3E8 Hotels',
      uiOutput('uiHotels')
    ),
    
    tabPanel(
      value = 4,
      title = '\U1F37D Dining',
      uiOutput('uiDining')
    ),
    
    tabPanel(
      value = 5,
      title = '\U1F6D2 Entertainments',
      uiOutput('uiEntertainments')
    ),
    
    tabPanel(
      value = 6,
      title = '\U1F3B8 Discography',
      uiOutput('uiDiscography')
    ),
    
    tabPanel(
      value = 7,
      title = '\U1F44D Recommender',
      uiOutput('uiRecommender')
    ),
    
    tabPanel(
      value = 8,
      title = '\U1F4B0 Sponsors',
      uiOutput('uiSponsors')
    ),
    
    tabPanel(
      value = 9,
      title = '\U1F469 About Us',
      uiOutput('uiAbout')
    )
  )
)