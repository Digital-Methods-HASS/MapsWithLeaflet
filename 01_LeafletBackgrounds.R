###   GETTING STARTED WITH LEAFLET


## Choose favorite backgrounds in:
# https://leaflet-extras.github.io/leaflet-providers/preview/
## beware that some need extra options specified

# Packages
install.packages("leaflet")
install.packages("htmlwidget")

# Example with Markers on a map of Europe
library(leaflet)
library(htmlwidgets)

# Create labels for your points
popup = c("Robin", "Jakub", "Jannes")

# We create a tidyverse-style pipeline
leaflet() %>%                                 # call the library
  addProviderTiles("Esri.WorldPhysical") %>%  # background images
 #addProviderTiles("Esri.WorldImagery") %>% 
  addAwesomeMarkers(lng = c(-3, 23, 11),      # longitude for 3 points
                    lat = c(52, 53, 49),      # latitude for 3 points
                    popup = popup)            # labels


## Let's look at Sydney with setView() function in Leaflet
leaflet() %>%
  addTiles() %>%                # default background, no selections
  addProviderTiles("Esri.WorldImagery", 
                   options = providerTileOptions(opacity=0.5)) %>% # make this new tile transparent
  setView(lng = 151.005006, lat = -33.9767231, zoom = 10) # note the 


# Europe with Layers: run lines 37 - 46 and 
# click the box in topright corner in your Viewer
leaflet() %>% 
  addTiles() %>% 
  setView( lng = 2.34, lat = 48.85, zoom = 5 ) %>%  # let's use setView to navigate to our area
  addProviderTiles("Esri.WorldPhysical", group = "Physical") %>% 
  addProviderTiles("Esri.WorldImagery", group = "Aerial") %>% 
  addProviderTiles("MtbMap", group = "Geo") %>% 

addLayersControl(
  baseGroups = c("Geo","Aerial", "Physical"),
  options = layersControlOptions(collapsed = T))

# note that you can feed plain Lat Long columns into Leaflet
# without having to convert into spatial objects (sf), or projecting


########################## SYDNEY HARBOUR DISPLAY WITH LAYERS

# Set the location and zoom level
leaflet() %>% 
  setView(151.2339084, -33.85089, zoom = 13) %>%
  addTiles()  # checking I am in the right area


# Bring in a choice of esri background layers  

# create basemap
l_aus <- leaflet() %>%   # assign the base location to an object
  setView(150.314, -33.74, zoom = 13)

# prepare to select backgrounds
esri <- grep("^Esri", providers, value = TRUE)

# actually select backgrounds from among provider tiles, to see more, 
# go to https://leaflet-extras.github.io/leaflet-providers/preview/
for (provider in esri) {
  l_aus <- l_aus %>% addProviderTiles(provider, group = provider)
}

### Map of Katoomba and Blue Mountains National Park in NSW, Australia
# make a layered map out of the components above and write it to 
# AUSmap object
AUSmap <- l_aus %>%
  addLayersControl(baseGroups = names(esri),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addMiniMap(tiles = esri[[1]], toggleDisplay = TRUE,
             position = "bottomright") %>%
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>% 
  htmlwidgets::onRender("
                        function(el, x) {
                        var myMap = this;
                        myMap.on('baselayerchange',
                        function (e) {
                        myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
                        })
                        }") %>% 
addControl("", position = "topright")

# run this to see your product
AUSmap

################################## SAVE FINAL PRODUCT

# Save map as a html document (optional, replacement of pushing the export button)
# only works in root

saveWidget(AUSmap, "AUSmap.html", selfcontained = TRUE)

###################################   TASK ONE


# Task 1: Create a Danish equivalent of AUSmap with esri layers, 
# but call it DANmap



################################## ADD DATA TO LEAFLET
# In this section you will manually create machine-readable spatial
# data from GoogleMaps: Go to https://bit.ly/CreateCoordinates1
# and enter the coordinates of your favorite leisure places in Denmark 
# from URL in googlemaps to the table, providing a name and type of monument and 
# classificaiton following the example at the top (no spaces, no extra interpunction, 
# just two decimal numbers separated by comma). 

# Caveats: Do NOT edit the grey columns! They populate automatically!


# When done, read the sheet into R. You need a gmail login information 
# watch the console, it may ask you to authenticate or put in the number 
# that corresponds to the account you wish to use.

# Libraries
library(tidyverse)
library(googlesheets4)
library(leaflet)

# read in the sheet
places <- read_sheet("https://docs.google.com/spreadsheets/d/1PlxsPElZML8LZKyXbqdAYeQCDIvDps2McZx1cTVWSzI/edit#gid=124710918",col_types = "cccnncn")
glimpse(places)

# load the coordinates in the map and check: are any points missing? Why?
leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = places$Longitude, 
             lat = places$Latitude,
             popup = places$Description)

#########################################################


# Task 2: Read in the googlesheet data you and your colleagues 
# populated with data into the DANmap object you created in Task 1.

# Task 3: Can you cluster the points in Leaflet? Google "clustering options in Leaflet"

# Task 4: Look at the map and consider what it is good for and what not.

# Task 5: Find out how to display notes and classifications in the map.



# The googlesheet is at https://docs.google.com/spreadsheets/d/1PlxsPElZML8LZKyXbqdAYeQCDIvDps2McZx1cTVWSzI/edit#gid=0
#########################################################
# HW solution for RC data
rc <- read_csv("data/RCFeature.csv")
glimpse(rc)
rc <- rc %>% filter(!is.na(Longitude))

AUSmap %>%  # adjust view to Katoomba 150.314, -33.74
  addCircleMarkers(lng = rc$Longitude, 
             lat = rc$Latitude,
             popup = paste0("FeatureID: ", rc$FeatureID))
            # clusterOptions = markerClusterOptions())
