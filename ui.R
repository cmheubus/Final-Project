library(DT)
library(ggplot2)
library(plotly)
library(shinydashboard)

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
                               choices=c("season", 
                                         "yr", 
                                         "mnth",
                                         "temp",
                                         "atemp",
                                         "hum",
                                         "windspeed",
                                         "casual",
                                         "registered",
                                         "cnt"), 
                               options=list(create=TRUE, 
                                            placeholder="Click to see dropdown list.")), 
                               em("To add a variable, click in the box and choose from the options in the dropdown menu.",
                               br(), br(),
                               "To remove a variable that has been selected, click it and hit delete or backspace to remove it from the plots.",
                               br(), br(),
                               "Two or more variables must be selected in order for the correlation matrix to work."),
                               br(), br(),
                               downloadButton("downloadData_dataExploration", "Download Data for Selected Variables")),
              mainPanel(fluidRow(
                box(verbatimTextOutput("summaries"), title="Summary Data", downloadButton("downloadPlot_summaries", "Download PNG")),
                box(plotOutput("ggp"), title="Correlation Matrix", downloadButton("downloadPlot_ggp", "Download PNG")), 
                box(plotOutput("hist"), title="Histograms of Individual Variables", downloadButton("downloadPlot_hist","Download PNG"))
                )))),
    tabItem(tabName="pca",
            titlePanel("Principal Comp Analysis content")
            ),
    tabItem(tabName="modeling",
            titlePanel("Modeling content")
            ),
    tabItem(tabName="data",
            titlePanel("Bike Sharing Data"),
            mainPanel(
                dataTableOutput("bikesTable", width="900px"),
                downloadButton("downloadData", "Download Data")
                )
              )
            ))

ui <- fluidPage(
 dashboardPage(header, sidebar, body))
