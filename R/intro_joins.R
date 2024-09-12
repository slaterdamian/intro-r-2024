library(dplyr)
library(ggplot2)

# import data sets 
detectors <- read.csv("data/portal_detectors.csv", stringsAsFactors = F)
stations <- read.csv("data/portal_stations.csv", stringsAsFactors = F)
data <- read.csv("data/agg_data.csv", stringsAsFactors = F)

head(data)
table(data$detector_id)

data_detectors <- data |>
  distinct(detector_id)

data_detectors_meta <- data_detectors |>
  left_join(detectors, by = c("detector_id" = "detectorid"))

data_detectors_missing <- detectors |>
  anti_join(data_detectors, by = c("detectorid" = "detector_id")) |>
  distinct(detectorid)

# join from data_detectors_meta to join with the stations metadata
# you need the stations metadata for the detectors that there is data for

data_detectors_sta <- data_detectors_meta |> # my code
  left_join(stations, by = c("locationtext"))

data_stations <- data_detectors_meta |>
  select(detector_id, stationid) |>
  left_join(stations, by = "stationid")
  
data_stations
