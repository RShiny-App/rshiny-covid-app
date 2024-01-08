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

# countries in data set wit additional "All" for all countries
countries <- c("All", "AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", "EL", 
               "ES", "FI", "FR", "HR", "HU", "IE", "IS", "IT", "LI", "LT", "LU", 
               "LV", "MT", "NL", "NO", "PL", "PT", "RO", "SE", "SI", "SK")

fluidPage(
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
                 column(12,
                        tags$div(
                          h3("Platzhalter Überschrift"),
                          p("Hier steht bald ein Graph.")
                        ))
               )),

      tabPanel("Länder",
               # bar chart: most vaccinations per country in a side bar panel
               # table: In which countries were the most vaccinated
               fluidRow(
                 column(12,
                        tags$div(
                          h3("Platzhalter Überschrift"),
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
                 # left side of panel
                 # Drop down choices for countries 
                 selectInput("selectedCountry", "Wähle ein Land aus:",
                             choices = countries,
                             selected = "All")
                 ),
               mainPanel(
                 # pie chart plot
                 # reference: https://stackoverflow.com/questions/41255810/r-shinyapp-not-showing-plot-ly-in-browser-but-show-only-graph-in-viewer-pane
                 plotlyOutput("target_group_pie"),
                 
                 # line graph 
                 plotlyOutput("line_chart_total_doses")
                 
               )
      ),

      tabPanel("Über uns",
               # about tab
               fluidRow(
                 column(12,
                        tags$div(
                          h3("Über unsere App"),
                          p('Willkommen zur "Covid App", entwickelt von Yannik 
                            Krantz, Alexander Metzler und Florian Hauptmann, 
                            Studierenden im fünften Fachsemester des 
                            Studiengangs Data Science in der Medizin. Diese App 
                            entstand im Rahmen unserer Projektarbeit im 
                            Wahlpflichtfach "Einführung in R und Shiny Apps" 
                            und dient gleichzeitig als Prüfungsleistung.'),
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
                          p("Yannik Krantz, Alexander Metzler, Florian Hauptmann")
                        ))
               ))
    )
)
