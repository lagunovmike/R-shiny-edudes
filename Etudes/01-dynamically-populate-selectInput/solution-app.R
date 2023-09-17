library(shiny)
library(tidyverse)
set.seed(123)

ui <- fluidPage(
    # Initiate the input in the ui part
    selectInput(
        inputId  = 'year',
        label    = 'Select year:',
        choices  = '',
    ),
    tableOutput('table')
)

server <- function(input, output, session) {
    generatedData <- reactive({
        n_rows <- 50
        df <- tibble(
            year        = sample(c(2021, 2022, 2023), size = n_rows, replace = TRUE),
            month       = sample(1:12, size = n_rows, replace = TRUE),
            rand_sample = sample(100:1000, size = n_rows, replace = TRUE)
        ) |>
            arrange(year, month)
        df
    })
    
    # dynamically populate input$year
    observe({
        df <- generatedData()
    
        choices <- df$year |> sort()
        selected <- max(choices)
        
        updateSelectInput(
            session  = session,
            inputId  = "year",
            choices  = choices,
            selected = selected
        )
    })
    
    output$table <- renderTable({
        selected_year <- req(input$year)
        df <- generatedData()
        message('Rendering a table')
        df_filtered <- df |> filter(year %in% selected_year)
        df_filtered
    })
}

# options(shiny.reactlog = TRUE)

# Run the application 
shinyApp(ui = ui, server = server)