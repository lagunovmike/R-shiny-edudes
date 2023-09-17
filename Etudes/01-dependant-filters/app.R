library(shiny)
library(tidyverse)

ui <- fluidPage(
    selectInput(
        inputId  = 'granularity',
        label    = 'Granularity',
        choices  = c('year', 'month'),
        selected = 'month'
    ),
    selectInput(
        inputId  = 'period',
        label    = '',
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
    
    # Reactive value to store selected_period
    selected_period <- reactiveVal()
    
    observeEvent(input$granularity, {
        df <- generatedData()
        selected_granularity <- input$granularity
        
        choices <- df |> select(all_of(selected_granularity)) |> pull() |> sort()
        selected <- max(choices)
        
        updateSelectInput(
            session  = session,
            inputId  = "period",
            label    = selected_granularity,
            choices  = choices,
            selected = selected
        )
        
        # Update selected_period
        selected_period(as.numeric(selected))
    })
    
    observeEvent(input$period, {
        selected_period_value <- req(input$period)
        selected_period(as.numeric(selected_period_value))
    })
    
    output$table <- renderTable({
        selected_granularity <- req(input$granularity)
        selected_period_value <- req(selected_period())
        df <- generatedData()
        message(toupper('LOGGER: Rendering a table'))
        df_filtered <- df |> filter(get(selected_granularity) %in% selected_period_value)
        df_filtered
    })
}

# options(shiny.reactlog = TRUE)

# Run the application 
shinyApp(ui = ui, server = server)
