library(pdftools)
library(tidyverse)
library(chron)
library(ggplot2)
if_thousand<- function(string){
        k<- NULL
        for(j in 1:length(string)){
                if(length(string[[j]])>13){
                        k <- c(k,j)   
                }
                
        }
        for (m in k) {
                string[[m]][7] <-paste0(string[[m]][7],string[[m]][8])
                string[[m]]<- string[[m]][-8]
        }
        string
}
##Reading data
PDF <- pdf_text("Historia_nalan.pdf") %>%
        readr::read_lines() #open the PDF inside your project folder
head_positions<- seq(0, length(PDF), 44)
head_positions[1]<-1
for(i in head_positions){
        head_positions<- c(head_positions, (i+1):(i+4))
}
PDF_clean<-PDF[-head_positions]
PDF_clean <- PDF_clean[!(PDF_clean=="")]
##Cleaning data
var_names<- c("Data", "Waz", "SYMBOL", "Ilosc" , "Cena", "Wartość", "Uzytkownik", 
              "Stanowisko", "Dokument", "Nr_dokumentu", "Status", "Tryb")
Dyst_pos<-grep("(.*)Dystrybutor:(.*)", PDF_clean)
k<-2
for(i in Dyst_pos){
        Dyst<-as.numeric(gsub("Dystrybutor: ", "", PDF_clean[i]))
        if(!(is.na(Dyst_pos[k]))){
                lines_sep<- PDF_clean[(i+1):(Dyst_pos[k]-1)] %>% str_squish() %>% strsplit(split = " ") # first command remove spaces if more the 1, 
                #second separate data by spaces.
        }else{
                lines_sep<- PDF_clean[(i+1):(length(PDF_clean))] %>% str_squish() %>% strsplit(split = " ") # first command remove spaces if more the 1, 
                #second separate data by spaces.
        }
        lines_sep<-if_thousand(lines_sep)
        df <- plyr::ldply(lines_sep) #create a data frame
        df <- df %>% unite(V1.2, V1, V2, sep = " ") #marge columns
        colnames(df) <- var_names
        df<- mutate(df, Dystrybutor = rep(Dyst, nrow(df)))
        if(i==1){
                All_data <- df
        } else{
                All_data <- rbind(All_data, df)      
        }
        k<-k+1
        
}
final_df <- as_tibble(All_data) 
final_df$Data<- strptime(final_df$Data, "%Y-%m-%d %H:%M:%S")
final_df$Waz <- as.numeric(final_df$Waz)
final_df$SYMBOL <- as.factor(final_df$SYMBOL)
final_df$Ilosc <- as.numeric(gsub(",",".",final_df$Ilosc))
final_df$Cena <- as.numeric(gsub(",",".",final_df$Cena))
final_df$Wartość <- as.numeric(gsub(",",".",final_df$Wartość))
final_df$Uzytkownik <- as.factor(final_df$Uzytkownik)
final_df$Stanowisko <- as.numeric(final_df$Stanowisko)
##Plotting
ggplot(data = final_df, aes(Dystrybutor)) + geom_histogram(color="black", fill="white")+ 
        scale_x_continuous("Dystrybutor", labels = as.character(final_df$Dystrybutor), breaks = final_df$Dystrybutor)
