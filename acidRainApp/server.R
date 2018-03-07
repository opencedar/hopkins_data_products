library(shiny)
shinyServer(function(input, output, session) {

    coordinates <- read.csv("LTM_Sample_Coordinates.csv")
    coordinates <- coordinates[complete.cases(coordinates),]
    colnames(coordinates) <- c("lat", "lng", "popup", "ALSC")
    lakedata <- read.csv("LakeData.csv")
    colnames(lakedata)[1] <- "confirmedDate"
    require(stringr)
    lakedata$ALSC <- str_sub(lakedata$ALSC,2, str_length(lakedata$ALSC))
    lakedata$confirmedDate <- as.Date(lakedata$confirmedDate, "%Y.%m.%d")
    dateValues <- unique(lakedata$confirmedDate)
    measurementValues <- colnames(lakedata)[8:ncol(lakedata)]

  
  output$map1 <- renderLeaflet({
   
    lakeDataSelected <- lakedata[lakedata$confirmedDate == input$dateInput,]
    coordinates_and_data <- merge(coordinates, lakeDataSelected, by = "ALSC")
    require(RColorBrewer)
    colors <- rev(brewer.pal(9, 'YlOrRd'))
    selectedVariable <- coordinates_and_data[,colnames(coordinates_and_data)
                                             == input$variableInput]
    
    colors <- cut(selectedVariable, breaks = 9, labels = colors)
    cutLabels <- cut(selectedVariable, breaks = 9)
    cutLabels <- paste(input$variableInput, "between", levels(cutLabels))
    
    require(leaflet)
    latlon <- coordinates_and_data[,2:3] 
    labels <- paste0(coordinates_and_data$popup, ", ", 
                     input$variableInput, " = ", coordinates_and_data$LABPH, 
                     ", Date ", coordinates_and_data$confirmedDate)
    
    adkLakes <- leaflet() 
    latlon %>%
      leaflet() %>%
      addTiles() %>%
      addCircleMarkers(popup=labels, color = colors, opacity = 1, clusterOptions = markerClusterOptions()) %>%
      addLegend(labels = cutLabels, 
                colors = rev(brewer.pal(9, 'YlOrRd')))
    
    
  })
})