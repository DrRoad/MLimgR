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

# devtools::install_github("16EAGLE/getSpatialData")
library(tidyverse)
library(raster)

# Import stack
img <- stack("raster_sentinel/T10UEE_20190529T191911_20m.tif")

# The correct names, in order, are (not always in this order..):
band_names <- c("blue","green","red","nir","rededge1","rededge2","rededge3","swir1","swir2","vegred")

# Assign new names
names(img) <- band_names

#save RDS file
saveRDS(img, "temp/img_Data.R")
