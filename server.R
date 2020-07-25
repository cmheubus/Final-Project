library(dplyr)
library(ggplot2)
library(Hmisc)
library(shiny)
library(tidyverse)

#I removed the unnecessary column of "instant," which simply numbered each observation and did not have quantitative value. 

shinyServer(function(input, output, session) {
  bikeShare <- read.csv(file="/Users/christinemarieheubusch/Final-Project/Bike-Sharing-Dataset_day.csv") %>% select(-"instant")
  output$irisPlot<- renderPlot({
    g <- ggplot(iris, aes(x=Sepal.Length, y=Petal.Length))
    g + geom_point()
    })
  output$bikesTable <- renderDataTable(
    bikeShare,
    options=list(scrollX=TRUE))
  output$downloadData <- downloadHandler(
    filename="bikeShareData.csv",
    content=function(file){
        write.csv(bikeShare, file, row.names=FALSE)
      }
  )

  })
