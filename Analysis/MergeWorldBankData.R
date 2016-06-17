# Merge GDP an IncomeGroup Worldbank data

relativeSourcePath =c("./Analysis/Data")
filename = c("GDPbyCountry_Clean.csv")
pathtofile <- paste(relativeSourcePath, filename, sep="/")
GDP = read.csv(pathtofile,stringsAsFactors = FALSE) 

paste(nrow(GDP),"Records read from ",pathtofile,sep=" ")

filename = c("IncomeGroupbyCountry_Clean.csv")
pathtofile <- paste(relativeSourcePath, filename, sep="/")
IG = read.csv(pathtofile, stringsAsFactors = FALSE)
paste(nrow(IG),"Records read from ",pathtofile,sep=" ")

#str(GDP)
#str(IG)

#Check it, select the top N rows from each data.frame to check the merge queries

#GDP_sub.set <- GDP[1:25,]
GDP_sub.set <- GDP
#arrange(GDP, Ranking)
#print(GDP_sub.set,right=FALSE, row.names = TRUE)

#IG_sub.set <- IG[1:25,]
IG_sub.set <- IG

#print(IG_sub.set,right=FALSE, row.names = TRUE)

leftjoin <- left_join(GDP_sub.set,IG_sub.set, by = "CountryCode")
fulljoin <- full_join(GDP_sub.set,IG_sub.set, by = "CountryCode")
innerjoin_GDP_IG <- inner_join(GDP_sub.set,IG_sub.set, by = "CountryCode")

#Question 1 Match the data based on the Country short code, how many ID's match
paste("Question 1, Match the data based on Countrycodes, how many match both datasets =",nrow(innerjoin),sep="")
paste("Count of Countries excluded due to incomplete data = ",nrow(fulljoin)-nrow(innerjoin_GDP_IG),sep="")

innerjoin_byRanking <-arrange(innerjoin_GDP_IG,desc(Ranking))
paste("The 13th country by ascending GDP rank is ",innerjoin_byRanking$CountryName.x[13],sep="")
paste("Bottom 15 countries ranked by GDP",sep="")
innerjoin_GDP_IG %>% select(Ranking,CountryCode, CountryName.x,GDP_Millions_USD ) %>% arrange(desc(Ranking))%>% filter(row_number()<=15) %>% print(right= FALSE, row.names=TRUE)

