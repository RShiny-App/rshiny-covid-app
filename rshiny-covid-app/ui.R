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
      tabPanel("Einführung",
               # introduction tab
               # content of introduction
               fluidRow(
                 column(12,
                        tags$div(
                          h3("Einführung zu Covid-19"),
                          p("Hier sollte eine Einführung zu Covid 19 stehen")
                        ))
               )),

      tabPanel("Impfstoffe",
               # table: how many doses of which vaccine were given in total + Which vaccine had the most additional doses?
               fluidRow(
                 column(12,
                        tags$div(
                          h3("Graph A"),
                          p("Hier steht bald ein Graph.")
                        ))
               )),

      tabPanel("Länder",
               # bar chart: most vaccinations per country in a side bar panel
               # table: In which countries were the most vaccinated
               fluidRow(
                 column(12,
                        tags$div(
                          h3("Graph B"),
                          p("Hier steht bald ein Graph.")
                        ))
               )),

      tabPanel("Ablehnungsrate",
               # line graph: refusal rate over time
               # table: In which country was the refusal rate highest
               # line graph
               fluidRow(
                 column(12,
                        tags$div(
                          h3("Graph B"),
                          p("Hier steht bald ein Graph.")
                        ))
               )),
      
      tabPanel("Zielgruppen",
               # pie chart + line graph: comparison of target groups 
               # per unit of time
               # per country
               # in dropdown menus
               fluidRow(
                 column(12,
                        tags$div(
                          h3("Graph B"),
                          p("Hier steht bald ein Graph.")
                        ))
               )),

      tabPanel("Über uns",
               # about tab
               fluidRow(
                 column(12,
                        tags$div(
                          h3("Contributors"),
                          p("Alexander Metzler, Florian Hauptmann, Yannik Krantz")
                        ))
               ))
    )
)
