library(readr)
library(dplyr)

# Get the directory path of the currently running script
script_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
getwd()

# Set script_dir as current working directory
setwd(script_dir)

df <- readr::read_csv("resources/data.csv")

unique(df$TargetGroup)


# Function to simulate Age based on TargetGroup
simulate_age <- function(target_group) {
  if (grepl("Age0_4", target_group)){
    # random number between 0 and 4
    return(sample(0:4, 1))
  } else if (grepl("Age5_9", target_group)){
    return(sample(5:9, 1))
  } else if (grepl("Age10_14", target_group)){
    return(sample(10:14, 1))
  } else if (grepl("Age15_17", target_group)){
    return(sample(15:17, 1))
  } else if (grepl("Age18_24", target_group)){
    return(sample(18:24, 1))
  } else if (grepl("Age25_49", target_group)){
    return(sample(25:49, 1))
  } else if (grepl("Age50_59", target_group)){
    return(sample(50:59, 1))
  } else if (grepl("Age60_69", target_group)){
    return(sample(60:69, 1))
  } else if (grepl("Age70_79", target_group)){
    return(sample(70:79, 1))
  } else if (grepl("Age80+", target_group)){
    return(sample(80:100, 1))
  }
    else if (grepl("Age<18", target_group)) {
    return(sample(0:17, 1))
  } else if (grepl("Age<60", target_group)) {
    return(sample(18:59, 1))
  } else if (grepl("Age60+", target_group)) {
    return(sample(60:100, 1))
  } else if (grepl("ALL", target_group) |
             grepl("HCW", target_group) |
             grepl("LTCF", target_group)) {
    return(sample(18:100, 1))
  } else if (grepl("Age<18", target_group)){
    return(sample(0:18, 1))
  }else{
    return(NA)
  }
}

# create new variable
df$Simulated_Age <- sapply(df$TargetGroup, simulate_age)

# relocate new variable
df <- df %>% relocate(Simulated_Age, .after = TargetGroup)
