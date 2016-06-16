#Verify the files are in the /SourceData folder
list.files(path = relativeSourcePath)

GDP.raw <- read.csv(GDP.pathtofile,skip=0, strip.white = TRUE,blank.lines.skip = TRUE)

# open the IncomeGroupByCountry_raw.csv file 
IG.raw <- read.csv(IG.pathtofile, strip.white = TRUE,blank.lines.skip = TRUE)

# Examine GDP.raw
head(GDP.raw,n=50)
tail(GDP.raw,n=200)
freq.na(GDP.raw)   # Look for columns of all NA's
str(GDP.raw)

#Keep rows 5:194 that have valid data, Appears valid for 2012 dataset, recheck source in future years
GDP_DataRows <- GDP.raw[5:194, ]
#Keep the columns with data we need for the study
GDP_DataRowsValidCols <- GDP_DataRows[c(1,2,4,5)]

#Rename the columns to be descriptive
names(GDP_DataRowsValidCols) <- c("CountryCode","Ranking","CountryName","GDP_Millions_USD")

#Remove the commas from the GDP_Millions_USD column
GDP_DataRowsValidCols$GDP_Millions_USD <- gsub(",","",GDP_DataRowsValidCols$GDP_Millions_USD)

#cast the GDP_Millions_USD column as numeric
GDP_DataRowsValidCols$GDP_Millions_USD <- as.numeric(GDP_DataRowsValidCols$GDP_Millions_USD)

#cast Countrycode and Countryname as Character
GDP_DataRowsValidCols$CountryCode <- as.character(GDP_DataRowsValidCols$CountryCode)
GDP_DataRowsValidCols$CountryName <- as.character(GDP_DataRowsValidCols$CountryName)

#cast Ranking as integer
GDP_DataRowsValidCols$Ranking <- as.integer(GDP_DataRowsValidCols$Ranking)

#Verify data classes
str(GDP_DataRowsValidCols)
head(GDP_DataRowsValidCols)

#Give it a new name going forward
GDP_Clean <- GDP_DataRowsValidCols

#Verify new cleaned data
str(GDP_Clean)

#Sort the data
GDP_Clean <- arrange(GDP_Clean,CountryCode)

#Save cleaned csv file
relativeSourcePath =c("./Analysis/Data")
filename = c("GDPbyCountry_Clean.csv")
pathtofile <- paste(relativeSourcePath, filename, sep="/")
write.csv(GDP_Clean, file =pathtofile)

##############################################################################
#Examine IncomeGroupByCountry_raw.csv
head(IG.raw, n= 20)
tail(IG.raw, n=100)

#Throw out the columns we don't need for this study
IG.reduced <-IG.raw[c(1,2,3)]
head(IG.reduced, n= 20)
tail(IG.reduced, n=20)

#Rename the fields we need
names(IG.reduced) <-c("CountryCode", "CountryName","IncomeGroup")

str(IG.reduced)
summary(IG.reduced)

#Set the column classes
IG.reduced$CountryCode <- as.character(IG.reduced$CountryCode)
IG.reduced$CountryName <- as.character(IG.reduced$CountryName)


#Noticed that there are summary rows with blank Incomegroups that had a country code but looked like regions
#Remove the summary rows with blank Incomegroups
#and Create a new clean dataset to work with
paste("Income groups Rows before removing blank IncomeGroups=",nrow(Country.reduced),sep="")
IG_Clean <- Country.reduced[!Country.reduced$IncomeGroup=="",]
paste("Country Rows after removing blank IncomeGroups=",nrow(Country_Clean),sep="")

#Sort the data
IG_Clean <- arrange(IG_Clean,CountryCode)

#Save cleaned csv file
relativeSourcePath =c("./Analysis/Data")
filename = c("IncomeGroupByCountry_Clean.csv")
pathtofile <- paste(relativeSourcePath, filename, sep="/")
write.csv(IG_Clean, file =pathtofile)






