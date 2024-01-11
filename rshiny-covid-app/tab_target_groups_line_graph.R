library(tidyverse)
library(plotly)

rm(list = ls())

df_tibble <- read.csv("rshiny-covid-app/resources/data_cleaned.csv")

# filter data by week and total dosages per week
df_sum_doses <- df_tibble %>%
  group_by(YearWeekISO) %>%
  summarise(Sum_TotalDoses = sum(DosesThisWeek, na.rm = TRUE))

# sort unique weeks in ascending order
df_sum_doses <- df_sum_doses[order(df_sum_doses$YearWeekISO), ]

# create line graph
plot_ly(df_sum_doses, x = ~YearWeekISO, y = ~Sum_TotalDoses, type = 'scatter', mode = 'lines+markers') %>%
  layout(title = 'Kumulierte Dosierungen über die Zeit',
         xaxis = list(title = 'Woche'),
         yaxis = list(title = 'Summe der Dosierungen'))
