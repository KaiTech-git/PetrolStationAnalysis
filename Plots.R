final_df_summ <- final_df %>% group_by(Dystrybutor, SYMBOL) %>%
        summarise( L_tankowan = length(Dystrybutor), Ilosc =sum(Ilosc)) #summary
ggplot(final_df_summ, aes(x=Dystrybutor, y=L_tankowan, fill = SYMBOL ))+  
        geom_bar(stat="identity")