library(tidycensus) # acts as gateway to the Census API for ACS & Decenial data
                    # for more info: https://walker-data.com/tidycensus/
library(dplyr)
library(tidyr)
library(ggplot2)

#### Run on first use if not already stored in R ####
census_api_key("myCensusAPIKey", install = T) # installs into R user environment
readRenviron("~/.Renviron")