library(sf)
library(dplyr)
library(ggforce)
library(ggplot2)

# Load data
points_wildfires <- st_read('data/R_vector_conafor_wildfires_2017_points_clean_en_2022-03-03.geojson')
mx_states <- st_read('data/R_vector_conafor_wildfires_2017_states_clean_en_2022-03-03.geojson')





