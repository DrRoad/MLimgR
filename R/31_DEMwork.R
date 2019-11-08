library(raster)

PGE<-raster("raster_elev/dataset/DEM.tif")
PGS<-("raster_sentinel/T10UEE_20190529T191911_20m.tif")



extent(PGE)
extent(img)
crs(img)
PGEP<-projectRaster(PGE,img)

crs(PGEP)
crs(img)

PGEPR<-resample(PGEP,img)
res(PGEPR)
res(img)

PGEPRC<-crop(PGEPR,img)

slope = terrain(PGEPRC, 'slope', unit='degrees', neighbors=8)
plot(slope)
