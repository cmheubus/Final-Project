library(dplyr)
library(GGally)
library(ggplot2)
library(grDevices)
library(Hmisc)
library(shiny)
library(tidyverse)

#I removed the unnecessary column of "instant," which simply numbered each observation and did not have quantitative value. 

shinyServer(function(input, output, session) {
  bikeShare <- read.csv(file="/Users/christinemarieheubusch/Final-Project/Bike-Sharing-Dataset_day.csv") %>% select(-"instant")
  bikeShare2 <- bikeShare %>% select(-"dteday")
  
  output$irisPlot <- renderPlot({
    g <- ggplot(iris, aes(x=Sepal.Length, y=Petal.Length))
    g + geom_point()
  })
  #For the Data Exploration page: creating summary data, using the "var" outputId that I created in my UI file. For these, I also removed the variable "dteday", which just indicated the day on which an observation was collected and should not be used in calculations. 
  
  bikeReact <- reactive ({
    bikeShare2[input$var]
  })
  
  output$summaries <- renderPrint({
    with(bikeReact(), summary(bikeReact()))
  })
  output$ggp <- renderPlot({
    with(bikeReact(), ggpairs(bikeReact()))
  })
  output$hist <- renderPlot({
    with(bikeReact(), hist(bikeReact()))
  })
  #Data Exploration page: creating download function for CSV featuring data of selected variables. 
  output$downloadData_dataExploration <- downloadHandler(
    filename="bikeShareData_dataExploration.csv",
    content=function(file){
      write.csv(bikeReact(), file, row.names=FALSE)
    })

  #Data Exploration page: creating download function for PNG output of graphs. 

  #For the PCA page
  bikeReact_biplot <- reactive ({
    bikeShare2[input$var2, input$var3]
  })
  output$biplot <- renderPlot(
    with(bikeReact_biplot(), )
  )
  
  #For the Data page: creating data table featuring all observations and variables.
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