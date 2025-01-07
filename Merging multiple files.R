library(readxl)
library(tidyverse)
library(magrittr)
library(lubridate)

file_list <- list.files("C:/Users/hg000051/Downloads/Sewage_EO/", pattern="\\.xlsx$", ignore.case = TRUE)

df_merge<- data.frame()

 for (x in 1:length(file_list)) {
   df <- read_excel(paste0("C:/Users/hg000051/Downloads/Sewage_EO/", file_list[x]), sheet = 2)
   
   # Rename so names match
   df %<>% rename(Duration = names(df)[5])
   
   # Standardize columns based on position to match df merge
   if (nrow(df_merge) > 0) {
     df %<>% select(1:ncol(df_merge))
   } else {
     df_merge <- df # Make dataframes the same 
   }
   
   # Merge
   df_merge <- rbind(df_merge, df)
   
 }

# Make some more transformations to merged df

# Change from char to dt
df_merge$Duration <- format(as.POSIXct(df_merge$Duration, tz = "UTC"), "%H:%M")

# Create numeric column for Summarise later
df_merge %<>% mutate(
              Duration_numeric = as.numeric(hms(paste0(Duration, ":00")), units = "mins")
                  ) %>% 
              select(1:5)

# Summarise
df_summary <- df_merge %>%
        group_by(`SO Name`, `SO ID`) %>%
        summarize(Total_Mins = sum(Duration_numeric, na.rm = TRUE)) %>% 
        arrange(desc(Total_Mins))



  
  writexl::write_xlsx(list(Sheet1 = df_summary, Sheet2 = df_merge), path = "C:/Users/hg000051/Downloads/Look.xlsx")
