#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
# plotly for plotlyOutput()
library(plotly)

# Get the directory path of the currently running script
script_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)

#setwd(script_dir)

# countries in data set with additional "All" for all countries
countries <- c("All", "AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", "EL", 
               "ES", "FI", "FR", "HR", "HU", "IE", "IS", "IT", "LI", "LT", "LU", 
               "LV", "MT", "NL", "NO", "PL", "PT", "RO", "SE", "SI", "SK")

# target groups in data set with additional "All" for all target groups
target_groups <- c("All", "Age0_4", "Age5_9", "Age10_14", "Age15_17", 
                   "Age18_24", "Age25_49", "Age50_59", "Age60_69", 
                   "Age70_79", "Age80+", "AgeUnk")

fluidPage(
  # bootstrap themes
  # reference https://mastering-shiny.org/action-layout.html
  # theme = bslib::bs_theme(bootswatch = "united"),
  tags$head(
    tags$link(rel = "stylesheet", href = "style.css")
  ),
  # Application title
  titlePanel(title=tags$div(
    # img(src="../www/logo.svg", 
    img(src="logo.svg", 
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
                        tags$div(HTML("
                                      <h3>Einführung zu COVID-19</h3>
                                      <h5>Kurzinformation</h5>
                                      <p>Die Krankheit COVID-19, Kurzform für „<b>Co</b>rona<b> Vi</b>rus <b>D</b>isease 2019“, ist eine Infektionskrankheit, welche durch den Erreger SARS-CoV-2 verursacht wird. Dieses Virus war Anfang 2020 der Auslöser der COVID-19-Pandemie. Der Hauptübertragungsweg des Virus ist die Tröpfcheninfektion, also über kleine Aerosole, die eingeatmet werden. Zu den häufigsten Symptomen zählen Husten, Fieber, Schnupfen und die Störung des Geschmacks- und Geruchssinns. Besonders risikobehaftet sind vor allem ältere Personen und Personen mit Vorerkrankungen. Die mediane Inkubationszeit beträgt in etwa 4-6 Tage, je nach Virusvariante und die Krankheit dauert etwa 8-10 Tage an, falls keine Therapie durchgeführt wird. </p>
                                      <h5>Übertragungswege</h3>
                                      <p>Der Hauptübertragungsweg des COVID-19 Erregers ist die Tröpfcheninfektion. Dabei werden kleine Partikel in der Luft, welche die Viren enthalten, eingeatmet und gelangen so in den Körper. Die Übertragungswahrscheinlichkeit von einer Infozierten Person zu einer Nichtinfizierten steigt dabei, wenn sich beide Personen in einem geschlossenen Raum aufhalten, besonders wenn dieser schlecht belüftet ist. Es empfiehlt sich demnach bei längerem Aufenthalt in einem Raum regelmäßig zu lüften. Auch das Tragen von Masken wie einem Mund-Nasen-Schutz können das Risiko einer Infektion senken. </p>
                                      ")
                        ))
               )),

      tabPanel("Impfstoffe",
               # table: how many doses of which vaccine were given in total + Which vaccine had the most additional doses?
               fluidRow(
                 div(
                   div(tableOutput("total_vaccines_table")),
                   div(plotlyOutput("total_vaccines_pie"))
                 )
                 )),

      tabPanel("Länder",
               tags$br(),
               # drop down choices for target group
               selectInput("selectedTargetGroup_countries", "Wähle eine Zielgruppe aus:",
                           choices = target_groups,
                           selected = "All"),
               fluidRow(
                 # insert space on left and right side
                 style = "margin-left: 15px; margin-right: 15px;",
                 tags$h4("Gesamtdosen pro Land"),
                 # bar chart most doses per country
                 plotOutput("bar_chart_most_vaccinations")
               ),
               
               # dividing line
               tags$hr(),
               
               mainPanel(
                 tags$br(),
                  tags$h4("Länder mit den meisten Dosen"),
                  tags$br(),
                  # table: In which countries were the most vaccinated
                  dataTableOutput("top_countries_table")
                )
               ),

      tabPanel("Ablehnungsrate",
               # line graph: refusal rate over time
               # table: In which country was the refusal rate highest
               # line graph
               fluidRow(
                 column(12,
                        tags$div(
                          h3("Platzhalter Überschrift"),
                          p("Hier steht bald ein Graph.")
                        ))
               )),
      
      tabPanel("Zielgruppen",
               # pie chart + line graph: comparison of target groups 
               # per unit of time
               # per country
               # in dropdown menus
               tags$br(),
               sidebarPanel(
                 # drop down choices for country
                 selectInput("selectedCountry", "Wähle ein Land aus:",
                             choices = countries,
                             selected = "All"),
                 # drop down choices for target group
                 selectInput("selectedTargetGroup_targetgroups", "Wähle eine Zielgruppe aus:",
                             choices = target_groups,
                             selected = "All")
               ),
               mainPanel(
                 # line graph 
                 plotlyOutput("line_chart_total_doses"),
                 tags$br()
               ),
               
               sidebarPanel(
                 # set sidebar panel of pie chart invisible
                 style = "display: none;",
               ),
               mainPanel(
                 # pie chart plot
                 # reference: https://stackoverflow.com/questions/41255810/r-shinyapp-not-showing-plot-ly-in-browser-but-show-only-graph-in-viewer-pane
                 plotlyOutput("target_group_pie")
               )

      ),

      tabPanel("Über uns",
               # about tab
               fluidRow(
                 column(12,
                        tags$div(
                          h3("Über unsere App"),
                          # reference to data science and thu website
                          p('Willkommen zur "Covid App", entwickelt von 
                            Studierenden im fünften Fachsemester des Studiengangs ',
                            a(href = "https://www.thu.de/de/Seiten/Studiengang_DSM.aspx", 
                              "Data Science in der Medizin"),
                            ' an der ',
                            a(href = "https://www.thu.de/de", 
                              "technischen Hochschule Ulm"),
                            '. Diese App entstand im Rahmen unserer Projektarbeit 
                            im Wahlpflichtfach "Einführung in R und Shiny Apps" 
                            und dient gleichzeitig als Prüfungsleistung.'
                          ),
                          br(),
                          h3("Funktionen der App"),
                          p('Die "Covid App" bietet eine intuitive 
                            Benutzeroberfläche, die es ermöglicht, Daten im 
                            Zusammenhang mit COVID-19-Impfungen in den Ländern 
                            der Europäischen Union und des Europäischen 
                            Wirtschaftsraums zu visualisieren. Die App 
                            präsentiert umfassende Informationen über die 
                            Verteilung von Impfstoffdosen, Verabreichungsraten 
                            und Ablehnungsstatistiken.'),
                          br(),
                          h4("Weitere Informationen"),
                          p("Besuchen Sie diese Website für weitere 
                            Informationen über den Datensatz: ",
                            a(href="https://www.ecdc.europa.eu/en/publications-data/data-covid-19-vaccination-eu-eea", "Hier klicken")),
                          br(),


                          h4("Entwickler"),
                          p("Yannik Krantz",
                            a(href = "https://github.com/Y4ng0", img(src = "github-mark.png", height = 20, width = 20))
                          ),
                          p("Alexander Metzler",
                            a(href = "https://github.com/alxmtzr", img(src = "github-mark.png", height = 20, width = 20))
                          ),
                          p("Florian Hauptmann",
                             a(href = "https://github.com/Flo3141", img(src = "github-mark.png", height = 20, width = 20))
                          ),

                          br(),

                          h4("GitHub Project"),
                          p("R Shiny Covid App",
                            a(href = "https://github.com/hierstehtbaldderlinkzumprojekt", img(src = "github-mark.png", height = 20, width = 20))
                          )
                        ))
               ))
    )
)
