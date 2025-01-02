library(sf)
library(magrittr)
library(tidyverse)
library(leaflet)

url <- "https://services.arcgis.com/3SZ6e0uCvPROr4mS/arcgis/rest/services/Wessex_Water_Storm_Overflow_Activity/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson"

# Read the GeoJSON to get latest data
dis <- st_read(url)

# Transform

dis %<>% 
  mutate(across(all_of(c("StatusStart", "LatestEventStart", "LatestEventEnd", "LastUpdated")), ~ as_datetime(. / 1000))) 
 # drop_na(c("StatusStart", "LatestEventStart", "LatestEventEnd", "LastUpdated"))


# Normal functioning without discharge = 0
# Discharging CSO = 1
# Offline CSO = -1
 
wsx <- read_sf("/dbfs/mnt/lab/unrestricted/harry.gray@environment-agency.gov.uk/Interim_WFD_2022.shp") %>% 
          st_transform(4326)
wsx_outline <- st_union(wsx)


