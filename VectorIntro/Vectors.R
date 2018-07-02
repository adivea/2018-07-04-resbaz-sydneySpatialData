## 06  VECTOR DATA

# Prerequisites

install.packages("raster") # should have these from previous session
install.packages("sf")

# Load packages

library(raster)
library(sf)

# if sf is not working, get help!

# Setup workspace

getwd()
setwd("PATH TO DIRECTORY")

# Read in a shapefile

aoi <- st_read("./HARV/HarClip_UTMZ18.shp")

# Metadata
st_geometry_type(aoi)
st_crs(aoi)
st_bbox(aoi)
aoi
class(aoi)

#what methods can be applied?

methods(class="sf")

ncol(aoi)
data.frame(aoi)
head(data.frame(plot_locations_HARV))


# Plot the shapefile

plot(aoi, lwd = 2, col = "cyan1", border = "black", main = "AOI boundary")

# Add other shapefiles
lines <- st_read("./HARV/HARV_roads.shp")
points <- st_read("./HARV/HARVtower_UTM18N.shp")

# Plot all together
plot(lines, col="red", add = TRUE)
plot(points, pch=19, cex = 2, col= "gold", add = TRUE)

# Plot aoi, tower and canopy height model
chm_HARV <- raster("./../RasterIntro/HARV/CHM/HARV_chmCrop.tif")
crs(chm_HARV)
st_bbox(chm_HARV)

plot(chm_HARV,
     main = "Map of Study Area\n w/ Canopy Height Model\nNEON Harvard Forest Field Site")

plot(aoi, col = "grey", add = TRUE)

plot(lines,
     add = TRUE,
     col = "black")

plot(aoi, 
     add = TRUE,
     col = "grey")

plot(points, pch=19, cex = 2, col= "purple", add = TRUE)


###   07 EXPLORE ATTRIBUTES

lines <- st_read("./HARV/HARV_roads.shp")
points <- st_read("./HARV/HARVtower_UTM18N.shp")

dim(data.frame(points))
ncol(boundary)
names(lines)
names(points) # Country
head(points$Ownership)
summary(points$O)
lines
points

###   EXPLORE VALUES WITHIN ONE ATTRIBUTE
head(data.frame(lines), n=3)
names(lines)
lines$TYPE
levels(lines$TYPE)

#select a value of choice
lines[lines$TYPE == "footpath",]
footpath <- lines[lines$TYPE == "footpath",]
nrow(footpath)

plot(footpath$geometry,
     lwd = 3, 
     col = c("blue", "green"),
     main = "NEON HARVARD Forest Field site footpaths, \n boardwalks,\n and \n stone walls\n")

# subset more variables and plot

boardwalk <- lines[lines$TYPE == "boardwalk",]
nrow(boardwalk)
nrow(lines)

stonewall <- lines[lines$TYPE == "stone wall",]
nrow(stonewall)

plot(boardwalk$geometry, lwd = 2, col = "red", add = TRUE)
plot(stonewall$geometry, lwd = 2, col = topo.colors(6), add= TRUE)


# plot lines by attribute value
# value field needs to be a factor. Determine number of levels and create a color vector

class(lines$TYPE)
levels(lines$TYPE)
summary(lines$TYPE)
roadPalette <- c("blue", "green", "pink", "purple") ## preparation for a legend

# change symbology by trail type
roadColors <- c("blue", "green", "pink", "purple")[lines$TYPE]
roadColors

plot(lines$geometry, col = roadColors, lwd = 3, main = "Harvard forest roads and trails")

# plot trail thickness by type
lineWidth <- c(1,2,3,4)[lines$TYPE]

plot(lines$geometry, 
     col = roadColors, 
     lwd = lineWidth, 
     main = "Harvard forest roads and trails")

lineWidth <- c(2,4,3,8)[lines$TYPE]

# create a legend
legend("bottomright", 
       levels(lines$TYPE), 
       fill = roadPalette, 
       bty ="n", 
       cex = 2)

# Change colors in the plot I

newColors <- c("springgreen", "blue", "magenta", "orange")
newColors

plot(lines$geometry, 
     col = newColors, 
     lwd = lineWidth, 
     main = "Harvard forest roads and trails")

legend("bottomright", 
       levels(lines$TYPE), 
       fill = newColors, 
       bty ="n", 
       cex = 2)


# Change colors in the plot II

plot(lines$geometry, 
     col = palette(rainbow(6)), 
     lwd = lineWidth, 
     main = "Harvard forest roads and trails")

legend("bottomright", 
       levels(lines$TYPE), 
       fill = palette(rainbow(6)), 
       bty ="n", 
       cex = 2)

# 07 Lines Final Exercise
# emphasise horse trails 

names(lines)
levels(lines$BIKEHORSE)
levels(lines$BIKEHORSE)
summary(lines$BIKEHORSE)

lines_removeNA <- lines[na.omit(lines$BIKEHORSE),]
levels(lines_removeNA$BIKEHORSE)


lines_removeNA$BIKEHORSE
horsecol <- c("black", "green")[lines_removeNA$BIKEHORSE]
horsecol

horsewidth <- c(2, 2)[lines$BIKEHORSE]

plot(lines$geometry, 
     col = horsecol, 
     lwd = horsewidth, 
     main = "Harvard forest horse friendlytrails")

legend("bottomright", 
       levels(lines$BIKEHORSE),
       fill = c("black", "green"), 
       bty ="n", 
       cex = 2)

# with other attribute
summary(lines$BicyclesHo)
class(lines$BicyclesHo)
levels(lines$BicyclesHo)

# lines_noNA <-lines[na.omit(lines$BicyclesHo),]  # it seems to suck away not allowed values too!!
levels(lines_noNA$BicyclesHo)
summary(lines_noNA$BicyclesHo)

horcol <- c("black", "magenta")[lines$BicyclesHo]
horcol

horwidth <- c(2, 2)[lines$BicyclesHo]

plot(lines$geometry, 
     col = horcol, 
     lwd = horwidth, 
     main = "Harvard forest horse friendlytrails")

legend("bottomright", 
       levels(lines$BicyclesHo)[1:2],
       fill = c("black", "magenta"), 
       bty ="n", 
       cex = 1)


## 07 FINAL CHALLENGE

## Plot map of USA colored by 'region' attribute

usa <- st_read("US-Boundary-Layers/US-State-Boundaries-Census-2014.shp")
names(usa)
class(usa$region)
length(levels(usa$region))

#regionCol <- c("blue", "pink", "yellow", "cyan", "magenta")[usa$region]
regionCol <- terrain.colors(5)[usa$region]

plot(usa$geometry, 
     col = regionCol)
legend("bottomleft", 
      levels(usa$region), 
      #horiz = TRUE, 
      fill = terrain.colors(5))

# Plot locations by Soil type

names(locations)
plot(locations)
locations$soilTypeOr <- as.factor(locations$soilTypeOr)
length(levels(locations$soilTypeOr))


soiltypeCol <- c("cyan", "purple")[locations$soilTypeOr]
soilsize <- c(1,2)[locations$soilTypeOr]

plot(locations$geometry, 
     col = soiltypeCol, 
     lwd = soilsize)

####    PLOTTING
# plot
plot(aoi)
plot(aoi, lwd = 3, col = "cyan", border = "purple", main = "aoi")
plot(lines, add = TRUE)
plot(points, add = TRUE)


plot(lines)
plot(points, add = TRUE, cex=3, pch = 19, col = "black")
plot(pointnew, add = TRUE, col= "red")

st_buffer()
summary(points)
summary(lines)
pointnew <- st_buffer(points, 100)



#### BUFFERS NOT IN SWC LESSON
#####   Play with buffers (NOT IN SWC lesson)

aoi2 <- st_buffer(aoi$geometry,100)
st_bbox(aoi)
st_bbox(aoi2)
st_bbox(aoi3)
aoi3 <- st_buffer(aoi, -100)
aoi4 <- st_buffer(aoi3, -100)

aoi2  # this buffer is behaving funny - reading as a geometry and not simple feature 
st_write(aoi2, "boundary100buffer.shp") # converting it to shapefile will make it sf
aoi2 <- st_read("boundary100buffer.shp") # now it plots properly and works with other buffers
aoi
aoi3
plot(aoi2$geometry)
plot(aoi$geometry, col = 'cyan')
#plot(aoi$geometry, col = "red", add = TRUE)
plot(aoi3$geometry, col = "pink", add = TRUE)
plot(aoi4$geometry, col="black", add = TRUE)

