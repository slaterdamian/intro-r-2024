#### Practice Problem: Loading and manipulating a data frame ####
# Don't forget: Comment anywhere the code isn't obvious to you!

# Load the readxl and dplyr packages
library(readxl,
        dplyr)

# Use the read_excel function to load the class survey data
class_survey <- read_excel("Data/icebreaker_answers.xlsx")

# Take a peek!
head(class_survey)
tail(class_survey)

# Create a travel_speed column in your data frame using vector operations and 
#   assignment
class_speed <- class_survey |> mutate(
  travel_speed_mph = round(travel_distance/(travel_time/60))
)

# Look at a summary of the new variable--seem reasonable?
summary(class_speed)

# Choose a travel mode, and use a pipe to filter the data by your travel mode
transit <- class_speed |> filter (
  travel_mode == "bus"|
    travel_mode == "light rail"|
    travel_mode == "train"|
    travel_mode == "streetar"
)
# Note the frequency of the mode (# of rows returned)
nrow(transit)

# Repeat the above, but this time assign the result to a new data frame
transit_df = data.frame(class_survey |> filter (
  travel_mode == "bus"|
    travel_mode == "light rail"|
    travel_mode == "train"|
    travel_mode == "streetar"
)
)

# Look at a summary of the speed variable for just your travel mode--seem 
#   reasonable?
summary(transit_df)

# Filter the data by some arbitrary time, distance, or speed threshold
slow <- class_speed |> filter (
  travel_speed_mph < 25
)

slow

# Stretch yourself: Repeat the above, but this time filter the data by two 
#   travel modes (Hint: %in%)
slower <- class_speed |> filter (
  travel_mode %in% "light rail"|
    travel_mode %in% "bike" &
  travel_speed_mph < 25
)
slower
