# Data Cleaning

# Step 1: Exchange all the na values in numeric Columns by 0
# 
numeric_cols <- sapply(df, is.numeric)  # True/False Vector of numeric columns
numeric_df <- df[, numeric_cols] # Subset dataframe with beforementioned Vector
numeric_df[is.na(numeric_df)] <- 0 # Replace all na values in subset
df[, numeric_cols] <- numeric_df # Replace all relevant columns with columns of subset
View(df)
rm(numeric_cols, numeric_df)