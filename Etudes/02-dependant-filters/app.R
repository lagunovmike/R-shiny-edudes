library(shiny)
library(dplyr)

# Sample data frame
data <- data.frame(
    year = c(2021, 2021, 2022, 2022, 2023, 2023),
    month = c(1, 2, 1, 2, 1, 2),
    sales = c(100, 150, 120, 180, 90, 200)
)

# Define the UI for the Shiny app
ui <- fluidPage(
    selectInput(
        "granularity",
        "Select Granularity",
        choices = c("Year", "Month"),
        selected = "Year"
    ),
    selectInput("selector", "Select Value", choices = NULL),
    
    mainPanel(tableOutput("table"))
)

# Define the server logic for the Shiny app
server <- function(input, output, session) {
    
    # Update the 'selector' input choices based on the 'granularity' selection
    observe({
        if (input$granularity == "Year") {
            updateSelectInput(session, "selector", choices = sort(unique(data$year)))
        } else if (input$granularity == "Month") {
            updateSelectInput(session, "selector", choices = sort(unique(data$month)))
        }
    })
    
    # Create a filtered data frame based on granularity selection
    filtered_data <- reactive({
        message('rendering a table')
        if (input$granularity == "Year") {
            data %>%
                filter(year == input$selector)
        } else if (input$granularity == "Month") {
            data %>%
                filter(month == input$selector)
        }
    })
    
    # Render the filtered table
    output$table <- renderTable({
        filtered_data()
    })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
