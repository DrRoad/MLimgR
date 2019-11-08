# Copyright 2019 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.
library(tidyverse)
library(RStoolbox)

#read the image raster for PG
img <- readRDS("temp/img_Data.R")
names(img)
#a list of the indices we want to calculate
list.indices <- c("NDVI", "SR", "NDWI", "MTCI")

for (i in seq(1:length(list.indices))) {
  print(i)
  tmp <- RStoolbox::spectralIndices(img, red = "red", nir = "nir", green = "green",
                       blue = "blue", redEdge1 = "rededge1",
                       redEdge2 = "rededge2", indices = list.indices[i])

  #merge the new index with the other bands in image
  img <- stack(tmp, img)
}

PGE <- raster("raster_elev/dataset/DEM.tif")
PGS <- ("raster_sentinel/T10UEE_20190529T191911_20m.tif")

PGEP <- projectRaster(PGE, img)

PGEPR <- resample(PGEP, img)

PGEPRC <- crop(PGEPR, img)

slope <- terrain(PGEPRC, 'slope', unit = 'degrees', neighbors = 8)

img <- stack(img, slope, PGEPRC)

saveRDS(img, "temp/img_indices_w_DEM.R")

img <- readRDS("temp/img_w_DEM_indices.R")

# Convert raster to numeric
nr <- getValues(img)
str(nr)

# Set random number generator seed
set.seed(23)

# Run cluster analysis for 10 groups (can be slow)
kmncluster <- kmeans(x = na.omit(nr), centers = 10)

# Insert cluster values into the raster structure
knr <- setValues(img[[1]], kmncluster$cluster)

# Plot (force categorical)
ggR(knr, forceCat = T, geom_raster = T) +
  scale_fill_brewer(palette = "Set1")

#Convert to WGS84
#imgWGS <- projectRaster(img, crs = crs("+init=EPSG:4326"))

#### EXTRACT URBAN, WATER, FOREST ####

# xy coords
xy <- xyFromCell(img[[1]], kmncluster$cluster)
xy <- data.frame(xy)
training <- tibble(class = kmncluster$cluster, x = xy$x, y = xy$y)
training <- cbind(nr, training)
# Add classification to spectral matrix
training <- training %>%
  filter(class %in% c(1,2,5))

#save RDS file
saveRDS(training, "temp/training.R")

