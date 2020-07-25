library(ggplot2)
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
            h2("Introduction tab content")
            ),
    tabItem(tabName="dataExploration",
            h2("Data tab content")
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



