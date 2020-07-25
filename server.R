library(dplyr)
library(ggplot2)
library(shiny)
library(tidyverse)

shinyServer(function(input, output, session) {
  bikeShare <- read.csv(file="/Users/christinemarieheubusch/Final-Project/Bike-Sharing-Dataset_day.csv")
})

