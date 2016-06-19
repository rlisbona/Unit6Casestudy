# Merge GDP an IncomeGroup Worldbank data

relativeSourcePath =c("./Analysis/Data")
filename = c("GDPbyCountry_Clean.csv")
pathtofile <- paste(relativeSourcePath, filename, sep="/")
GDP = read.csv(pathtofile,stringsAsFactors = FALSE) 
#Count the rows
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

#leftjoin <- left_join(GDP_sub.set,IG_sub.set, by = "CountryCode")


#Records that match either dataset, will have some NA's
fulljoin <- full_join(GDP_sub.set,IG_sub.set, by = "CountryCode")
#Records that match countrycode in both datasets
innerjoin_GDP_IG <- inner_join(GDP_sub.set,IG_sub.set, by = "CountryCode")
unmatched_rows <- fulljoin %>% filter(is.na(CountryName.x)|is.na(IncomeGroup))




