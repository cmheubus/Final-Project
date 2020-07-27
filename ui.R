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
            titlePanel("Exploring Bicycle Sharing Data"),
            sidebarLayout(
              sidebarPanel(
                h5(strong("Data Citation")),
                "Fanaee-T, Hadi, and Gama, Joao, 'Event labeling combining ensemble detectors and background knowledge', Progress in Artificial Intelligence (2013): pp. 1-15, Springer Berlin Heidelberg,",
                a("Web Link", href="https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset")
              ),
              mainPanel(
                fluidRow(
                  h4("How Do Weather Conditions, Holidays, and More Affect the Popularity of the Bikeshare Programs?"),
                      p("For my final project, I elected to work with", a("data concerning the Capital Bikeshare program", 
                      href="https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset"),
                      "in Washington, DC, gathered across 2011 and 2012. The dataset was compiled by Hadi Fanaee-T and Joao Gama of the University of Porto, who combined information from the official Bikeshare database, as well as separate weather and government resources concerning holidays. The list of variables may be seen below."),
                  HTML("<ul><li> <strong>instant</strong> - index of the observation. <em>I removed this variable, as it did not serve a quantitative purpose.</em> </li>
                      <li><strong>dteday</strong> - date on which observation was recorded. <em>I similarly removed this column.</em></li>
                      <li><strong>season</strong> - season, coded as 1:winter, 2:spring, 3:summer, 4:fall </li>
                      <li><strong>yr</strong> - year, coded as 0:2011, 1:2012</li>
                      <li><strong>mnth</strong>  - month, from 1 to 12</li>
                      <li><strong>hr</strong> - hour of the day, from 0 to 23</li>
                      <li><strong>holiday</strong> - whether the day is a federal holiday or not</li>
                      <li><strong>weekday</strong> - day of the week</li>
                      <li><strong>workingday</strong> - 1 if the day is neither a holiday nor weekend, 0 otherwise.</li>
                      <li><strong>weathersit</strong> - weather situation, coded as 1: clear, few clouds, partly cloudy; 2: mist + cloudy, mist + broken clouds, mist + few clouds, mist; 3: light snow, light rain + thunderstorm + scattered clouds, light rain + scattered clouds; 4: heavy rain + ice pallets + thunderstorm + mist, snow + fog</li>
                      <li><strong>temp</strong> - temperature, <em>Normalized</em> in Celcius</li>
                      <li><strong>hum</strong> - humidity, also Normalized</li>
                      <li><strong>windspeed</strong> - wind speed, also Normalized</li>
                      <li><strong>casual</strong> - count of casual users, who are not registered</li>
                      <li><strong>registered</strong> - count of registered users</li>
                      <li><strong>cnt</strong> - summation of both casual and registered users for the day</li>
                     </ul>"),
                  p("This app allows the user to examine the data in several ways. First, the", strong("Data Exploration"), "tab is a beginning resource for understanding the makeup of the data, by allowing the user to create correlation plots, data summaries, and histograms with the data of their chosing."),
                  p("The", strong("Principal Components Analysis"), "tab allows a user to specific two variables to compare to PC1 and PC2 of the dataset. It also features a static screeplot and calculation of the phi values."), 
                  p("The", strong("Modeling"), "tab..."), #MUST BE EDITED
                  p("And finally, the", strong("Data"), "tab allows the user to select which variables they are interested in, for them to either view within the app or download a custom dataset, per their variable selections.")
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
                    plotOutput("ggp", click="plot_click"), 
                    verbatimTextOutput("info"),
                    downloadButton("downloadPlot_ggp", "Download PNG")), 
                box(title="Histograms of Individual Variables", 
                    plotOutput("hist"), 
                    downloadButton("downloadPlot_hist","Download PNG"))
              )))),
    tabItem(tabName="pca",
            titlePanel("Principal Components Analysis"), 
            sidebarLayout(
              sidebarPanel(
                strong("Formula"),
                uiOutput("form1"),
                uiOutput("form1constraint"),
                selectInput("var2",
                            label="Select First Variable to Compare to PC1 & PC2:",
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
                            label="Select Second Variable:",
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
                conditionalPanel(condition="input.var2==input.var3", 
                                 em(h4("Please select a different second variable!")
                                     )), 
                br(),
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
            titlePanel("Random Forest Model"),
            sidebarLayout(
              sidebarPanel(
                h4("Select Variable Values for Prediction"),
                selectInput("season", "Season", choices=c("Winter"="1","Spring"="2","Summer"="3","Fall"="4")),
                selectInput("yr", "Year", choices=c("2011"="0", "2012"="1")),
                selectInput("holiday","Holiday", choices=c("Yes"="1", "No"="0")),
                selectInput("weekday", "Weekday", choices=c("Yes"="1", "No"="0")),
                selectInput("workingday", "Working Day", choices=c("Yes"="1", "No"="0")),
                selectInput("weathersit", "Weather Condition", choices=c("Clear, few clouds..."="1", "Mist + Cloudy..."="2", "Light Snow, Light Rain + Thunderstorm..."="3", "Heavy Rain..."="4")),
                sliderInput("temp", "Temperature (Celcius, Normalized)", value=0, min=0, max=1),
                sliderInput("atemp", "Ambient Temperature (Celcius, Normalized)", value=0, min=0, max=1),
                sliderInput("hum", "Humidity (Normalized)", value=0, min=0, max=1),
                sliderInput("windspeed", "Windspeed (Normalized)", value=0, min=0, max=1),
                numericInput("casual", "Casual Users", value=0),
                numericInput("registered", "Registered Users", value=0)
              ),
              mainPanel(textOutput("guess")
              )
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
                conditionalPanel(condition="input.var4==0", 
                                 em(h4("You must select at least one variable!"))),
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