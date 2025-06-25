library(shiny)
library(ggplot2)
library(plotly)
library(DT)
library(dplyr)
library(lubridate)
library(readr)

# Load data
item_data <- read_csv("data/Psychometric_Items_Dataset.csv")

# UI
ui <- fluidPage(
  titlePanel("Psychometric Item Analysis Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "domain",
        label = "Select Content Domain:",
        choices = c("All", unique(item_data$ContentDomain)),
        selected = "All"
      ),
      dateRangeInput(
        inputId = "date_range",
        label = "Select Test Date Range:",
        start = min(item_data$TestDate),
        end = max(item_data$TestDate)
      )
    ),
    mainPanel(
      fluidRow(
        column(4, strong("Average Difficulty:"), textOutput("avg_difficulty")),
        column(4, strong("Average Discrimination:"), textOutput("avg_discrimination")),
        column(4, strong("Items Shown:"), textOutput("n_items"))
      ),
      br(),
      plotlyOutput("scatter_plot"),
      br(),
      plotlyOutput("trend_plot"),
      br(),
      DTOutput("table"),
      br(),
      downloadButton("download", "Download Filtered Data")
    )
  )
)

# Server
server <- function(input, output) {
  
  filtered_data <- reactive({
    data <- item_data %>%
      filter(TestDate >= input$date_range[1] & TestDate <= input$date_range[2])
    
    if (input$domain != "All") {
      data <- data %>% filter(ContentDomain == input$domain)
    }
    
    data
  })
  
  output$avg_difficulty <- renderText({
    round(mean(filtered_data()$Difficulty), 2)
  })
  
  output$avg_discrimination <- renderText({
    round(mean(filtered_data()$Discrimination), 2)
  })
  
  output$n_items <- renderText({
    nrow(filtered_data())
  })
  
  output$scatter_plot <- renderPlotly({
    p <- ggplot(filtered_data(), aes(x = Difficulty, y = Discrimination, color = ContentDomain)) +
      geom_point(size = 3, alpha = 0.7) +
      theme_minimal() +
      labs(title = "Item Difficulty vs. Discrimination",
           x = "Difficulty (p-value)",
           y = "Discrimination Index")
    ggplotly(p)
  })
  
  output$trend_plot <- renderPlotly({
    trend_data <- filtered_data() %>%
      group_by(Month = floor_date(TestDate, "month")) %>%
      summarize(
        Avg_Difficulty = mean(Difficulty),
        Avg_Discrimination = mean(Discrimination)
      )
    
    p <- ggplot(trend_data, aes(x = Month)) +
      geom_line(aes(y = Avg_Difficulty), color = "blue") +
      geom_line(aes(y = Avg_Discrimination), color = "red") +
      theme_minimal() +
      labs(title = "Difficulty and Discrimination Over Time",
           x = "Month",
           y = "Average Value") +
      scale_y_continuous(sec.axis = sec_axis(~., name = "Discrimination"))
    
    ggplotly(p)
  })
  
  output$table <- renderDT({
    datatable(filtered_data(), options = list(pageLength = 10))
  })
  
  output$download <- downloadHandler(
    filename = function() {
      paste0("psychometric_data_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)
