
paste("Distinct Incomegroups found in dataset",sep="")
distinct(select(innerjoin_GDP_IG,IncomeGroup))


HighIncomes <- filter(innerjoin_GDP_IG, grepl(pattern = "High income",IncomeGroup ))
by_IncomeGroup <- group_by(HighIncomes, IncomeGroup)
HighIncomeRanks <- summarise(by_IncomeGroup, meanrank = mean(Ranking), medianrank = median(Ranking))

# Question 3
print("Question3: average GDP rankings for High Income: OECD and High Income: nonOECD",sep="")
print(HighIncomeRanks,  digits =2)

