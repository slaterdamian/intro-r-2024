library(tidycensus) # acts as gateway to the Census API for ACS & Decenial data
                    # for more info: https://walker-data.com/tidycensus/
library(dplyr)
library(tidyr)
library(ggplot2)

#### Run on first use if not already stored in R ####
# Prompt the user to input their API key
api_key <- readline(prompt = "Please enter your API key: ")
census_api_key(api_key, install = T) # installs into R user environment
readRenviron("~/.Renviron")
####

#### User functions ####

####

