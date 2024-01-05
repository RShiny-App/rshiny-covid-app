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

df_tibble <- as_tibble(read_csv("../resources/data_cleaned.csv"))

# Define server logic
function(input, output, session) {
  
  
  ##############################################################################
  #                                                                            #
  #                       tab target groups                                    #
  #                                                                            #
  ##############################################################################
  
  ######################### pie chart ##########################################
  # target groups excluding "Age<18", "ALL", "LTCF", "HCW", "1_Age<60", "1_Age60+"
  selected_target_groups <- c("Age0_4", "Age5_9", "Age10_14", "Age15_17", 
                              "Age18_24", "Age25_49", "Age50_59", "Age60_69", 
                              "Age70_79", "Age80+", "AgeUnk")

  # create pie chart of target group
  output$target_group_pie <- renderPlotly({
    # Verify that a country is selected
    if (input$selectedCountry != "All") {
      # if a country is selected, filter by the selected country
      sum_total_doses <- df_tibble %>%
        # filter by selected country and selected target groups
        dplyr::filter(ReportingCountry == input$selectedCountry & 
                        TargetGroup %in% selected_target_groups) %>%
        group_by(TargetGroup) %>%
        summarise(Sum_TotalDoses = sum(DosesThisWeek, na.rm = TRUE)) %>%
        arrange(desc(Sum_TotalDoses))
    } else {
      # if no country is selected, do not filter by country
      sum_total_doses <- df_tibble %>%
        # filter selected target groups
        dplyr::filter(TargetGroup %in% selected_target_groups) %>%
        group_by(TargetGroup) %>%
        summarise(Sum_TotalDoses = sum(DosesThisWeek, na.rm = TRUE)) %>%
        arrange(desc(Sum_TotalDoses))
    }
    
    # create plotly pie chart
    plot_ly(
      sum_total_doses,
      labels = ~ TargetGroup,
      values = ~ Sum_TotalDoses,
      type = 'pie',
      # hover info showing label and value of target group
      hoverinfo = 'label+value'
    ) %>%
      layout(
        title = 'Verteilung der Dosierungen nach Altersgruppen',
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
  
  ######################### line graph #########################################
  # render line chart for total doses over time
  output$line_chart_total_doses <- renderPlotly({
    
    # Filter data based on selected country
    if (input$selectedCountry == "All") {
      # filter data by week and total dosages per week
      df_sum_doses <- df_tibble %>%
        group_by(YearWeekISO) %>%
        summarise(Sum_TotalDoses = sum(DosesThisWeek, na.rm = TRUE))
    } else {
      # filter data by week and total dosages per week for the selected country
      df_sum_doses <- df_tibble %>%
        dplyr::filter(ReportingCountry == input$selectedCountry) %>%
        group_by(YearWeekISO) %>%
        summarise(Sum_TotalDoses = sum(DosesThisWeek, na.rm = TRUE))
    }
    
    # Plot the line chart
    plot_ly(df_sum_doses, x = ~YearWeekISO, y = ~Sum_TotalDoses, type = 'scatter', mode = 'lines+markers') %>%
      layout(title = 'Kumulierte Dosierungen über die Zeit',
             xaxis = list(title = 'Woche'),
             yaxis = list(title = 'Summe der Dosierungen'))
  })
  
  
  
}
