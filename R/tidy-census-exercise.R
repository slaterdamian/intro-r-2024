library(tidycensus) # acts as gateway to the Census API for ACS & Decenial data
                    # for more info: https://walker-data.com/tidycensus/
library(dplyr)
library(tidyr)
library(ggplot2)

#### Run on first use if not already stored in R ####
# Prompt the user to input whether they already have a Census API key saved
ext_key <- readline(prompt = "Do you already have a Census API key saved? (Y/N): ")
answ <- toupper(ext_key)  # Convert the answer to uppercase to handle 'y' or 'Y'

# Proceed if 'answ' is 'N', otherwise skip API key entry
if (answ == "N") {
  # Prompt the user to input their API key
  api_key <- readline(prompt = "Please enter your Census API key: ")
  
  # Save the API key to the user's R environment using census_api_key
  census_api_key(api_key, overwrite = TRUE, install = TRUE)  # Installs into R user environment
  
  cat("API key has been saved.\n")
} else {
  cat("Proceeding without entering a new API key.\n")
}
readRenviron("~/.Renviron")

####

#### User functions ####

####

# get searchable census variable table
v19 <- load_variables(2019, "acs5")
v19 |> filter(grepl("^B08006_", name)) |> 
  print(n=25)

#get the data for transit, work-from-home, and total workers ----
comm_19_raw <- get_acs(geography = "tract",
                       variables = c(wfh = "B08006_017",
                                     transit = "B08006_008",
                                     tot = "B08006_001"),
                       county = "Benton",
                       state = "OR",
                       year = 2019,
                       survey = "acs5",
                       geometry = FALSE) # can retrieve spatial geometries 
                                         # pre-joined (SF package)
comm_19_raw (n=41)

#
comm_19 <- comm_19_raw |> 
  pivot_wider(id_cols = GEOID:NAME,
              names_from = variable,
              values_from = estimate:moe)
comm_19


