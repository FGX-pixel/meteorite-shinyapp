library(shiny)
library(maps)

# setup
dta <- read.csv(file = "meteorite.csv", header = TRUE, sep = ";", stringsAsFactors = FALSE)
firstyear <- min(as.numeric(dta$year))
lastyear <- max(as.numeric(dta$year))

# functions
updateData <- function(startYear, endYear)
{
  return(dta[{dta$year>=startYear & dta$year <= endYear},])
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
  mainPanel(
    sliderInput(inputId = "range",
                label = "select timeframe",
                min = firstyear,
                max = lastyear,
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
    paste("num of meteorite crashes: ", nrow(rDta()))
  )
  output$map <- renderPlot(
    {    
      map("world", fill=TRUE, col="white", bg="lightskyblue", ylim=c(-100, 100), mar=c(0,0,0,0))
      updatePoints(rDta())
    }
  )
  output$hist <- renderPlot(
    hist(log10(rDta()$mass..g.),
         main = "histogram of meteorite weight",
         xlab = "logarithic mass, in 10^x grams"
         )
  )
}

shinyApp(ui, server)
