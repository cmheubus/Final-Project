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
            sidebarLayout(
              sidebarPanel(
                h3("Select options here:")
              ),
                mainPanel(
                  h2("Introduction tab content"), 
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
            h2("Data tab content"),
            fluidRow(
              box("Even MORE content!")
            )
            ),
    tabItem(tabName="pca",
            h2("Principal Components Analyis content")
            ),
    tabItem(tabName="modeling",
            h2("Modeling content")
            ),
    tabItem(tabName="data",
            h2("Data content"))
    )
  )

shinyUI(
 dashboardPage(header, sidebar, body)
)
