# make sure this is in Rmarkdown output: md_document
install.packages("questionr")

getwd()
#setwd("C:/Users/anobs/Documents/GitHub/Unit6Casestudy")

# used these first but I was getting odd looking data ...
casestudy.link.GDP <-c("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv")
casestudy.link.Edstats <- c("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")


# download GDP data
source.url = casestudy.link.GDP
relativeSourcePath =c("./Sourcedata")
GDP.filename = c("GDP2.csv")
GDP.pathtofile <- paste(relativeSourcePath, GDP.filename, sep="/")
#pathtofile
if (!file.exists(GDP.pathtofile)) download(source.url,GDP.pathtofile)


# download Education stats
source.url = casestudy.link.Edstats

EDU.filename = c("EDSTATS_Country2.csv")
EDU.pathtofile <- paste(relativeSourcePath, EDU.filename, sep="/")
#pathtofile
if (!file.exists(EDU.pathtofile)) download(source.url,EDU.pathtofile)




#Verify the files are in the /SourceData folder
list.files(path = relativeSourcePath)

GDP.raw <- read.csv(GDP.pathtofile,skip=0, strip.white = TRUE,blank.lines.skip = TRUE)

# open the EDSTATS_Country.csv file 
edstats.Country.raw <- read.csv(EDU.pathtofile, strip.white = TRUE,blank.lines.skip = TRUE)

# Review the data
head(GDP.raw,n=50)
tail(GDP.raw,n=200)

freq.na(GDP.raw)   # Look for columns of all NA's
str(GDP.raw)

#Keep rows 5:194 that have valid data, Appears valid for 2012 dataset, recheck source in future years
GDP_DataRows <- GDP.raw[5:194, ]
#Keep the columns with data we need
GDP_DataRowsValidCols <- GDP_DataRows[,c(1,2,4,5)]

#Rename the columns to be descriptive
names(GDP_DataRowsValidCols) <- c("CountryCode","Ranking","CountryName","GDP_Millions_USD")

#Remove the commas from the Dollars column
GDP_DataRowsValidCols$GDP_Millions_USD <- gsub(",","",GDP_DataRowsValidCols$GDP_Millions_USD)

#cast the Dollars column as numeric
GDP_DataRowsValidCols$GDP_Millions_USD <- as.numeric(GDP_DataRowsValidCols$GDP_Millions_USD)

#cast Countrycode and Countryname as Character
GDP_DataRowsValidCols$CountryCode <- as.character(GDP_DataRowsValidCols$CountryCode)
GDP_DataRowsValidCols$CountryName <- as.character(GDP_DataRowsValidCols$CountryName)

#cast Ranking as integer
GDP_DataRowsValidCols$Ranking_int <- as.integer(GDP_DataRowsValidCols$Ranking)

#Verify data classes
str(GDP_DataRowsValidCols)

head(GDP_DataRowsValidCols)

#Give it a new name going forward
#GDP_Clean <- arrange(GDP_DataRowsValidCols,Ranking)
GDP_Clean <- GDP_DataRowsValidCols[order(GDP_DataRowsValidCols$Ranking), ]

#Verify new cleaned data
str(GDP_Clean)


#Examine education stats data
#head(edstats.Country.raw, n= 20)
#tail(edstats.Country.raw, n=100)

#Throw out the columns we don't need for this study
edstats.Country.reduced <-edstats.Country.raw[c(1,2,3)]
#head(edstats.Country.reduced, n= 20)
#tail(edstats.Country.reduced, n=20)

#Rename the fields we need
names(edstats.Country.reduced) <-c("CountryCode", "CountryName","IncomeGroup")

str(edstats.Country.reduced)
summary(edstats.Country.reduced)

#Set the column classes
edstats.Country.reduced$CountryCode <- as.character(edstats.Country.reduced$CountryCode)
edstats.Country.reduced$CountryName <- as.character(edstats.Country.reduced$CountryName)

#Remove the summary rows with blank Incomegroups
# and Create a new clean dataset to work with
Edstats_Clean <- edstats.Country.reduced[!edstats.Country.reduced$IncomeGroup=="",]
#nrow(Edstats_Clean)
#Count records in each data.frame
paste("Number of countries with GDP data =",nrow(GDP_Clean),sep="")
paste("Number of countries with Incomegroup data =",nrow(Edstats_Clean),sep="")

#Check it, select the top N rows from each data.frame to check the merge queries
#GDP_Clean
GDP_Clean_sub <- arrange(GDP_Clean,CountryCode)
GDP_Clean_sub.set <- GDP_Clean_sub[1:nrow(GDP_Clean_sub),]
GDP_Clean_sub.set

Edstats_Clean_sub <- arrange(Edstats_Clean,CountryCode)
Edstats_Clean_sub.set <- Edstats_Clean_sub[1:nrow(Edstats_Clean_sub),]
Edstats_Clean_sub.set

mergeleft <- left_join(GDP_Clean_sub.set,Edstats_Clean_sub.set, by = "CountryCode")
innerjoin <- inner_join(GDP_Clean_sub.set,Edstats_Clean_sub.set, by = "CountryCode")
innerjoin <- inner_join(GDP_Clean_sub.set,Edstats_Clean_sub.set, by = "CountryCode")
fulljoin <- full_join(GDP_Clean_sub.set,Edstats_Clean_sub.set, by = "CountryCode")

temp <- arrange(fulljoin,CountryCode)
temp

temp_df <- tbl_df(temp)
temp[13,]
nth(temp$CountryName.x,13)
print(fulljoin, right = FALSE, row.names = TRUE)
print(temp_df,right = FALSE,row.names=TRUE)


length(mergeleft)
length(fulljoin)
nrow(mergeleft)
dim(is.na(mergeleft$IncomeGroup))
     
str(Edstats_Clean)
subEdstats <- filter(Edstats_Clean, CountryCode == "STP")

#Combine the datasets for further analysis
Combined_GDP_Edstats <- merge(GDP_Clean,Edstats_Clean,by.GDP_Clean="CountryCode", all=TRUE)
str(Combined_GDP_Edstats)

#inner_join(x, y, by = NULL, copy = FALSE, ...): return all rows from x where there are matching values in y, and all columns from x and y
#left_join(x, y, by = NULL, copy = FALSE, ...): return all rows from x, and all columns from x and y
#semi_join(x, y, by = NULL, copy = FALSE, ...): return all rows from x where there are matching values in y, keeping just columns from x.
#anti_join(x, y, by = NULL, copy = FALSE, ...): return all rows from x where there are not matching values in y, keeping just columns from x
