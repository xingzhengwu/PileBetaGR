run_my_shiny_app <- function() {
  # Define UI for the application
  ui <- fluidPage(
    titlePanel("My First Shiny App"),
    sidebarLayout(
      sidebarPanel(
        sliderInput("num", 
                    "Choose a number:", 
                    min = 1, 
                    max = 100, 
                    value = 50)
      ),
      mainPanel(
        textOutput("result")
      )
    )
  )

  # Define server logic
  server <- function(input, output) {
    output$result <- renderText({
      paste("You have selected:", input$num)
    })
  }

  # Run the Shiny app
  shinyApp(ui = ui, server = server)
}
