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

library(h2o)
library(tidyverse)
library(RStoolbox)
library(caret)

training
img

# library(caret); library(rgdal)
# demo(meuse, echo=FALSE)
# meuse.ov <- cbind(over(meuse, meuse.grid), meuse@data)
# meuse.ov$x0 = 1

fitControl <- trainControl(method="repeatedcv", number=3, repeats=2)
mFit0 <- caret::train(class~nir, data=training, method="glm",
                      family=gaussian(link=log), trControl=fitControl,
                      na.action=na.omit)
mFit1 <- caret::train(class~nir+NDVI, data=training, method="glm",
                      family=gaussian(link=log), trControl=fitControl,
                      na.action=na.omit)
mFit2 <- caret::train(class~blue, data=training, method="glm",
                      family=gaussian(link=log), trControl=fitControl,
                      na.action=na.omit)
mFit3 <- caret::train(class~nir+NDVI, data=training, method="ranger",
                      trControl=fitControl, na.action=na.omit)

resamps <- resamples(list(mf0=mFit0, mf1=mFit1, mf2=mFit2, mf03=mFit3))
bwplot(resamps, layout = c(2, 1), metric=c("RMSE","Rsquared"),
       fill="grey", scales = list(relation = "free", cex = .7),
       cex.main = .7, cex.axis = .7)

