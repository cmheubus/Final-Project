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
library(tree)

#I removed the unnecessary column of "instant," which simply numbered each observation and did not have quantitative value. I also removed the variable "dteday", which just indicated the specific day on which an observation was collected and similarly should not be used in calculations. 

server <- shinyServer(function(input, output, session) {
  bikeShare <- read.csv(file="/Users/christinemarieheubusch/Final-Project/Bike-Sharing-Dataset_day.csv") %>% select(-c("instant", "dteday"))
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
  
  plotHist <- reactive({
    hist(bikeReact())
  })
  output$hist <- renderPlot({
    print(plotHist())
  })
  output$info <- renderText({
    paste0("Frequency=", input$plot_click$y)
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
      
      plot <- hist(bikeReact())
      print(plot)
      dev.off()
    }
  )
  
  #PCA page: Creating biplot with user inputs, plus static screeplot and PC analysis (with no user input).
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
  
  #PCA page: creating download function for CSV of biplot data. 
  output$downloadData_pca <- downloadHandler(
    filename="bikeShareData_dataExploration.csv",
    content=function(file){
      write.csv(bikeReact2(), file, row.names=FALSE)
    })
  
  #PCA page: creating download function for PNG of biplot. 
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
  
  #Creating a Random Forest model, along with a training and test set for this and the Bagged Trees model. 
  train <- sample(1:nrow(bikeShare), size=nrow(bikeShare)*0.8)
  test <- dplyr::setdiff(1:nrow(bikeShare), bikeTrain)
  bikeTrain <- bikeShare[train,]
  bikeTest <- bikeShare[test,]
  
  RF <- reactive({
    randomForest(cnt~.,
                 data=bikeTrain,
                 ntree=input$userNtree,
                 mtry=3,
                 importance=TRUE, 
                 replace=FALSE)
  })
  
  bikeReact3 <- reactive({
    newData3 <- data.frame(
      season=input$season,
      yr=input$yr,
      mnth=input$mnth,
      holiday=input$holiday,
      weekday=input$weekday,
      workingday=input$workingday,
      weathersit=input$weathersit,
      temp=input$temp,
      atemp=input$atemp,
      hum=input$hum,
      windspeed=input$windspeed,
      casual=input$casual,
      registered=input$registered)
  })
  
  predictionRf <- reactive({
    predict(RF(), bikeReact3())
    })
  output$prediction <- renderText(predictionRf())
  
  #Creating a regular Bagged Tree model and calculating a (rather unfortunate) misclassification rate.
  baggedTree <- reactive({train(cnt~., 
                     data=bikeTrain, 
                     method="treebag",
                     trControl=trainControl(method="repeatedcv", number=input$userNum,
                     repeats=input$userRepeats),
                     preProcess=c("center","scale"))})
  predictBagged <- reactive({
    baggedTbl <- table(data.frame(pred=predict(baggedTree(), bikeTest), true=bikeShare$cnt))
    misclassRate <- 1-(sum(diag(baggedTbl)/sum(baggedTbl)))
    misclassRate
  })
  output$misclassBagged <- renderText(predictBagged())
  
  #Ideally, I would have liked for the  code to have included a feature that would allow users to select which variables they want to include within the bagged model, to show how increasing/decreasing the number of variables could affect the model. - hence inputID var4 in the ui.R file. 
  bikeReact4 <- reactive ({
    input <- bikeShare[input$var4] 
  })
  #However, I feel I went a bit astray here, as I leaped ahead to using the predict function with bikeReact4(). For the predict feature, I should have created a separate inputID, with options similar to those outlined in the Random Forest. 
  predictionBagged <- reactive({
    predict(baggedTree(), bikeReact4())
  })
  output$predBagged <- renderText(predictionBagged())
  
  #Data page: creating data table featuring all observations and variables.
  bikeReact5 <- reactive ({
    newData5 <- bikeShare[input$var5] 
  })
  output$bikesTable <- renderDataTable(
    bikeReact5(),
    options=list(scrollX=TRUE))
  output$downloadData <- downloadHandler(
    filename="bikeShareData.csv",
    content=function(file){
      write.csv(bikeReact5(), file, row.names=FALSE)
    })
  })
