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
