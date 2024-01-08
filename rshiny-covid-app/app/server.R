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
#setwd(script_dir)

df_tibble <- as_tibble(read_csv("../resources/data_cleaned.csv"))

##################### mappings #################################################
# target groups excluding "Age<18", "ALL", "LTCF", "HCW", "1_Age<60", "1_Age60+"
selected_target_groups <- c("Age0_4", "Age5_9", "Age10_14", "Age15_17", 
                            "Age18_24", "Age25_49", "Age50_59", "Age60_69", 
                            "Age70_79", "Age80+", "AgeUnk")
age_names_german <- c("Alter 0 bis 4", "Alter 5 bis 9", "Alter 10 bis 14", 
                      "Alter 15 bis 17", "Alter 18 bis 24", "Alter 25 bis 49", 
                      "Alter 50 bis 59", "Alter 60 bis 69", "Alter 70 bis 79", 
                      "Alter 80+", "Altersgruppe unbekannt")
# mapping of selected target groups and age names
age_mapping <- setNames(age_names_german, selected_target_groups)


# mapping of iso codes and country names
iso_codes <- c("AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", "EL", "ES", 
               "FI", "FR", "HR", "HU", "IE", "IS", "IT", "LI", "LT", "LU", 
               "LV", "MT", "NL", "NO", "PL", "PT", "RO", "SE", "SI", "SK")
country_names_german <- c("Oesterreich", "Belgien", "Bulgarien", "Zypern", 
                          "Tschechien", "Deutschland", "Dänemark", "Estland", 
                          "Griechenland", "Spanien", "Finnland", "Frankreich", 
                          "Kroatien", "Ungarn", "Irland", "Island", "Italien", 
                          "Liechtenstein", "Litauen", "Luxemburg", "Lettland", 
                          "Malta", "Niederlande", "Norwegen", "Polen", 
                          "Portugal", "Rumänien", "Schweden", "Slowenien", 
                          "Slowakei")
# mapping iso_codes and country_names_german
iso_country_mapping <- setNames(country_names_german, iso_codes)

# Define server logic
function(input, output, session) {
  
  ##############################################################################
  #                                                                            #
  #                       tab target groups                                    #
  #                                                                            #
  ##############################################################################
  
  ######################### line graph #########################################
  # define variable for line graph header
  line_graph_header <- ""
  
  # render line chart for total doses over time
  output$line_chart_total_doses <- renderPlotly({
    
    # Filter data based on selected country and selected target group
    if (input$selectedCountry == "All" & input$selectedTargetGroup == "All") {
      # filter data by week and total dosages per week
      df_sum_doses <- df_tibble %>%
        group_by(YearWeekISO) %>%
        summarise(Sum_TotalDoses = sum(DosesThisWeek, na.rm = TRUE))
      
      # adjust line graph header
      line_graph_header <- 'Dosierungen über Zeit in allen Ländern und allen Zielgruppen'
    } else if(input$selectedCountry == "All" & input$selectedTargetGroup != "All"){
      # filter data by week and total dosages per week for the selected country
      df_sum_doses <- df_tibble %>%
        dplyr::filter(TargetGroup == input$selectedTargetGroup) %>%
        group_by(YearWeekISO) %>%
        summarise(Sum_TotalDoses = sum(DosesThisWeek, na.rm = TRUE))
      
      # adjust line graph header
      line_graph_header <- paste('Dosierungen über Zeit in allen Ländern und', 
                                # get german description for selected target group
                                age_mapping[input$selectedTargetGroup])
    } else if(input$selectedCountry != "All" & input$selectedTargetGroup == "All"){
      df_sum_doses <- df_tibble %>%
        dplyr::filter(ReportingCountry == input$selectedCountry) %>%
        group_by(YearWeekISO) %>%
        summarise(Sum_TotalDoses = sum(DosesThisWeek, na.rm = TRUE))
      
      # adjust line graph header
      line_graph_header <- paste('Dosierungen über Zeit in', 
                                 # get german country name from iso mapping
                                 iso_country_mapping[input$selectedCountry], 
                                 'und allen Zielgruppen')
    } else{
      df_sum_doses <- df_tibble %>%
        dplyr::filter(ReportingCountry == input$selectedCountry &
                        TargetGroup == input$selectedTargetGroup) %>%
        group_by(YearWeekISO) %>%
        summarise(Sum_TotalDoses = sum(DosesThisWeek, na.rm = TRUE))
      
      # adjust line graph header
      line_graph_header <- paste('Dosierungen über Zeit in', 
                                 # get german country name from iso mapping
                                 iso_country_mapping[input$selectedCountry], 
                                 'und', 
                                 # get german description for selected target group
                                 age_mapping[input$selectedTargetGroup])
    }
    
    # Plot the line chart
    plot_ly(df_sum_doses, x = ~YearWeekISO, y = ~Sum_TotalDoses, type = 'scatter', mode = 'lines+markers') %>%
      layout(title = line_graph_header,
             xaxis = list(title = 'Woche'),
             yaxis = list(title = 'Summe der Dosierungen'))
  })
  
  ######################### pie chart ##########################################
  # define variable for line graph header
  pie_chart_header <- 'Verteilung der Dosierungen nach Altersgruppen'
  
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
      
      # adjust pie chart header
      pie_chart_header <- paste("Vertelung der Dosierungen nach Altersgruppen in",
                                # get german country name from iso mapping
                                iso_country_mapping[input$selectedCountry])
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
        title = pie_chart_header
      )
  })
}
