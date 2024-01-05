library(readr)
library(tibble)
library(ggplot2)
library(plotly)

rm(list = ls())

df_tibble = as_tibble(readr::read_csv("D:/Code/rstudio_workbench/rshiny-covid-app/rshiny-covid-app/resources/data.csv"))

View(df_tibble)

names(df_tibble)

refusals_not_zero <- df_tibble %>%
  filter(FirstDoseRefused != 0)


# sum value of first dose per target group
sum_first_dose <- df_tibble %>%
  group_by(TargetGroup) %>%
  summarise(Sum_FirstDose = sum(FirstDose, na.rm = TRUE)) %>%
  arrange(desc(Sum_FirstDose))

print(sum_first_dose)


########################### pie chart selected age groups #######################
selected_target_groups <- c("Age0_4", "Age5_9", "Age10_14", "Age15_17", 
                            "Age18_24", "Age25_49", "Age50_59", "Age60_69", 
                            "Age70_79", "Age80+")


# sum value of first dose per target group (selected target groups)
sum_first_dose <- df_tibble %>%
  dplyr::filter(TargetGroup %in% selected_target_groups) %>%
  group_by(TargetGroup) %>%
  summarise(Sum_FirstDose = sum(FirstDose, na.rm = TRUE)) %>%
  arrange(desc(Sum_FirstDose))

# pie chart
# pie_chart <- ggplot(sum_first_dose, aes(x = "", y = Sum_FirstDose, fill = TargetGroup)) +
#   geom_bar(stat = "identity", width = 1, color = "white") +
#   coord_polar("y", start = 0) +
#   theme_void() +
#   labs(title = "Verteilung der FirstDose nach Altersgruppen")
# 
# print(pie_chart)



# Plotly Pie-Chart erstellen
# refrence https://plotly.com/r/pie-charts/
fig <- plot_ly(sum_first_dose, 
               labels = ~TargetGroup, 
               values = ~Sum_FirstDose, 
               type = 'pie',
               hoverinfo = 'label+value')
fig <- fig %>% layout(
  title = 'Verteilung der FirstDose nach Altersgruppen',
  xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
  yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
)

fig


