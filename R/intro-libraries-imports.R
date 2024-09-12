# Read in CSV using base R
sta_meta <- read.csv("data/portal_stations.csv", stringsAsFactors = F)

str(sta_meta) # Structure of data

head(sta_meta) # first six rows of data
tail(sta_meta) # last six rows of data

nrow(sta_meta) # number of rows
ncol(sta_meta) # number of columns

summary(sta_meta) # useful for evaluating data import
                  # (e.g.'NA' counts, MIN & MAX, etc.). Inspect data to verify.

# Using Data Import dialog to read in xlsx and copy/paste code (from history)
library(readxl)
icebreaker_answers <- read_excel("data/icebreaker_answers.xlsx")
View(icebreaker_answers)

library(dplyr)

odot_meta <- sta_meta |> # old pipe notation %>% (don't use)
  filter(
    agency == "ODOT", 
         highwayid == 1
    )
notodot_meta <- sta_meta |>
  filter(
    agency != "ODOT"
  )

# looking for NAs
nas_meta <- sta_meta |>
  filter(
    is.na(detectorlocation)
  )

# excluding NAs
real_meta <- sta_meta |>
  filter(
    !is.na(detectorlocation)
  )
