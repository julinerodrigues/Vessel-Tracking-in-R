# **Vessel Tracking in R**

An exploratory exercise in vessel tracking using real-world AIS (Automatic Identification System) data from the Baltic Sea. This project demonstrates:

- Cleaning and preprocessing vessel data.
- Calculating distances and average speeds based on AIS coordinates and timestamps.
- Visualizing vessel trajectories and movements using **R** libraries:
  - `leaflet` for interactive mapping.
  - `sf` for spatial data processing.

## **Key Features**
- Calculates time differences, distances, and speeds for vessel movements.
- Filters and visualizes selected vessel trajectories.
- Creates an interactive map displaying vessel paths and positions.

## **Technologies Used**
- **Data Manipulation**: `dplyr`, `data.table`
- **Geospatial Calculations**: `geosphere`
- **Spatial Data Handling**: `sf`
- **Interactive Visualization**: `leaflet`

## **Dataset**
- Real AIS data from the Baltic Sea (data anonymized for this exercise).

## **Getting Started**
Clone the repository and run the provided R script to reproduce the results. Ensure the following libraries are installed:
```r
install.packages(c("dplyr", "data.table", "geosphere", "sf", "leaflet"))
```

