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
dateValues <- na.omit(base::unique(lakedata$confirmedDate, na.rm = TRUE))

measurementValues <- colnames(lakedata)[8:ncol(lakedata)]
coordinates_and_data <- merge(coordinates, lakedata, by = "ALSC")
locationValues <- sort(base::unique(coordinates_and_data$popup))
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
                             choices = measurementValues, multiple = FALSE,
                             selected = "LABPH")
               ),
               mainPanel(
                 "Explore lake chemistry readings around the Adirondacks. The data were collected by the Adirondack Lakes Survey Corporation, and are available at www.adirondacklakesurvey.org.
                 There are two tabs. The first tab allows a user to explore every testing site in the park, and then drill into 
                 chemistry readings for that lake on a given date. Adjust the reading and the date using the left nav. The plot shows a time
                 series plot of that chemistry reading across the entire range of measurements, across all measurement sites.",
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
                 selectInput("endDateInput", 
                             "End Date",
                             choices = dateValues, 
                             multiple = FALSE, 
                             selected = dateValues[length(dateValues)]),
                 selectInput("locationInput", 
                             "Location", 
                             choices = locationValues,
                             multiple = FALSE,
                             selected = locationValues[1]),
                 selectInput("variableInput2", "Measurement",
                             choices = measurementValues, multiple = FALSE,
                             selected = "LABPH")
               )
               ,
               mainPanel(
                 "Explore lake chemistry readings around the Adirondacks. The data were collected by the Adirondack Lakes Survey Corporation, and are available at www.adirondacklakesurvey.org. 
                 The second tab allows a user to explore one location in detail, within a date range. Change the location, start and end dates, and 
                 measurement using the left nav. The plot fits a regression line vs. time and provides a p-value to determine the trend of the measurement
                  through time.",
                 h6("Andy Hasselwander, 2018"),
                 plotOutput("timeSeries2"),
                 textOutput("textOutput1")
               )
             )
             
             
             
             
    )
  )
)