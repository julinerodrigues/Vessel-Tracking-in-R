# Load necessary libraries
library(data.table)    # For efficient data manipulation
library(dplyr)         # For data wrangling
library(geosphere)     # For geographic distance calculations
library(sf)            # For handling spatial data
library(leaflet)       # For creating interactive maps

# Step 1: Load the dataset
ais_data <- read.csv("D:/Projeto GFW/dirways_all_2018_2019.csv")

# Step 2: Inspect the dataset
# Check the structure and summary of the dataset
str(ais_data)
summary(ais_data)

# Step 3: Clean the dataset
# Remove rows with missing latitude or longitude values
ais_data <- ais_data[!is.na(ais_data$lat) & !is.na(ais_data$lon), ]

# Step 4: Sort data by vessel ID and publication time
ais_data <- ais_data %>%
  arrange(id, publishtime)

# Step 5: Calculate time differences between consecutive records
ais_data <- ais_data %>%
  group_by(id) %>%
  mutate(diff_time = as.numeric(difftime(publishtime, lag(publishtime), units = "hours")))

# Step 6: Calculate distances and average speed
# Use geosphere to calculate distance between consecutive coordinates
ais_data <- ais_data %>%
  mutate(distancia = geosphere::distVincentySphere(cbind(lon, lat), 
                                                   cbind(lag(lon), lag(lat))),
         velocidade_media = distancia / diff_time) %>%
  ungroup()

# Step 7: Select a subset of 10 vessels for visualization
selected_vessels <- ais_data %>%
  distinct(id) %>%
  slice_head(n = 10) %>%
  pull(id)  # Extract IDs

ais_data_10 <- ais_data %>%
  filter(id %in% selected_vessels)

# Step 8: Convert data to spatial points using sf
ais_data_10_sf <- st_as_sf(
  ais_data_10,
  coords = c("lon", "lat"), 
  crs = 4326  # WGS 84 coordinate reference system
)

# Step 9: Create LINESTRING geometries for vessel trajectories
ais_data_10_lines <- ais_data_10_sf %>%
  group_by(id) %>%
  summarise(do_union = FALSE) %>%
  st_cast("LINESTRING")

# Step 10: Create an interactive map with leaflet
leaflet(data = ais_data_10) %>%
  addTiles() %>%  # Add OpenStreetMap base map
  
  # Add vessel trajectories as polylines
  addPolylines(
    lng = ~lon, lat = ~lat, group = ~id, color = ~id, weight = 2, opacity = 0.8
  ) %>%
  
  # Add individual points for each record
  addCircleMarkers(
    lng = ~lon, lat = ~lat, group = ~id, radius = 3, color = ~id, opacity = 0.8,
    popup = ~paste("ID:", id, "<br>", "Latitude:", lat, "<br>", "Longitude:", lon)
  ) %>%
  
  # Add a legend for vessel IDs
  addLegend(
    position = "bottomright", title = "Vessels",
    colors = rainbow(length(unique(ais_data_10$id))),
    labels = unique(ais_data_10$id)
  )
