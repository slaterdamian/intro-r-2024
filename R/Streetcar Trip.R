library(dplyr)
library(ggplot2)
install.packages("leaflet")
library(leaflet)
library(ggmap)

trip_prof <- read.csv("data/streetcar_trip_20240912_0809.csv")  
lat <- trip_prof$Lat
long <- trip_prof$Lon
speed <- trip_prof$Speed.Data..miles.hour.

# Create a leaflet map and add markers
leaflet(trip_prof) |>
  addTiles() |>  # Add default OpenStreetMap tiles
  addMarkers(~long, ~lat, popup = ~speed)  # Add markers with popups

leaflet(trip_prof) |>
  addTiles() |>
  addCircleMarkers(
    ~long, ~lat, 
    color = ~ifelse(speed > 20, "green", ifelse(speed > 10, "blue", "red")),  # Nested ifelse for color
    label = ~paste("Speed:", speed, "mi/h")
  ) |>
  addLegend(
    "topright", 
    colors = c("green", "blue", "red"),  # Corrected colors to match the condition
    labels = c("> 20 mi/h", "10 - 20 mi/h", "<= 10 mi/h")  # Updated labels to reflect the speed ranges
  )
                   