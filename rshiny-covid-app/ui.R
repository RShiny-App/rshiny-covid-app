#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# set working directory
setwd("D:/Code/rstudio_workbench/rshiny-covid-app/rshiny-covid-app/")

fluidPage(

  # Application title
  titlePanel(title=tags$div(
    #img(src="www/logo.svg", 
    img(src="https://www.thu.de/_catalogs/masterpage/HSUlm/images/logo.svg", 
    alt="thu_logo", 
    height=60,
    align="right"), "Covid App")),
  
    # tabset panel with different contents
    tabsetPanel(
      # introduction tab
      tabPanel("Introduction",
               # content of introduction
               fluidRow(
                 column(12,
                        tags$div(
                          h3("Einführung zu Covid-19"),
                          p("Hier sollte eine Einführung zu Covid 19 stehen")
                        ))
               )),
      # graph tab
      tabPanel("GraphA",
               # content of graph A
               fluidRow(
                 column(12,
                        tags$div(
                          h3("Graph A"),
                          p("Hier steht bald ein Graph.")
                        ))
               )),
      # graph tab
      tabPanel("GraphB",
               # content of graph B
               fluidRow(
                 column(12,
                        tags$div(
                          h3("Graph B"),
                          p("Hier steht bald ein Graph.")
                        ))
               )),
      # about tab
      tabPanel("About",
               fluidRow(
                 column(12,
                        tags$div(
                          h3("Contributors"),
                          p("Alexander Metzler, Florian Hauptmann, Yannik Krantz")
                        ))
               ))
    )
)
