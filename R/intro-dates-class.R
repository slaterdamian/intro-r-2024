#### Dealing with Dates and Timezones ####

library(dplyr)
library(ggplot2)
library(lubridate)

stations <- read.csv("data/portal_stations.csv", stringsAsFactors = F)
detectors <- read.csv("data/portal_detectors.csv", stringsAsFactors = F)
data <- read.csv("data/agg_data.csv", stringsAsFactors = F)

# inspect
str(detectors)
head(detectors$start_date)

# list of acceptable timezones
OlsonNames()

# convert detectors$start_date to date/time format 
detectors$start_date <- ymd_hms(detectors$start_date) |> 
  with_tz("US/Pacific")
head(detectors$start_date)

# convert detectors$end_date to date/time format 
detectors$end_date <- ymd_hms(detectors$end_date) |> 
  with_tz("US/Pacific")
head(detectors$end_date)

# filtering to view only open detectors
open_det <- detectors |> 
  filter(is.na(end_date))
# filtering to view only closed detectors
closed_det <- detectors |> 
  filter(!is.na(end_date))
closed_det

#### Total Daily Volume, Average Volume, Average Speed per Station ----
data_stid <- data |> 
  left_join(open_det, by = c("detector_id" = "detectorid")) |>
  select(detector_id, starttime, volume, speed, countreadings, stationid)

# Convert starttime to datetime format
data_stid$starttime <- ymd_hms(data_stid$starttime) |> 
  with_tz("US/PACIFIC")

daily_data <- data_stid |> 
  mutate(date = floor_date(starttime, unit = "day")) |> 
  group_by(stationid,
           date) |> 
  summarize(
    daily_volume = sum(volume), 
    daily_ob = sum(countreadings),
    mean_speed = mean(speed)
  ) |> 
  as.data.frame() # mitigates data integrity issues (data structure changes with
                  # intermediate data transformations)

# plot data to check it out
daily_volume_fig <- daily_data |> 
  ggplot(aes(x = date, y = daily_volume)) +
  geom_line() +
  geom_point() +
  facet_grid(stationid ~., scales = "free")
daily_volume_fig

library(plotly)
ggplotly(daily_volume_fig)

# how many distinct stations exist
length(unique(daily_data$stationid))
stids <- unique(daily_data$stationid)

# new data frame for dates
start_date <- ymd("2023-03-01")
end_date <- ymd("2023-03-31")
date_df <- data.frame(
  date_seq = rep(seq(start_date, end_date, by = "1 day")),
  station_id = rep(stids, each = 31)
)

data_with_gaps <- date_df |> 
  left_join(daily_data, by = c("date_seq" = "date",
                               station_id = "stationid")
            )

# write.csv(data_with_gaps, "data/data_with_gaps.csv", row.names = F)

# this retains all transformations as compared to csv file, and high compression
saveRDS(data_with_gaps, file = "data/data_with_gaps.rds")

mod_date_fig <- data_with_gaps |> 
  filter(station_id %in% c(1056, 1057, 1059)) |> 
  ggplot(aes(x = date_seq, y = daily_volume)) +
  geom_line(aes(color = "blue")) +
  geom_point(aes(color = "skyblue")) +
  facet_grid(station_id ~ .)
mod_date_fig

mod_date_fig2 <- mod_date_fig +
  scale_x_date(date_breaks = "1 day") + # this throws error for 'as date class'
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
mod_date_fig2

mod_date_fig <- data_with_gaps |> 
  filter(station_id %in% c(1056, 1057, 1059)) |> 
  ggplot(aes(x = as.Date(date_seq), y = daily_volume)) +
  geom_line(aes(color = "blue")) +
  geom_point(aes(color = "skyblue")) +
  facet_grid(station_id ~ .) +
  scale_x_date(date_breaks = "1 day") + # fixed to as.date
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  geom_hline(yintercept = mean(daily_data$daily_volume))
mod_date_fig
