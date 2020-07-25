library(dplyr)
library(ggplot2)
library(Hmisc)
library(shiny)
library(tidyverse)

shinyServer(function(input, output, session) {
  bikeShare <- read.csv(file="/Users/christinemarieheubusch/Final-Project/Bike-Sharing-Dataset_day.csv")

  output$irisPlot<- renderPlot({
    g <- ggplot(iris, aes(x=Sepal.Length, y=Petal.Length))
    g + geom_point()
    })
})