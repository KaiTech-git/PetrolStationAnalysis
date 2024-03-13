library(pdftools)
library(tidyverse)
library(chron)
PDF <- pdf_text("Historia_nalan.pdf") %>%
        readr::read_lines() #open the PDF inside your project folder
#head_positions<- which(PDF %in% c("      Data     Godzina Wąż   SYMBOL Ilość  Cena   WartośćUżytkownik", 
                                  #"  Data     Godzina Wąż   SYMBOL  Ilość  Cena   WartośćUżytkownik", 
                                  #"  Data     Godzina Wąż   SYMBOL Ilość  Cena   WartośćUżytkownik")) 
head_positions<- seq(0, length(PDF), 44)
head_positions[1]<-1
for(i in head_positions){
        head_positions<- c(head_positions, (i+1):(i+4))
}
PDF_clean<-PDF[-head_positions]
PDF_clean <- PDF_clean[!(PDF_clean=="")]
##Data without column names
