library(pdftools)
library(tidyverse)
library(chron)
PDF <- pdf_text("Historia_nalan.pdf") %>%
        readr::read_lines() #open the PDF inside your project folder
PDF_data <- PDF[-(1:6)]
PDF_data <- PDF_data[1:36] # Dystrybutor 1 , first sheet
lines_sep<- PDF_data %>% str_squish() %>% strsplit(split = " ") # first command remove spaces if more the 1, 
                                                                #second separate data by spaces.
var_names<- c("Data", "Waz", "SYMBOL", "Ilosc" , "Cena", "Wartość", "Uzytkownik", 
              "Stanowisko", "Dokument", "Nr_dokumentu", "Status", "Tryb")
df <- plyr::ldply(lines_sep) #create a data frame
df <- df %>% unite(V1.2, V1, V2, sep = " ") #marge columns
colnames(df) <- var_names
final_df <- as_tibble(df) 
final_df$Data<- strptime(final_df$Data, "%Y-%m-%d %H:%M:%S")
final_df$Waz <- as.numeric(final_df$Waz)
final_df$SYMBOL <- as.factor(final_df$SYMBOL)
final_df$Ilosc <- as.numeric(gsub(",",".",final_df$Ilosc))
final_df$Cena <- as.numeric(gsub(",",".",final_df$Cena))
final_df$Wartość <- as.numeric(gsub(",",".",final_df$Wartość))
final_df$Uzytkownik <- as.factor(final_df$Uzytkownik)
final_df$Stanowisko <- as.numeric(final_df$Stanowisko)
