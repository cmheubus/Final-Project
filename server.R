library(dplyr)
library(GGally)
library(ggplot2)
library(grDevices)
library(Hmisc)
library(shiny)
library(stats)
library(tidyverse)

#I removed the unnecessary column of "instant," which simply numbered each observation and did not have quantitative value. 

bikeShare <- read.csv(file="/Users/christinemarieheubusch/Final-Project/Bike-Sharing-Dataset_day.csv") %>% select(-c("instant", "dteday"))

shinyServer(function(input, output, session) {
  
  bikeReact <- reactive ({
    newData <- bikeShare[,input$var] 
  })
  
  output$irisPlot <- renderPlot({
    g <- ggplot(iris, aes(x=Sepal.Length, y=Petal.Length))
    g + geom_point()
  })
  
  #For the Data Exploration page: creating summary data, using the "var" outputId that I created in my UI file. For these, I also removed the variable "dteday", which just indicated the day on which an observation was collected and should not be used in calculations. 

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
  
  output$principalComponents
  
  output$screeplot <- renderPlot({
    morePCs <- prcomp(bikeShare, center=TRUE, scale=TRUE)
    screeplot(morePCs, type="lines")
  })
  
  output$biplot <- renderPlot({
    PCs <- prcomp(select(bikeShare, input$var2, input$var3), center=TRUE, scale=TRUE)
    biplot(PCs, xlabs=rep(".", nrow(bikeShare)))
  })
  

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