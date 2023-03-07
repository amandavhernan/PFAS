library(tidyverse)
library(dplyr)
library(leaflet)
library(leaflet.extras)
library(shiny)

pfas_water_sites <- read_csv("pfas_water_sites_cleaned.csv")

pfas_water_sites %>%
  leaflet() %>%
  addTiles() %>%
  addHeatmap(lng=pfas_water_sites$longitude, lat=pfas_water_sites$latitude, blur=15, max=60, radius=15)