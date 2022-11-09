#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

## Libraries 
library(shinythemes)
library(plotly)
library(tidyverse)
library(usmap)
library(viridis)
library(ggplot2)
library(ggrepel)

## Data
df <- readRDS("beers_clean.rds")



# Define UI for application
ui <- fluidPage(
  
    # Set theme
    theme = shinytheme("flatly"),

    # Application title
    titlePanel("US Beers and Breweries"),
    
)

# Define server logic required for plotting
server <- function(input, output) {
    
    # Brewery Density Map Plot
    output$plot1 <- renderPlot({
        
        
    }, height = 800, width = 1200)
    
    # Pie Chart
    output$plot2 <- renderPlotly({
      
 
    })
    
    # ABV Plot
    output$plot3 <- renderPlotly({


    })
    
    # IBU Plot
    output$plot4 <- renderPlotly({

      
    })
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
