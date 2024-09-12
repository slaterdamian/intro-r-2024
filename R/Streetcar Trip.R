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

leaflet(trip_prof) |>
  addTiles() |>
  addPolylines(
    lng = ~long, lat = ~lat,  
    color = ~ifelse(speed > 20, "green", ifelse(speed > 10, "blue", "red")),  # Color based on speed
    weight = ~ifelse(speed > 20, 6, ifelse(speed > 10, 4, 2)),  # Line weight based on speed
    opacity = 0.8,  # Transparency of the line
    label = ~paste("Speed:", speed, "mi/h")  # Tooltip showing speed at each point
  ) |>
  addLegend(
    "topright",
    colors = c("green", "blue", "red"),  # Corresponding colors for speed ranges
    labels = c("> 20 mi/h", "10 - 20 mi/h", "<= 10 mi/h"),  # Speed ranges
    opacity = 0.8
  )

#### ? ####
# Clean the dataset by removing rows with missing lat/long values
trip_prof_clean <- trip_prof |>
  dplyr::filter(!is.na(long), !is.na(lat), !is.na(speed))

# Define a color palette: light colors for lower speeds, dark colors for higher speeds
color_pal <- colorNumeric(palette = "YlOrRd", domain = c(1, 20))  # Yellow to red gradient

# Initialize leaflet map
map <- leaflet() |>
  addTiles()

# Iterate over each pair of consecutive points and add a polyline
for (i in 1:(nrow(trip_prof_clean) - 1)) {
  
  # Calculate the median speed between the two points
  median_speed <- median(c(trip_prof_clean$speed[i], trip_prof_clean$speed[i+1]))
  
  # Assign color based on the continuous color scale
  color <- color_pal(median_speed)
  
  # Add the polyline for the segment
  map <- map |>
    addPolylines(
      lng = c(trip_prof_clean$long[i], trip_prof_clean$long[i+1]),
      lat = c(trip_prof_clean$lat[i], trip_prof_clean$lat[i+1]),
      color = color,
      opacity = 0.8,
      label = paste("Median Speed:", round(median_speed, 2), "mi/h")
    )
}

# Add a legend to the map with the continuous color scale
map <- map |>
  addLegend(
    "topright",
    pal = color_pal,
    values = trip_prof_clean$speed,  # The full range of speeds to be displayed in the legend
    title = "Speed (mi/h)",
    opacity = 0.8
  )

# Display the map
map