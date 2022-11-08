# Craft Breweries and Beers Shiny App Tutorial

This is a Shiny App Tutorial put together for the Department of Biostatistics at CU Anschutz Seminar on 11/9/22. This app uses the Craft Breweries and Beers dataset from https://www.kaggle.com/datasets/nickhould/craft-cans.

## Creating Your Shiny App

To begin, create a folder that will house your app code and data file. You can either use the skeleton code, provided in the `Shiny_Skeleton` folder, and build the app manually or refer to my completed app in the `Shiny_Complete` folder. Once you download the folder, you'll want to change the folder's name as it will be the domain name for the app. 

You can also start your Shiny App from scratch within R. Select 'File > New File > Shiny Web App...'. We are going to use a single 'app.R' file for this tutorial. For more complicated apps, it's recommended to use a separate 'server.R' and 'ui.R' file. 

<p align="center">
  <img src="README_files/create-app.png" width="700">
</p>

Each Shiny App is comprised of a `ui` and a `server` component. 

* `ui` : The user interface defines how the app will look, including color theme, sidebar panel options, tab layouts, and figure/text layouts. 
* `server` : The server contains the instructions to create the app. This is where you can build plots for the app.


## Setting Up the App Workspace

The following are the packages we will use within the app. 

``` r
## Libraries 
library(shiny)
library(shinythemes)
library(plotly)
library(tidyverse)
library(usmap)
library(viridis)
library(ggplot2)
library(ggrepel)
```

To read in the data, don't include a path to a directory. The dataset just needs to be within the folder. 

``` r 
## Data
df <- readRDS("beers_clean.rds")
```

The basic skeleton of any Shiny App will be 

``` r 
library(shiny) 

# Define UI ----
ui <- fluidPage(
  
)

# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
```

When you're ready, you can run even an empty ShinyApp either by running 

``` r 
runApp("App Name")
```

or by clicking the `Run App` button at the top of your R window

<p align="center">
  <img src="README_files/run-app.png" width="700">
</p>

*https://shiny.rstudio.com/tutorial/written-tutorial/lesson1/*

## Designing the UI

### Theme and Title 

One fun customization you can make within your Shiny App is the theme. I have a preference for the `flatly` theme. You can explore more theme options at https://rstudio.github.io/shinythemes/.

Each application needs a title, which you can specify with the `titlePanel` function. 

``` r
# Set theme
theme = shinytheme("flatly"),

# Application title
titlePanel("US Beers and Breweries"),
    
```

### Sidebar Design

The Sidebar panel can be customized in a number of ways, referred to as [widgets](https://shiny.rstudio.com/tutorial/written-tutorial/lesson3/). 

<p align="center">
  <img src="README_files/sidebar-opts.png" width="700">
</p>

*http://juliawrobel.com/tutorials/shiny_tutorial_nba.html*

In our app, we are going to have two types of selections; a drop down list for the state and a multiple selection radio button for beer type. We will specify this in our `ui` code with the following 

``` r 
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
```

This code produces the following sidebar, which has an option for "All States" and lists each individual state and has all beer types selected. 

<p align="center">
  <img src="README_files/sidebar-config.png" width="500">
</p>

In the `sidebarLayout` function, we can also specify the Tabs and which plots will belong to each Tab. For our app, we'll have 3 tabs : 

* Brewery Density : A heatmap of brewery counts for the entire US, if "All States" is selected, or counties within a State. 
* Beer Types : A pie chart of the proportion of beer types within the entire US or an individual state.
* ABV and IBU : Boxplots of ABV and IBU by beer type across the entire US or an individual state. Here, you can select which beer types you want to look at. 

We'll wrap up the `sidebarLayout` function with the following code 

``` r
        mainPanel(
            navbarPage(" ",
                 tabPanel("Brewery Density", plotOutput('plot1')),
                 tabPanel("Beer Types", plotlyOutput('plot2', width = "800px", height = "800px")),
                 tabPanel("ABV and IBU", plotlyOutput('plot3'), plotlyOutput('plot4'))
            )
        )
    )
```

Notice that in each tabPanel, we specify the plot that will go on that tab. If it's a regular `plot` or `ggplot` object, you can use `plotOutput`. If it is a `plotly` object, as we have for the 2nd and 3rd tabs, you will need to use `plotlyOutput`. In this function, you can also specify the width and height of the plot. We end up with the following panels : 

<p align="center">
  <img src="README_files/panels.png" width="500">
</p>

### Plot Design

## Designing the Server

Before setting code up in the server, I usually run it within an R script to make sure everything works well. It's easier to modify your code outside of the app then when you're working within the server code. 

## Connecting the App a
Create an account at https://www.shinyapps.io/


