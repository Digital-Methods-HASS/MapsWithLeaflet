###   GETTING STARTED WITH LEAFLET

# Try to work through down this script, observing what happens in the plotting pane.

# Review favorite backgrounds in:
# https://leaflet-extras.github.io/leaflet-providers/preview/
# beware that some need extra options specified

# To install Leaflet package, run this command at your R prompt:
install.packages("leaflet")

# We will also need this widget to make pretty maps:
install.packages("htmlwidget")

# Activate the libraries
library(leaflet)
library(htmlwidgets)


########## Example with Markers on a map of Europe


# First, create labels for your points
popup = c("Robin", "Jakub", "Jannes")

# You create a Leaflet map with these basic steps: you need to run the whole chain of course
leaflet() %>%                                 # create a map widget by calling the library
  addProviderTiles("Esri.WorldPhysical") %>%  # add Esri World Physical map tiles
  addAwesomeMarkers(lng = c(-3, 23, 11),      # add layers, specified with longitude for 3 points
                    lat = c(52, 53, 49),      # and latitude for 3 points
                    popup = popup)            # specify labels, which will appear if you click on the point in the map


### Let's look at Sydney with setView() function in Leaflet
leaflet() %>%
  addTiles() %>%                              # add default OpenStreetMap map tiles
  addProviderTiles("Esri.WorldImagery",       # add custom Esri World Physical map tiles
                   options = providerTileOptions(opacity=0.5)) %>%     # make the Esri tile transparent
  setView(lng = 151.005006, lat = -33.9767231, zoom = 10)              # set the location of the map 


# Now let's refocus on Europe again
leaflet() %>% 
  addTiles() %>% 
  setView( lng = 2.34, lat = 48.85, zoom = 5 ) %>%  # let's use setView to navigate to our area
  addProviderTiles("Esri.WorldPhysical", group = "Physical") %>% 
  addProviderTiles("Esri.WorldImagery", group = "Aerial") %>% 
  addProviderTiles("MtbMap", group = "Geo") %>% 

addLayersControl(                                 # we are adding layers control to the maps
  baseGroups = c("Geo","Aerial", "Physical"),
  options = layersControlOptions(collapsed = T))

# click the box in topright corner in your Viewer 
# to select between different background layers


########## SYDNEY HARBOUR DISPLAY WITH LAYERS
# Let's create a more complicated map 

# Set the location and zoom level
leaflet() %>% 
  setView(151.2339084, -33.85089, zoom = 13) %>%
  addTiles()  # checking I am in the right area


# Bring in a choice of esri background layers  

# Create a basic basemap
l_aus <- leaflet() %>%   # assign the base location to an object
  setView(151.2339084, -33.85089, zoom = 13)

# Now, prepare to select backgrounds
esri <- grep("^Esri", providers, value = TRUE)

# Select backgrounds from among provider tiles. To view them the options, 
# go to https://leaflet-extras.github.io/leaflet-providers/preview/
for (provider in esri) {
  l_aus <- l_aus %>% addProviderTiles(provider, group = provider)
}

### Map of Sydney, NSW, Australia
# We make a layered map out of the components above and write it to 
# an object called AUSmap
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

########## SAVE THE FINAL PRODUCT

# Save map as a html document (optional, replacement of pushing the export button)
# only works in root

saveWidget(AUSmap, "AUSmap.html", selfcontained = TRUE)

###################################  YOUR TASK NUMBER ONE


# Task 1: Create a Danish equivalent of AUSmap with esri layers, 
# but call it DANmap



########## ADD DATA TO LEAFLET

# In this section you will manually create machine-readable spatial
# data from GoogleMaps: 

### First, go to https://bit.ly/CreateCoordinates1
### Enter the coordinates of your favorite leisure places in Denmark 
      # extracting them from the URL in googlemaps, adding name and type of monument.
      # Remember to copy the coordinates as a string, as just two decimal numbers separated by comma. 

# Caveats: Do NOT edit the grey columns! They populate automatically!

### Second, read the sheet into R. You will need gmail login information. 
      # watch the console, it may ask you to authenticate or put in the number 
      # that corresponds to the account you wish to use.

# Libraries
library(tidyverse)
library(googlesheets4)
library(leaflet)

# Read in a Google sheet
places <- read_sheet("https://docs.google.com/spreadsheets/d/1PlxsPElZML8LZKyXbqdAYeQCDIvDps2McZx1cTVWSzI/edit#gid=124710918",
                     col_types = "cccnncnc")
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


