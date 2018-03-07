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
    coordinates_and_data <- merge(coordinates, lakedata, by = "ALSC")
    require(data.table)
    coord_data_dt <- data.table(coordinates_and_data)
  
  output$map1 <- renderLeaflet({
   
    lakeDataSelected <- coordinates_and_data[coordinates_and_data$confirmedDate == input$dateInput,]
    require(RColorBrewer)
    colors <- rev(brewer.pal(9, 'YlOrRd'))
    selectedVariable <- lakeDataSelected[,colnames(lakeDataSelected)
                                             == input$variableInput]
    
    colors <- cut(selectedVariable, breaks = 9, labels = colors)
    cutLabels <- cut(selectedVariable, breaks = 9)
    cutLabels <- paste(input$variableInput, "between", levels(cutLabels))
    filteredData <- coordinates_and_data[coordinates_and_data$confirmedDate == input$dateInput,]
    
    require(leaflet)
    latlon <- filteredData[,2:3] 
    labels <- paste0(filteredData$popup, ", ", 
                     input$variableInput, " = ", selectedVariable, 
                     ", Date ", filteredData$confirmedDate)
    
    adkLakes <- leaflet() 
    latlon %>%
      leaflet() %>%
      addTiles() %>%
      addCircleMarkers(popup=labels, color = colors, opacity = 1, clusterOptions = markerClusterOptions()) %>%
      addLegend(labels = cutLabels, 
                colors = rev(brewer.pal(9, 'YlOrRd')))
    
  })
  output$timeSeries1 <- renderPlot({
    
    
    tsDT <- data.frame(coord_data_dt[, mean(eval(parse(text = input$variableInput))), by = confirmedDate])
    require(ggplot2)
    ggplot(tsDT, aes(confirmedDate, V1)) + geom_line() +
      ylab("Average of All Measurements") + 
      geom_smooth(method='lm')
    
  })
  
})