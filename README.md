# meteorite-shinyapp
R-based webapp to visualize meteorite crashes
This repo contains 2 R files; prep_meteorite.R fetches a master data table from "https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh" and outputs a table containing only necessary columns while purging unusable observations.
The file app.R is the actual shiny-webapp which uses the data output from prep_meteorite.R. It displays a small html intro, a slider to select a timeframe and 2 plots. The meteorite data is filtered dynamically according to the selected timeframe and displayed in a world map-plot and a histogram plot.

