library(caret)
library(datasets)
library(dplyr)
library(GGally)
library(ggplot2)
library(grDevices)
library(Hmisc)
library(randomForest)
library(shiny)
library(stats)
library(tidyverse)

#I removed the unnecessary column of "instant," which simply numbered each observation and did not have quantitative value. I also removed the variable "dteday", which just indicated the specific day on which an observation was collected and similarly should not be used in calculations. 

bikeShare <- read.csv(file="/Users/christinemarieheubusch/Final-Project/Bike-Sharing-Dataset_day.csv") %>% select(-c("instant", "dteday"))

shinyServer(function(input, output, session) {
  #For the Introduction page: creating MathJax. 
  output$form1 <- renderUI({
    helpText(withMathJax("Find
                         $$z_{i11}=\\phi_{11}x_{i1}+\\phi_{21}x_{i2}+...+\\phi_{p1}x_{ip}$$
                         values such that the set of Z's has the largest variance."))
  })
  output$form1constraint <- renderUI({
    helpText(withMathJax("Contraint: $$\\sum_{j=1}^p\\phi_{j1}^2=1$$"))
  })
  
  #For the Data Exploration page: creating summary data, using the "var" outputId that I created in my UI file. 
  bikeReact <- reactive ({
    newData1 <- bikeShare[input$var] 
  })
  
  summariesInput <- reactive({
    sums <- summary(bikeReact())
  })
  output$summaries <- renderPrint(
    print(summariesInput())
  )
  
  plotGGP <- reactive({
    df <- bikeReact()
  })
  output$ggp <- renderPlot({
    ggpairs(plotGGP())
  })
  output$info <- renderText({
    paste0("x=", input$plot_click$x, ", ", "y=", input$plot_click$y)
  })
  
  plotHist <- reactive({
    hist(bikeReact)
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
  #SUMMARIES CURRENTLY NOT WORKING
  output$downloadSummaries <- downloadHandler(
    filename="bikeShare_summaries.png",
    content=function(file){
      png(file)
      sums <- summary(bikeReact())
      print(sums)
      dev.off()
    }
  )
  output$downloadPlot_ggp <- downloadHandler(
    filename="GGPairs.png",
    content=function(file){
      png(file)
      GGP <- ggpairs(bikeReact())
      print(GGP)
      dev.off()
    }
  )
  output$downloadPlot_hist <- downloadHandler(
    filename="Histograms.png",
    content=function(file){
      hist <- hist(bikeReact())
      print(hist)
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
  
  #Modeling page: creating random forest
  RF <- reactive({
    randomForest(cnt~bikeReact()[input$season] +
                   bikeReact()[input$yr] +
                   bikeReact()[input$mnth] + 
                   bikeReact()[input$holiday] +
                   bikeReact()[input$weekday] +
                   bikeReact()[input$weekday] + 
                   bikeReact()[input$workingday] +
                   bikeReact()[input$weathersit] +
                   bikeReact()[input$temp] +
                   bikeReact()[input$atemp] +
                   bikeReact()[input$hum] +
                   bikeReact()[input$windspeed] +
                   bikeReact()[input$casual] + 
                   bikeReact()[input$registered],
                     data=bikeShare,
                     ntree=500,
                     mtry=3,
                     importance=TRUE, 
                     replace=FALSE)
  })
  prediction <- reactive({
    predict(RF(), bikeReact())
    })
  
  output$guess <- renderText(prediction())
  
  #Data page: creating data table featuring all observations and variables.
  bikeReact4 <- reactive ({
    newData4 <- bikeShare[input$var4] 
  })
  output$bikesTable <- renderDataTable(
    bikeReact4(),
    options=list(scrollX=TRUE))
  output$downloadData <- downloadHandler(
    filename="bikeShareData.csv",
    content=function(file){
      write.csv(bikeReact4(), file, row.names=FALSE)
    }
  )
  
})