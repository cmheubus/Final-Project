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
  
  output$irisPlot <- renderPlot({
    g <- ggplot(iris, aes(x=Sepal.Length, y=Petal.Length))
    g + geom_point()
  })
  
  #For the Data Exploration page: creating summary data, using the "var" outputId that I created in my UI file. For these, I also removed the variable "dteday", which just indicated the day on which an observation was collected and should not be used in calculations. 

  bikeReact <- reactive ({
    newData1 <- bikeShare[input$var] 
  })

  summariesInput <- reactive({
    sums <- summary(bikeReact())
  })
  output$summaries <- renderPrint(
    print(summariesInput())
  )
  
  output$ggp <- renderPlot({
    ggpairs(bikeReact())
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

  #Data Exploration page: creating download function for PNG output of summaries & graphs.
  output$downloadSummaries <- downloadHandler(
    filename="bikeShare_summaries.png",
    content=function(file){
      png(file)
      sums <- summary(bikeReact())
      dev.off()
    }
  )
  output$downloadPlot_ggp <- downloadHandler(
    filename="GGP.png",
    content=function(file){
      png(file)
      ggpairs(bikeReact())
      dev.off()
    }
  )

  #PCA page: Creating biplot with user inputs, plus screeplot and PC analysis with no user input.
  
  bikeReact2 <- reactive ({
    newData <- bikeShare[c(input$var2, input$var3)] 
  })
  plotBiplotInput <- reactive({
    df <- bikeReact2()
    vars23 <- prcomp(df, center=TRUE, scale=TRUE)
    biplot <- biplot(vars23, xlabs=rep(".", nrow(bikeShare)))
  })
  output$biplot <- renderPlot({
    print(plotBiplotInput())
  })
  
  output$principalComponents <- renderPrint({
    prcomp(bikeShare, center=TRUE, scale=TRUE)
  })
  
  output$screeplot <- renderPlot({
    PCs <- prcomp(bikeShare, center=TRUE, scale=TRUE)
    screeplot(PCs, type="lines")
  })
  
  #PCA page: creating download function for CSV of biplot data
  output$downloadData_pca <- downloadHandler(
    filename="bikeShareData_dataExploration.csv",
    content=function(file){
      write.csv(bikeReact2(), file, row.names=FALSE)
    })
  
  #PCA page: creating download function for PNG of biplot 
  output$downloadBiplot <- downloadHandler(
    filename="bikeShare_biplot.png",
    content=function(file){
      png(file)
      df <- bikeReact2()
      vars23 <- prcomp(df, center=TRUE, scale=TRUE)
      biplot <- biplot(vars23, xlabs=rep(".", nrow(bikeShare)))
      dev.off()
    }
  )
  
  #Data page: creating data table featuring all observations and variables.
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