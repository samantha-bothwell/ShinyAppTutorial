# Craft Breweries and Beers Shiny App Tutorial

This is a Shiny App Tutorial put together for the Department of Biostatistics at CU Anschutz Seminar on 11/9/22. This app uses the Craft Breweries and Beers dataset from https://www.kaggle.com/datasets/nickhould/craft-cans.

## Setting Up the R Workspace

To begin, create a folder that will house your app code and data file. You can either use the skeleton code, provided in the Shiny_Skeleton folder, and build the app manually or refer to my completed app in the Shiny_Complete folder. Once you download the folder, you'll want to change the folder's name as it will be the domain name for the app. 

You can also start your Shiny App from scratch within R. Select 'File > New File > Shiny Web App...'. 

![](README_files/create-app.png =100x20)<!-- -->

The following are the packages we will use within the app. 

``` r
## Libraries 
library(shinythemes)
library(plotly)
library(tidyverse)
library(usmap)
library(viridis)
library(ggplot2)
library(ggrepel)
```

To read in the data, don't include a path to a directory. The dataset just needs to be within the folder 

## Connecting the App a
Create an account at https://www.shinyapps.io/


