coordinates <- read.csv("LTM_Sample_Coordinates.csv")
coordinates <- coordinates[complete.cases(coordinates),]
colnames(coordinates) <- c("lat", "lng", "popup", "ALSC")
lakedata <- read.csv("LakeData.csv")
colnames(lakedata)[1] <- "confirmedDate"
require(stringr)
lakedata$ALSC <- str_sub(lakedata$ALSC,2, str_length(lakedata$ALSC))
lakedata$confirmedDate <- as.Date(lakedata$confirmedDate, "%Y.%m.%d")