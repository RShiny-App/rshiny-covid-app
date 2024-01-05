#Adding columns
#
#
# Add a new column that sums up doses across all columns
df$DosesThisWeek <- rowSums(df[c("FirstDose", "SecondDose", "AdditionalDose", "MoreAdditionalDoses", "UnknownDose")])

# Make a new dataframe for all the relevant TargetGroups
new_df <- df %>%
  filter(TargetGroup %in% c('ALL', 'Age0_4', 'Age5_9', 'Age10_14', 'Age15_17', 'Age18_24', 'Age25_49', 'Age50_59', 'Age60_69', 'Age70_79', 'Age80+')) %>%
  select(Year, Week, Region, Vaccine, DosesThisWeek) %>%
  distinct() %>%
  group_by(Year, Week, Region) %>%
  summarise(WeeklyDosesPerRegion_Total = sum(DosesThisWeek, na.rm = TRUE)) %>%
  ungroup()


# Merge new_df with the original dataframe based on 'YearWeekISO' and 'Region'
df <- merge(df, new_df, by = c("Year","Week", "Region"), all.x = TRUE)

# Calculate PercentageOfTotalDosesInWeek
df$PercentageOfTotalDosesInWeek <- round((df$DosesThisWeek / df$WeeklyDosesPerRegion_Total) * 100, 2)

# Display the updated dataframe
View(df)



# export csv
write.csv(df, "../resources/data_cleaned.csv", row.names = FALSE)


