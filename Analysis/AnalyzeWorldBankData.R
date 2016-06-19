
paste("Distinct Incomegroups found in dataset",sep="")
distinct(select(innerjoin_GDP_IG,IncomeGroup))
#str(innerjoin_GDP_IG)


#Question 1 Match the data based on the Country short code, how many ID's match
paste("Question 1, Match the data based on Countrycodes, how many match both datasets =",nrow(innerjoin_GDP_IG),sep="")
paste("Count of Countries excluded due to incomplete data = ",nrow(fulljoin)-nrow(innerjoin_GDP_IG),sep="")
paste("Table of Unmatched rows",sep="")
unmatched_rows

#Question 2 sort data frame in ascending order by GDP rank so USA is last, what is the 13th country
#13th row turned out to have the same GDP rank as previous row so create a new ranking variable to show this
innerjoin_GDP_IG_rank <-mutate(innerjoin_GDP_IG,GDPrank=rank(desc(Ranking)))
innerjoin_GDP_IG_rank.sort <- arrange(innerjoin_GDP_IG_rank,GDPrank)
newrank <- innerjoin_GDP_IG_rank.sort[c("CountryCode","Ranking","GDPrank","CountryName.x","GDP_Millions_USD","IncomeGroup")]
paste("The 13th country by ascending GDP rank is not available",sep="")
paste("Two countries share a rank of 12.5 , there is no 13th country",sep="")
newrank %>% select(Ranking,GDPrank,CountryCode, CountryName.x,GDP_Millions_USD ) %>% arrange(GDPrank)%>% filter(GDPrank==12.5) %>% print(right= FALSE, row.names=TRUE)

paste("First 15 countries ranked by GDP",sep="")
newrank %>% select(Ranking,GDPrank,CountryCode, CountryName.x,GDP_Millions_USD ) %>% arrange(GDPrank)%>% filter(row_number()<=15) %>% print(right= FALSE, row.names=TRUE)

PlotDataset <- arrange(innerjoin_GDP_IG_rank,Ranking)


#summary(PlotDataset)


HighIncomes <- filter(innerjoin_GDP_IG_rank, grepl(pattern = "High income",IncomeGroup ))
by_IncomeGroup <- group_by(HighIncomes, IncomeGroup)
HighIncomeRanks <- summarise(by_IncomeGroup, meanrank = mean(Ranking), medianrank = median(Ranking))

# Question 3 What are average GDP rankings for High INcome OECD and nonOECD
print("Question3: average GDP rankings for High Income: OECD and High Income: nonOECD",sep="")
print(HighIncomeRanks,  digits =2)

#assign factors to countrycode so it sorts by ranking rather than alphabetically
PlotDataset$CountryCode_alpha  <- PlotDataset$CountryCode
PlotDataset$CountryCode <- factor(PlotDataset$CountryCode,levels=PlotDataset$CountryCode[order(PlotDataset$Ranking)])


# Question 4 plot the GDP for all countries, color by Income Group
# Continuous Y axis, CountryCode sorted Alphabetically
p <-ggplot(data = PlotDataset,aes(x= CountryCode_alpha,y= GDP_Millions_USD,colour =IncomeGroup)) +
  geom_point(aes(size=desc(Ranking))) +
  scale_y_continuous(name="GDP in Millions $USD") +
  ggtitle("GDP by CountryCode  sorted by Alphabetical Countrycode") +
  theme(text =element_text(size=7),
        axis.text.x =element_text(angle=90, vjust=1))
print(p)
# Log Y axis, CountryCode sorted Alphabetically
p <-ggplot(data = PlotDataset,aes(x= CountryCode_alpha,y= GDP_Millions_USD,colour =IncomeGroup)) +
  geom_point(aes(size=desc(Ranking))) +
  scale_y_log10(name="log10(GDP in Millions $USD)") +
  ggtitle("GDP by CountryCode  sorted by Alphabetical Countrycode") +
  theme(text =element_text(size=7),
        axis.text.x =element_text(angle=90, vjust=1))
print(p)

# Continuous Y axis, CountryCode sorted b descending GDP
p <-ggplot(data = PlotDataset,aes(x= CountryCode,y= GDP_Millions_USD,colour =IncomeGroup)) +
  geom_point(aes(size=desc(Ranking))) +
  scale_y_continuous(name="GDP in Millions $USD") +
  ggtitle("GDP by CountryCode Sorted by GDP Rank") +
  theme(text =element_text(size=7),
  axis.text.x =element_text(angle=90, vjust=1))
print(p)

# Log Y axis, CountryCode sorted by descending GDP
p <-ggplot(data = PlotDataset,aes(x= CountryCode,y= GDP_Millions_USD,colour =IncomeGroup)) +
  geom_point(aes(size=desc(Ranking))) +
  scale_y_log10(name="log10(GDP in Millions $USD)") +
ggtitle("log transform base 10 of GDP by CountryCode Sorted by GDP Rank")+
  theme(text =element_text(size=7),
  axis.text.x =element_text(angle=90, vjust=1))
print(p)


#Question 5 Group GDP ranking into 5 quantile groups, make a table vs Income Group
PlotDataset$Quantile <- ntile(PlotDataset$Ranking,5)
#str(PlotDataset)
summary_tbl2 <- ddply(PlotDataset, c("Quantile","IncomeGroup"),summarise,
                      N=length(X.x),
                      mean_rank = mean(Ranking),
                      sd_GDP_Millions = sd(GDP_Millions_USD),
                      min_GDP = min(GDP_Millions_USD),
                      mean_GDP = mean(GDP_Millions_USD),
                      max_GDP = max(GDP_Millions_USD))
summary_tbl2  

#print("Detailed Quantile table")
#kable(PlotDataset[,c(11,8,9,4)])



#How many countries are Lower middle income but among the 38 nations with highest GDP
#Create variable LMincomeTop38 where 1=Top38 GDP Rank and IncomeGroup = Lower middle income
PlotDataset <- mutate(PlotDataset, LMincomeTop38=(Ranking<=38)*(IncomeGroup=="Lower middle income"))

#Create a table with just the matching records
LMincomeTop38.tbl <- PlotDataset[PlotDataset$LMincomeTop38==1,]
paste(nrow(LMincomeTop38.tbl),"Countries are in the top 38 by GDP with Lower Middle Income", sep =" ")

paste("Countries with Lower middle Income groups in top 38 by GDP rank",sep="")
kable(LMincomeTop38.tbl[,c(2,4,7,5,11,8,3,12)], caption ="Countries with Lower middle Income groups in top 38 by GDP rank")

