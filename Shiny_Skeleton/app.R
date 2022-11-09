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
    

    # Sidebar with a slider input for number of bins 
    # Drop down selection for UID
    sidebarLayout(
        sidebarPanel(
            # Drop down selection for State
            selectInput("state_choice", label = "Select State",
                choices = c("All States", unique(df$state)), 
                selected = character(0)),
            
            # Drop down selection for Beer Type
            checkboxGroupInput("beer_choice", label = "Select Beer Type",
                 choices = c(unique(df$style)), 
                 selected = c(unique(df$style)))
        ),

        # Show a plot of the generated distribution
        # Plot
        mainPanel(
            navbarPage(" ",
                 tabPanel("Brewery Density", plotOutput('plot1')),
                 tabPanel("Beer Types", plotlyOutput('plot2', width = "800px", height = "800px")),
                 tabPanel("ABV and IBU",plotlyOutput('plot3'), plotlyOutput('plot4'))
            )
        )
    )
)

# Define server logic required for plotting
server <- function(input, output) {
  
    options(shiny.sanitize.errors = TRUE)
    
    # Brewery Density Map Plot
    output$plot1 <- renderPlot({
        
        # subset and summarize data
        if(input$state_choice == "All States"){
          # filter data
          dens_dat <- df %>% group_by(state) %>% summarise(N = n())
          # make plot
          dens_plot <- plot_usmap(data = dens_dat, values = "N", labels = TRUE, label_color = "white") + 
            scale_fill_continuous(type = "viridis", name = "Brewery Count") +
            labs(title = "Brewery Density", subtitle = "per U.S. State")
          
        }else{
          # filter data
          dens_dat <- df %>% group_by(fips) %>% 
            summarise(N = n(), county = county) %>% slice(1)
          # make plot
          state_input = input$state_choice
          dens_plot <- plot_usmap(data = dens_dat, values = "N", include = input$state_choice,
                                  regions = "county", labels = TRUE, label_color = "white") + 
            scale_fill_continuous(type = "viridis", name = "Brewery Count") +
            labs(title = "Brewery Density", subtitle = paste("per", state_input, "County"))
        }
        
        dens_plot + 
          theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 20)) + 
          theme(plot.subtitle = element_text(hjust = 0.5, face = "bold.italic", size = 15)) + 
          theme(legend.key.size = unit(1, 'cm'), legend.title = element_text(size=14), 
                legend.text = element_text(size=10), legend.position = "bottom")
        
    }, height = 800, width = 1200)
    
    # Pie Chart
    output$plot2 <- renderPlotly({
      
      # Summarize beer types over selected state
      type_dat <- df %>% 
        filter(if(input$state_choice != "All States") state == input$state_choice else state == state) %>% 
        group_by(style) %>% 
        summarise(N = n()) %>% 
        ungroup() %>% 
        mutate(prop = N/sum(N)) %>% 
        arrange(desc(prop))
      
      
      # Make plot
      type_plot <- plot_ly(type_dat, labels = ~style, values = ~N, type = 'pie')
      type_plot %>% layout(title = 'United States Beer Types',
                          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

    })
    
    # ABV Plot
    output$plot3 <- renderPlotly({
      
      # Filter to selected beer type 
      abv_dat <- df %>% 
        filter(style %in% input$beer_choice,  
              if(input$state_choice != "All States") state == input$state_choice else state == state)
      
      # Make plot
      abv_plot <- plot_ly(abv_dat, y = ~abv, color = ~style, type = "box")
      abv_plot  %>% 
        layout(title = "Beer ABV")

    })
    
    # IBU Plot
    output$plot4 <- renderPlotly({
      
      # Filter to selected beer type 
      ibu_dat <- df %>% 
        filter(style %in% input$beer_choice,  
               if(input$state_choice != "All States") state == input$state_choice else state == state)
      
      # Make plot
      ibu_plot <- plot_ly(ibu_dat, y = ~abv, color = ~style, type = "box")
      ibu_plot  %>% 
        layout(title = "Beer IBU")
      
    })
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
