library(shiny)
shinyUI(fluidPage(
  titlePanel("Acid Rain in the Adirondacks"),
  sidebarLayout(
    sidebarPanel(
     
      selectInput("dateInput", "Measurement Date", 
                   choices = dateValues, multiple = FALSE),
      selectInput("variableInput", "Measurement",
                  choices = measurementValues, multiple = FALSE)
    ),
    mainPanel(
      "Explore lake chemistry readings around the Adirondacks. The data were collected by the Adirondack Lakes Survey Corporation, and are available at www.adirondacklakesurvey.org.",
      leafletOutput("map1"),
      plotOutput("timeSeries1")
    )
  )
))