library(shiny)
library(maps)

# setup
{
  # call prep file if meteorites not yet loaded
  if(!file.exists("meteorite.csv")){
    source("prep_meteorite.R", local = FALSE)
  }
  
  dta <- read.csv(file = "meteorite.csv", header = TRUE, sep = ";", stringsAsFactors = FALSE)
  firstyear <- min(as.numeric(dta$year))
  lastyear <- max(as.numeric(dta$year))
  introstring <- readLines("text.txt")
}

# update data function
updateData <- function(startYear, endYear)
{
  return(dta[{dta$year>=startYear & dta$year <= endYear},])
}


# shiny
{
  ui <- fluidPage(
    mainPanel(
      tags$h2("Meteorite App"),
      htmlOutput(outputId = "intro"),
      sliderInput(inputId = "range",
                  label = "Select timeframe",
                  min = firstyear,
                  max = lastyear,
                  width = "100%",
                  value = c(firstyear, lastyear),
      ),
      plotOutput(outputId = "map"),
      verbatimTextOutput(outputId = "mytext"),
      plotOutput(outputId = "hist"),
      "Based on the NASA dataset from https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh."
    )
  )
  
  server <- function(input, output, session) {
    output$intro <- renderText(paste(introstring))
    rDta <- reactive(updateData(input$range[1], input$range[2]))
    output$mytext <- renderText(
      paste("Number of meteorite crashes: ", nrow(rDta()))
    )
    output$map <- renderPlot(
      {    
        map("world", fill=TRUE, col="white", bg="lightskyblue", ylim=c(-100, 100), mar=c(0,0,0,0))
        points(c(as.numeric(unlist(rDta()["reclong"]))),
               c(as.numeric(unlist(rDta()["reclat"]))),
               col="red",
               pch=4,
               lwd = 2
        )
      }
    )
    output$hist <- renderPlot(
      hist(log10(rDta()$mass..g.),
           main = "Histogram of meteorite weight",
           xlab = "logarithic mass, in 10^x grams"
           )
    )
  }
}
shinyApp(ui, server)
