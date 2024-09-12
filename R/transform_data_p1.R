#### Transforming Data Part I ####

library(readxl)
library(dplyr)

# Load in data from Excel
df <- read_excel("data/icebreaker_answers.xlsx")
df
tail(df)

df <- df |> bind_rows(slice_tail(df)) # take last row and add to end of df
tail(df)

df <- df |> distinct() # returns only 1 unique row per set of values
tail(df)

# selecting columns
df |> select(travel_mode, travel_distance, travel_time)

df |> select(-serial_comma) # drop one column

df |> select(travel_mode:travel_distance) # group of columns from start to end

df |> select(starts_with("travel_")) # selecting by expression

df_travel <- df |> select(-serial_comma)

# mutate and rename ----
# (creating and modifying data frames)
# mutate to add calculated columns
df_travel$travel_speed <- (df_travel$travel_distance / 
                             df_travel$travel_time * 60) #mph

df_travel

df_travel <- df_travel |>
  mutate(travel_speed = round(travel_distance / travel_time * 60))
summary(df_travel)

# If just renaming ----
df_travel <- df_travel |> 
  rename(travel_mph = travel_speed) # travel_mph is new name with values from
colnames(df_travel)                 # travel_speed
df_travel

# if/else and case when logic ----
#adding logic to mutate
# if/else ----
df_travel <- df_travel |> 
  mutate(long_trip = if_else(travel_distance > 20,
                             1, 0))
df_travel

# case when
table(df_travel$travel_mode) 
df_travel <- df_travel |>
  mutate(slow_trip = 
           case_when(
             travel_mode == "bike" & travel_mph < 12 ~ 1,
             travel_mode == "car" & travel_mph < 25 ~ 1,
             travel_mode == "bus" & travel_mph < 15 ~ 1,
             travel_mode == "light rail" & travel_mph < 20 ~ 1,
             travel_mode == "street car" & travel_mph < 15 ~ 1,
             .default = 0 # all FALSE or NA
           ))
df_travel

# arrange to order output
df_travel |> arrange(travel_mph) |> print(n=25) # from slowest to fastest

df_travel |> arrange(travel_mode, travel_mph) |> print(n=25)

df_travel |> arrange(desc(travel_mph)) |> print(n=25)

boxplot(df_travel$travel_mph ~ df_travel$long_trip)