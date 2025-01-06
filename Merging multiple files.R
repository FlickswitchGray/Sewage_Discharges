library(readxl)

file_list <- list.files("C:/Users/hg000051/Downloads/Sewage_EO/", all.files = TRUE)

df_list <- list()

# Loop through all files and read sheet
      for (x in file_list) {
      
        df <- read_excel(x, sheet = "Start_stop time")
        df_list[[x]] <- df
      }
      
      combined_df <- do.call(rbind, df_list)
      
 print(combined_df)
