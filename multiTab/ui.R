library(shiny)
library(leaflet)
library(ggplot2)
library(RColorBrewer)
library(stringr)

coordinates <- read.csv("LTM_Sample_Coordinates.csv")
coordinates <- coordinates[complete.cases(coordinates),]
colnames(coordinates) <- c("lat", "lng", "popup", "ALSC")
lakedata <- read.csv("LakeData.csv")
colnames(lakedata)[1] <- "confirmedDate"
lakedata$ALSC <- str_sub(lakedata$ALSC,2, str_length(lakedata$ALSC))
lakedata$confirmedDate <- as.Date(lakedata$confirmedDate, "%Y.%m.%d")
dateValues <- base::unique(lakedata$confirmedDate)
measurementValues <- colnames(lakedata)[8:ncol(lakedata)]
coordinates_and_data <- merge(coordinates, lakedata, by = "ALSC")
library(data.table)
coord_data_dt <- data.table(coordinates_and_data)

fluidPage(
  
  
  titlePanel("Acid Rain in the Adirondacks"),
  
  tabsetPanel(               
    tabPanel("By Date", h2("Analyze by Date"), 
             sidebarLayout(
               sidebarPanel(
                 
                 selectInput("dateInput", "Measurement Date", 
                             choices = dateValues, multiple = FALSE),
                 selectInput("variableInput", "Measurement",
                             choices = measurementValues, multiple = FALSE)
               ),
               mainPanel(
                 "Explore lake chemistry readings around the Adirondacks. The data were collected by the Adirondack Lakes Survey Corporation, and are available at www.adirondacklakesurvey.org.",
                 h6("Andy Hasselwander, 2018"),
                 leafletOutput("map1"),
                 plotOutput("timeSeries1")
               )
             )
            ),
    tabPanel("By Location", h2("Analyze by Location"),
             
             sidebarLayout(
               sidebarPanel(
                 
                 selectInput("startDateInput", 
                             "Start Date", 
                             choices = dateValues, 
                             multiple = FALSE, 
                             selected = dateValues[1]),
                 selectInput("variableInput", 
                             "End Date",
                             choices = dateValues, 
                             multiple = FALSE, 
                             selected = dateValues[length(dateValues)]),
                 selectInput("location", 
                             "Location", 
                              choices = placeValues,
                              choices = placeValues,
                              multiple = FALSE,
                              selected = placeValues[1]),
                 selectInput("variableInput", "Measurement",
                             choices = measurementValues, multiple = FALSE)
                 )
               ),
               mainPanel(
                 "Explore lake chemistry readings around the Adirondacks. The data were collected by the Adirondack Lakes Survey Corporation, and are available at www.adirondacklakesurvey.org.",
                 h6("Andy Hasselwander, 2018"),
                 leafletOutput("map1"),
                 plotOutput("timeSeries2")
               )
             )
             
             
             
             
             )
  )
)