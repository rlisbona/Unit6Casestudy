# Merge GDP an IncomeGroup Worldbank data

relativeSourcePath =c("./Analysis/Data")
filename = c("GDPbyCountry_Clean.csv")
pathtofile <- paste(relativeSourcePath, filename, sep="/")
GDP = read.csv(pathtofile,stringsAsFactors = FALSE)
paste("Records read from ",pathtofile,"= ",nrow(GDP),sep="")

filename = c("IncomeGroupbyCountry_Clean.csv")
pathtofile <- paste(relativeSourcePath, filename, sep="/")
IG = read.csv(pathtofile, stringsAsFactors = FALSE)
paste("Records read from ",pathtofile,"= ",nrow(IG),sep="")

#str(GDP)
#str(IG)

#Check it, select the top N rows from each data.frame to check the merge queries

#GDP_sub.set <- GDP[1:25,]
GDP_sub.set <- GDP
#print(GDP_sub.set,right=FALSE, row.names = TRUE)

#IG_sub.set <- IG[1:25,]
IG_sub.set <- IG

#print(IG_sub.set,right=FALSE, row.names = TRUE)

mergeleft <- left_join(GDP_sub.set,IG_sub.set, by = "CountryCode")
fulljoin <- full_join(GDP_sub.set,IG_sub.set, by = "CountryCode")
innerjoin <- inner_join(GDP_sub.set,IG_sub.set, by = "CountryCode")

#Question 1 Match the data based on the Country short code, how many ID's match
paste("Question 1, Countrycodes found in both datasets =",nrow(innerjoin),sep="")
paste("Count of Countries excluded due to incomplete data = ",nrow(fulljoin)-nrow(innerjoin),sep="")
innerJoin <-arrange(innerjoin,desc(Ranking))
paste("The 13th country by ascending GDP rank is ",innerjoin$CountryName.x[13],sep="")
select(innerjoin,CountryName, )

filter(innerjoin, row_number() ==13)
str(innerjoin)

temp_df <- tbl_df(temp)
temp[13,]
nth(temp$CountryName.x,13)
print(fulljoin, right = FALSE, row.names = TRUE)
print(temp_df,right = FALSE,row.names=TRUE)