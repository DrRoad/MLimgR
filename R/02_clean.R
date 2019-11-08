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

#a list of the indices we want to calculate
list.indices <- c("NDVI", "SR", "NDWI", "MTCI")

for (i in seq(1:length(list.indices))) {
  tmp <- spectralIndices(img, red = "red", nir = "nir", green = "green",
                       blue = "blue", redEdge1 = "rededge1",
                       redEdge2 = "rededge2", indices = list.indices[i])

  #merge the new index with the other bands in image
  img <- stack(tmp, img)
}

saveRDS(img, "temp/img_indices.R")


