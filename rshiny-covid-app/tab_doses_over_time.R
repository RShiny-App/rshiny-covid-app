library(tidyverse)
library(tibble)
library(ggplot2)
library(plotly)
library(ISOweek)

df <- read.csv("rshiny-covid-app/resources/data_cleaned.csv")
df_tibble <- as_tibble(df)

selected_target_groups <- c("Age0_4", "Age5_9", "Age10_14", "Age15_17", 
                            "Age18_24", "Age25_49", "Age50_59", "Age60_69", 
                            "Age70_79", "Age80+", "AgeUnk")

df_grouped_by_doses <- df_tibble %>%
  filter(TargetGroup %in% selected_target_groups) %>%
  select(-c(WeeklyDosesPerRegion_Total, PercentageOfTotalDosesInWeek, FirstDoseRefused)) %>%
  group_by(YearWeekISO) %>%
  summarise_if(is.numeric, function(x) sum(x, na.rm = TRUE)) 


plot <- df_grouped_by_doses %>%
  plot_ly(x = ~YearWeekISO, y = ~FirstDose, type = 'scatter', mode = 'lines', name = 'FirstDose') %>%
  add_trace(x = ~YearWeekISO, y = ~SecondDose, type = 'scatter', mode = 'lines', name = 'SecondDose') %>%
  add_trace(x = ~YearWeekISO, y = ~AdditionalDose, type = 'scatter', mode = 'lines', name = 'AdditionalDose') %>%
  add_trace(x = ~YearWeekISO, y = ~MoreAdditionalDoses, type = 'scatter', mode = 'lines', name = 'MoreAdditionalDoses') %>%
  add_trace(x = ~YearWeekISO, y = ~UnknownDose, type = 'scatter', mode = 'lines', name = 'UnknownDose') %>%
  layout(title = 'Doses Over Time',
         xaxis = list(title = 'Date'),
         yaxis = list(title = 'Number of Doses'))

plot

view(df_grouped_by_doses)
