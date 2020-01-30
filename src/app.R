library(shiny)
library(maps)

# setup
data <- read.csv(file = "meteorite.csv", header = TRUE, sep = ";", stringsAsFactors = FALSE)
firstyear <- min(as.numeric(data$year))
lastyear <- max(as.numeric(data$year))

# functions
updateData <- function(startYear, endYear)
{
  return(data[{data$year>=startYear & data$year <= endYear},])
}
updatePoints <- function(newData)
{
  yco <- c(as.numeric(unlist(newData["reclat"])))
  xco <- c(as.numeric(unlist(newData["reclong"])))
  points(xco,yco, col="red", pch=4, lwd = 2)
}
introstring <- xml2::read_html("text.html")

# shiny
ui <- fluidPage(
  htmlOutput(outputId = "intro"),
  sliderInput(inputId = "range",
              label = "select timeframe",
              min = firstyear,
              max = lastyear,
              value = c(firstyear, lastyear)
              ),
  verbatimTextOutput(outputId = "mytext"),
  plotOutput(outputId = "map"),
  plotOutput(outputId = "hist"),
  "Based on the NASA dataset from https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh."
)

server <- function(input, output, session) {
  output$intro <- renderText(paste(introstring))
  rData <- reactive(updateData(input$range[1], input$range[2]))
  output$mytext <- renderText(
    paste("num of meteorite crashes: ", nrow(rData()))
  )
  output$map <- renderPlot(
    {    
      map("world", fill=TRUE, col="white", bg="lightskyblue", ylim=c(-100, 100), mar=c(0,0,0,0))
      updatePoints(rData())
    }
  )
  output$hist <- renderPlot(
    hist(log10(rData()$mass..g.),
         main = "histogram of meteorite weight",
         xlab = "logarithic mass, in 10^x grams"
         )
  )
}

shinyApp(ui, server)
