library(shiny)
shinyUI(fluidPage(
  titlePanel("Acid Rain in the Adirondacks"),
  sidebarLayout(
    sidebarPanel(

      selectInput("dateInput", "Select the Date", 
                   choices = dateValues, multiple = FALSE),
      selectInput("variableInput", "Select the Measurement",
                  choices = measurementValues, multiple = FALSE)
    ),
    mainPanel(
      h3("Map of Selected Data"),
      leafletOutput("map1")
    )
  )
))