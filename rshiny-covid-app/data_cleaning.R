# Data Cleaning

#Imports
#
library(stringr)

# Step 1: Exchange all the na values in numeric Columns by 0
# 
numeric_cols <- sapply(df, is.numeric)  # True/False Vector of numeric columns
numeric_df <- df[, numeric_cols] # Subset dataframe with aforementioned Vector
numeric_df[is.na(numeric_df)] <- 0 # Replace all na values in subset
df[, numeric_cols] <- numeric_df # Replace all relevant columns with columns of subset
rm(numeric_cols, numeric_df)

# Step 2: Merge AdditionalDose 2-5 to MoreAdditionalDoses (we leave them in for now)
#
df$MoreAdditionalDoses <- rowSums(df[, c('DoseAdditional2','DoseAdditional3', 'DoseAdditional4','DoseAdditional5')])

# Step 3: Rename and relocate Columns
#
df <- rename(df, AdditionalDose = DoseAdditional1)
df <- df %>% relocate(MoreAdditionalDoses, .after = AdditionalDose)

# Step 4: Split up YearWeekISO
#
df$Year <- as.numeric(substr(df$YearWeekISO, 1, 4))
df$Week <- as.numeric(substr(df$YearWeekISO, 7, 8))

# Step 5: relocate Columns
#
df <- df %>% relocate(Year, .after = YearWeekISO)
df <- df %>% relocate(Week, .after = Year)

View(df)