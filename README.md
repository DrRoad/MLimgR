# MLimgR
Exploration of mlr and satellite imagery (sentinel)

General workflow process: 

## Read in Sentinel-2 Image
```
# Import stack
img <- stack("raster_sentinel/T10UEE_20190529T191911_20m.tif")
# The correct names, in order, are (not always in this order..):
band_names <- c("blue","green","red","nir","rededge1","rededge2","rededge3","swir1","swir2","vegred")
# Assign new names
names(img) <- band_names
```
## Make Training Data
- Run kmeans 
```
# Run cluster analysis for 10 groups (can be slow)
  kmncluster <- kmeans(x = na.omit(nr), centers = 10)
# Insert cluster values into the raster structure
  knr <- setValues(img[[1]], kmncluster$cluster)
```
- Extract 
```
# xy coords
xy <- xyFromCell(img[[1]], kmncluster$cluster)
xy <- data.frame(xy)
training <- tibble(class = kmncluster$cluster, x = xy$x, y = xy$y)
training <- cbind(nr, training)
# Add classification to spectral matrix
training <- training %>%
  filter(class %in% c(1,2,5))
```

## Train Model 
```
fitControl <- trainControl(method = "repeatedcv", number = 3, repeats = 2)

mFit0 <- caret::train(class~nir, data = training, method = "glm",
                      family = gaussian(link = log), trControl = fitControl,
                      na.action = na.omit)

mFit1 <- caret::train(class~nir+swir1, data=training, method="glm",
                      family=gaussian(link=log), trControl=fitControl,
                      na.action=na.omit)

mFit2 <- caret::train(class~nir+swir1+blue, data=training, method="glm",
                      family=gaussian(link=log), trControl=fitControl,
                      na.action=na.omit)

mFit3 <- caret::train(class~nir+swir1+blue, data=training, method="ranger",
                      trControl=fitControl, na.action=na.omit)
```

## Predict Land Cover using ranger
```
predictionMap  = predict(mFit3, nr)
model <- setValues(img[[1]], predictionMap)
rcl<- matrix(c(0.99, 1.01, 1, 1.99, 2.01, 2, 4.99, 5.00, 3), ncols <- 3)
correctmodel <- reclassify(model, rcl)
```
