##################################################
# Shiny App Tutorial : Data Cleaning 
##################################################

rm(list = ls())

## Libraries 
library(tidyverse)
library(tigris)

## Datasets 
beers <- read.csv("~/Desktop/Files/Shiny App Tutorial/Data/beers.csv")[,-1]
breweries <- read.csv("~/Desktop/Files/Shiny App Tutorial/Data/breweries.csv")

## Combine datasets 
beers$brewery <- breweries$name[match(beers$brewery_id, breweries$X)]
beers$state <- breweries$state[match(beers$brewery_id, breweries$X)]
beers$city <- breweries$city[match(beers$brewery_id, breweries$X)]

# Add county
temp <- tempfile()
download.file("http://download.geonames.org/export/zip/US.zip",temp)
con <- unz(temp, "US.txt")
US <- read.delim(con, header=FALSE)
unlink(temp)
colnames(US)[c(3,5,6)] <- c("city","state","county")
US$city <- tolower(US$city)
beers$city <- tolower(beers$city)
US <- US[,c(3,5,6)]
beers$state <- gsub(" ", "", beers$state, fixed = TRUE)
beers <- merge(beers, US, by = c("city", "state"))
beers <- beers[!duplicated(beers),]

## Add fips state codes
data("fips_codes")
fips_codes$county <- gsub(" County", "", fips_codes$county, fixed = TRUE)
beers$county <- gsub("(", "", beers$county, fixed = TRUE)
beers$county <- gsub(")", "", beers$county, fixed = TRUE)
fips_codes$fips <- paste0(fips_codes$state_code, fips_codes$county_code)
fips_codes <- fips_codes[,c("state", "county", "fips")]
# beers$fips <- fips_codes$fips_codes[match(paste(beers$county, "County"), fips_codes$county)]
beers$county <- tolower(beers$county)
fips_codes$county <- tolower(fips_codes$county)
beers <- merge(beers, fips_codes, by = c("state", "county"), all.x = TRUE)
beers <- beers[!duplicated(beers),]
beers$fips <- ifelse(beers$county == "kenai peninsula", "02122", 
                    ifelse(beers$county == "city and county of san francisco", "06075", 
                    ifelse(beers$county == "saint johns", "12109", 
                    ifelse(beers$city == "new orleans", "22071", 
                    ifelse(beers$county == "st. tammany" & beers$state == "LA", "22103", 
                    ifelse(beers$county == "city of richmond", "51760", 
                    ifelse(beers$county == "city of suffolk", "51800", beers$fips)))))))

## Clean Up Style 
beers$style <- ifelse(grepl("IPA", beers$style), "IPA",  
               ifelse(grepl("APA", beers$style), "APA", 
               ifelse(grepl("Pale Ale", beers$style), "Pale Ale",
               ifelse(grepl("Ale", beers$style), "Other Ale",
               ifelse(grepl("Lager", beers$style), "Lager", 
               ifelse(grepl("Stout", beers$style), "Stout", 
               ifelse(grepl("Porter", beers$style), "Porter",
               ifelse(grepl("Pilsner", beers$style), "Pilsner",
               ifelse(grepl("Pilsener", beers$style), "Pilsner",
               ifelse(grepl("Cider", beers$style), "Cider",
               ifelse(beers$style %in% c("Berliner Weissbier", "Maibock / Helles Bock", "Kölsch", "Keller Bier / Zwickel Bier", 
                                         "Märzen / Oktoberfest", "Hefeweizen", "Schwarzbier", "Rauchbier", "Dunkelweizen", 
                                         "Witbier", "Kristalweizen", "Roggenbier", "Bock", "Altbier", "Gose", "Doppelbock"), "German", 
               ifelse(beers$style %in% c("Flanders Oud Bruin", "Fruit / Vegetable Beer", "Quadrupel (Quad)", "Winter Warmer",
                                         "Dubbel", "Tripel", "Grisette"), "Belgian", "Other"))))))))))))


## Make ABV % 
beers$abv <- beers$abv*100

## Save datafile 
saveRDS(beers, "~/Desktop/Files/Shiny App Tutorial/Data/beers_clean.rds")
