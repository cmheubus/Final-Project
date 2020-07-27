library(DT)
library(ggplot2)
library(plotly)
library(shinydashboard)

bikeShare <- read.csv(file="/Users/christinemarieheubusch/Final-Project/Bike-Sharing-Dataset_day.csv") %>% select(-c("instant", "dteday"))

header <- dashboardHeader(title="Final Project")
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Introduction", tabName="introduction"),
    menuItem("Data Exploration", tabName="dataExploration"),
    menuItem("Principal Components Analysis", tabName="pca"),
    menuItem("Modeling", tabName="modeling"), 
    menuItem("Data", tabName="data")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName="introduction",
            titlePanel("Introduction content"),
            sidebarLayout(
              sidebarPanel(
                h3("Select options here:")
              ),
              mainPanel(
                fluidRow(
                  box(plotOutput("irisPlot")),
                  box("More box content!"),
                  box(h3("Subtitle Here"),
                      p(strong("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed porttitor nulla sed purus consequat, non mollis ante mattis. Maecenas vel elit finibus, tincidunt magna ac, ullamcorper purus."), 
                        br(),
                        a("Click here for data source", href="https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset")),
                      p("Sed ac sagittis lorem, sit amet efficitur ante. Suspendisse massa tortor, rutrum eu pretium vitae, dapibus ac velit. Praesent at est pulvinar arcu ornare convallis feugiat nec eros. Ut eget magna sapien. Integer semper fermentum metus facilisis tempus. Proin orci elit, pulvinar non felis non, tincidunt porta metus. Vestibulum mollis dapibus urna, sed vulputate enim vestibulum eget. Duis quis diam id dui tempor vestibulum. Pellentesque sit amet dignissim velit.")
                  )
                )
              ))),
    tabItem(tabName="dataExploration",
            titlePanel("Data Exploration"),
            sidebarLayout(
              sidebarPanel(
                selectizeInput("var", 
                               label="Select Two or More Variables of Interest To Examine:", 
                               multiple=TRUE,
                               selected=c("temp","cnt"),
                               choices=c("Season"="season", 
                                         "Year"="yr", 
                                         "Month"="mnth",
                                         "Holiday"="holiday",
                                         "Weekday"="weekday",
                                         "Working Day"="workingday",
                                         "Weather Condition"="weathersit",
                                         "Temperature"="temp",
                                         "Ambient Temperature"="atemp",
                                         "Humidity"="hum",
                                         "Windspeed"="windspeed",
                                         "Casual Users"="casual",
                                         "Registered Users"="registered",
                                         "Casual & Registered Users"="cnt"), 
                               options=list(create=TRUE, placeholder="Click to see dropdown list.")), 
                em("To add a variable, click in the box and choose from the options in the dropdown menu.",
                   br(), br(),
                   "To remove a variable that has been selected, click it and hit delete or backspace to remove it from the plots."),
                br(), br(),
                downloadButton("downloadData_dataExploration", "Download Data for Selected Variables")),
              mainPanel(fluidRow(
                box(title="Summary Data", 
                    verbatimTextOutput("summaries"), 
                    downloadButton("downloadSummaries", "Download PNG")),
                box(title="Correlation Matrix", 
                    plotOutput("ggp"), 
                    downloadButton("downloadPlot_ggp", "Download PNG")), 
                box(title="Histograms of Individual Variables", 
                    plotOutput("hist"), 
                    downloadButton("downloadPlot_hist","Download PNG"))
              )))),
    tabItem(tabName="pca",
            titlePanel("Principal Components Analysis"), 
            sidebarLayout(
              sidebarPanel(
                selectInput("var2",
                            label="Select First Variable to Compare to PC1 & PC2",
                            choices=c("Season"="season", 
                                      "Year"="yr", 
                                      "Month"="mnth",
                                      "Holiday"="holiday",
                                      "Weekday"="weekday",
                                      "Working Day"="workingday",
                                      "Weather Condition"="weathersit",
                                      "Temperature"="temp",
                                      "Ambient Temperature"="atemp",
                                      "Humidity"="hum",
                                      "Windspeed"="windspeed",
                                      "Casual Users"="casual",
                                      "Registered Users"="registered",
                                      "Casual & Registered Users"="cnt")),
                selectInput("var3",
                            label="Select Second Variable",
                            choices=c("Season"="season", 
                                      "Year"="yr", 
                                      "Month"="mnth",
                                      "Holiday"="holiday",
                                      "Weekday"="weekday",
                                      "Working Day"="workingday",
                                      "Weather Condition"="weathersit",
                                      "Temperature"="temp",
                                      "Ambient Temperature"="atemp",
                                      "Humidity"="hum",
                                      "Windspeed"="windspeed",
                                      "Casual Users"="casual",
                                      "Registered Users"="registered",
                                      "Casual & Registered Users"="cnt"),
                            selected="cnt"),
                downloadButton("downloadData_pca", "Download Data for Selected Variables")
              ), 
              mainPanel(
                box(title="Biplot featuring 1st and 2nd Principal Components", plotOutput("biplot"),
                    downloadButton("downloadBiplot","Download Biplot")
                    ),
                box(title="Screeplot of How Much of the Variance is Described by the Principal Components", plotOutput("screeplot")), 
                box(title="Principal Components", verbatimTextOutput("principalComponents"))
              )
              )
    ),
    tabItem(tabName="modeling",
            titlePanel("Modeling content"),
            sidebarLayout(
              sidebarPanel(
                checkboxGroupInput("varCheck", "Variables to include:",
                                   c("Season"="season",
                                     "Year"="yr",
                                     "Month"="mnth",
                                     "Holiday"="holiday",
                                     "Weekday"="weekday",
                                     "Working Day"="workingday",
                                     "Weather Condition"="weathersit",
                                     "Temperature"="temp",
                                     "Ambient Temperature"="atemp",
                                     "Humidity"="hum",
                                     "Windspeed"="windspeed",
                                     "Casual Users"="casual",
                                     "Registered Users"="registered",
                                     "Casual & Registered Users"="cnt"))
                
              ),
              mainPanel("Hello")
            )
    ),
    tabItem(tabName="data",
            titlePanel("Bike Sharing Data"),
            sidebarLayout(
              sidebarPanel(
                selectizeInput("var4", 
                               label="Select Variables of Interest:", 
                               multiple=TRUE,
                               selected=names(bikeShare),
                               choices=c("Season"="season", 
                                         "Year"="yr", 
                                         "Month"="mnth",
                                         "Holiday"="holiday",
                                         "Weekday"="weekday",
                                         "Working Day"="workingday",
                                         "Weather Condition"="weathersit",
                                         "Temperature"="temp",
                                         "Ambient Temperature"="atemp",
                                         "Humidity"="hum",
                                         "Windspeed"="windspeed",
                                         "Casual Users"="casual",
                                         "Registered Users"="registered",
                                         "Casual & Registered Users"="cnt"), 
                               options=list(create=TRUE, placeholder="Click to see dropdown list.")),
                em("To view a subset of the data, simply click on the variable(s) you wish to remove and hit delete or backspace."),
                br(), br(),
                downloadButton("downloadData", "Download Data for Selected Variables")
              ),
              mainPanel(
                dataTableOutput("bikesTable", width="600px")
              )
            )
    )
  ))

shinyUI(
  dashboardPage(header, sidebar, body))