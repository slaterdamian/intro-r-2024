#### Aggregating and Summarizing Data ####

# Load packages ----
library (readxl)
library(dplyr)
library(ggplot2)

# Read in the excel file ----
df <- read_excel("Data/icebreaker_answers.xlsx")
df
summary(df)

# custom summaries of an entire data frame by column ----
df_summ <- df |> summarize(
  avg_dist = mean(travel_distance),
  sd_dist = sd(travel_distance),
  pct60_dist = quantile(travel_distance, prob = 0.6),
  avg_time = mean(travel_time)
)

# if an integer desired, must specify
df |> mutate(travel_time = as.integer(travel_time))

# assign the summary if you want to save
#   View()
df_summ <- df |> summarize(
  avg_dist = mean(travel_distance),
  sd_dist = sd(travel_distance),
  pct60_dist = quantile(travel_distance, prob = 0.6),
  avg_time = mean(travel_time)
)
# View(df_summ) same as clicking df_summ in Environment window

# Aggregating and Summarizing Subsets of a Data Frame ----
df <- df |> 
  mutate(travel_speed = travel_distance / travel_time * 60)

df |> 
  summarize(avg_speed = mean(travel_speed))

# Average speed by mode
df |> group_by(travel_mode) |>
  summarize(avg_speed = mean(travel_speed)) |> 
# sort by avg_speed
  arrange(desc(avg_speed))

# grouped by one variable
df_mode_grp <- df |>  group_by(travel_mode)
str(df_mode_grp)

# grouping by multiple variables
# Summarize groups data by next higher level, default
df_mode_grps <- df |> group_by(travel_mode, serial_comma) |> 
  summarize(avg_speed = mean(travel_speed))

# Explictly ungroup() if want to use for other things
df_mode_ungrp <- df |> group_by(travel_mode, serial_comma) |> 
  summarize(avg_speed = mean(travel_speed)) |> 
  ungroup()
df_mode_ungrp

# Frequencies, special functions/shortcuts ----
df |> group_by(serial_comma) |> 
# for "both" !recode or weight depending on how you want to transform or analyze the data
  summarize(n = n())

#replace summarize
df |> group_by(serial_comma) |> 
  tally()

#replace summarize, and group_by
df |> count(serial_comma, sort=T)

# calculate a mode split (percentage using each travel mode)
df |> count(travel_mode)

df |>  group_by(travel_mode) |> 
  summarize(split = round(n() / nrow(df) * 100)) |>
  arrange(desc(split))


