#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
library(tibble)
library(plotly)

# Get the directory path of the currently running script
script_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
print(getwd())

df_tibble <- as_tibble(read_csv("resources/data.csv"))

# Define server logic
function(input, output, session) {
  
  
  ####################### tab target groups ####################################
  # Create a reactive expression for target group descriptions
  target_group_descriptions <- reactive({
    data.frame(
      TargetGroup = c(
        "ALL", "HCW", "LTCF", "AgeUnk", "1_Age<60", "1_Age60+"
      ),
      Description = c(
        "Overall adults (18+)",
        "Healthcare workers",
        "Residents in long term care facilities",
        "Unknown age",
        "Adults below 60 years of age and above 17", "Adults 60 years and over"
      )
    )
  })
  # Render target group descriptions as a table
  output$target_group_description_table <- renderDataTable({
    target_group_descriptions()
  },
  # remove "show entries" and search function of table
  options = list(dom = '', footer = FALSE))
  
  
  # create pie chart of target group
  output$target_group_pie <- renderPlotly({
    
    
    
  # Verify that a country is selected
  if (input$selectedCountry != "All") {
    # if a country is selected, filter by the selected country
    sum_first_dose <- df_tibble %>%
      # filter by selected country
      dplyr::filter(ReportingCountry == input$selectedCountry) %>%
      group_by(TargetGroup) %>%
      summarise(Sum_FirstDose = sum(FirstDose, na.rm = TRUE)) %>%
      arrange(desc(Sum_FirstDose))
  } else {
    # if no country is selected, do not filter by country
    sum_first_dose <- df_tibble %>%
      group_by(TargetGroup) %>%
      summarise(Sum_FirstDose = sum(FirstDose, na.rm = TRUE)) %>%
      arrange(desc(Sum_FirstDose))
  }
    
  # create plotly pie chart
  plot_ly(
    sum_first_dose,
    labels = ~ TargetGroup,
    values = ~ Sum_FirstDose,
    type = 'pie',
    # hover info showing label and value of target group
    hoverinfo = 'label+value'
  ) %>%
    layout(
      title = 'Verteilung der FirstDose nach Altersgruppen',
      xaxis = list(
        showgrid = FALSE,
        zeroline = FALSE,
        showticklabels = FALSE
      ),
      yaxis = list(
        showgrid = FALSE,
        zeroline = FALSE,
        showticklabels = FALSE
      )
    )
    
  })
}
