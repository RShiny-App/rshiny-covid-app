library(tidyverse)
library(tibble)
library(ggplot2)

df <- read.csv("rshiny-covid-app/resources/data_cleaned.csv")
df_tibble <- as_tibble(df)

total_doses_by_country <- df_tibble %>%
  group_by(ReportingCountry) %>%
  summarise(TotalDoses = sum(DosesThisWeek, na.rm = TRUE)) %>%
  arrange(desc(TotalDoses))


ggplot(total_doses_by_country,
       # reorder -> sort descending TotalDoses
       aes(x = reorder(ReportingCountry, -TotalDoses), y = TotalDoses)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Gesamtdosen pro Land", x = "Land", y = "Gesamtdosen") +
  theme_minimal()
