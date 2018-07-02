## LESSON 10: VECTOR DATA FROM CSV

#Necessary prerequisites

install.packages("raster") # should have these from previous session
install.packages("sf")

#load packages

library(raster)
library(sf)

#workspace
getwd()
setwd("./../../NEONDSSiteLayoutFiles/NEON-DS-Site-Layout-Files/")

#load csv
plot_locations_HARV <- read.csv("HARV/HARV_PlotLocations.csv", stringsAsFactors = FALSE)

str(plot_locations_HARV)
colnames(plot_locations_HARV)
tail(plot_locations_HARV[,1:2])


#find WGS84 UTM18n projection online
p <- CRS("+proj=utm +zone=18 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")

# extract the projection from existing data
st_crs(lines)


st_crs(p)
st_bbox(lines)
utm18nCRS <- st_crs(lines)
utm18nCRS

# convert csv to sf object

locations <- st_as_sf(plot_locations_HARV, coords=c("easting", "northing"), crs = utm18nCRS)
st_crs(locations)
plot(locations$geometry, main = "Map of Locations")


# note the problems with using p for CRS assignment; best use EPSG
# if you do not have files to extract CRS from
# p
# crs(p)
# locations2 <- st_as_sf(plot_locations_HARV, coords=c("easting", "northing"), crs = 32618)
# st_crs(locations2)

# plot it in extent

boundary <- st_read("./HARV/HarClip_UTMZ18.shp")

plot(boundary$geometry, main = "Harvard Forest Field Site")
plot(locations$geometry, pch = 8, add=TRUE)

st_crs(boundary)
st_crs(locations)

st_bbox(boundary)
st_bbox(locations)

#add extra space to the left of the plot area
par(mar=c(5.1,4.1,4.1,8.1), xpd = TRUE)

plot(st_convex_hull(st_sfc(st_union(locations$geometry))),
     col = "purple",
     xlab = "easting",
     ylab = "northing", lwd = 8,
     main = "Extent Boundary of Plot Locations \nCompared to the AOI Spatial Object",
     ylim = c(4712400, 4714000)) # extent the y axis to make room for the legend

plot(boundary$geometry,
     add = TRUE,
     lwd = 6,
     col = "springgreen")

legend("bottomright",
       #inset = c(-0.5,0),
       legend = c("Layer One Extent", "Layer Two Extent"),
       bty = "n",
       col = c("purple", "springgreen"),
       cex = .8,
       lty = c(1, 1),
       lwd = 6)
?st_convex_hull

plotLoc.extent <- st_bbox(locations)
plotLoc.extent
# grab the x and y min and max values from the spatial plot locations layer
xmin <- plotLoc.extent[1]
xmax <- plotLoc.extent[3]
ymin <- plotLoc.extent[2]
ymax <- plotLoc.extent[4]

# adjust the plot extent using x and ylim
plot(boundary$geometry,
     main = "NEON Harvard Forest Field Site\nModified Extent",
     border = "darkgreen",
     xlim = c(xmin, xmax),
     ylim = c(ymin, ymax))

plot(locations$geometry,
     col = "purple",
     add = TRUE)


# Example / Exercise

plots <- read.csv("HARV/HARV_2NewPhenPlots.csv", stringsAsFactors = FALSE)
head(plots)

plots <-st_as_sf(plots, coords = c("decimalLon", "decimalLat"), crs = 4326) 

st_crs(plots)
st_crs(boundary)

newcrs <- st_crs(boundary)
plots <- st_transform(plots, newcrs)
st_crs(plots)

newPlotextent <- st_bbox(plots)
originalPlotextent <- st_bbox(locations)

ymax <- newPlotextent[4]


#plot on expanded extent
plot(boundary$geometry,
     main = "NEON Harvard Forest Field Site\nModified Extent",
     border = "darkgreen",
     xlim = c(xmin, xmax),
     ylim = c(ymin, ymax))

plot(locations$geometry,
     col = "purple",
     add = TRUE)
plot(plots$geometry, 
     pch = 2,
     col = "pink", 
     add = TRUE)

#write a shapefile
st_write(plots, "/PlotsHARV.shp", driver = "ESRI Shapefile")
