library(tidyverse)
library(tibble)

df <- read.csv("rshiny-covid-app/resources/data_cleaned.csv")
df_tibble <- as_tibble(df)

total_doses_by_country <- df_tibble %>%
  group_by(ReportingCountry) %>%
  summarise(TotalDoses = sum(DosesThisWeek, na.rm = TRUE)) %>%
  arrange(desc(TotalDoses))

total_doses_by_country
