#Verify the files are in the /SourceData folder
#list.files(path = relativeSourcePath)

GDP.raw <- read.csv(GDP.pathtofile,skip=0, strip.white = TRUE,blank.lines.skip = TRUE,colClasses = "character")
paste(nrow(GDP.raw),"Records read from:", GDP.pathtofile,sep=" ")
# open the IncomeGroupByCountry_raw.csv file 
IG.raw <- read.csv(IG.pathtofile, strip.white = TRUE,blank.lines.skip = TRUE,colClasses = "character")
paste(nrow(IG.raw),"Records read from:", IG.pathtofile,sep=" ")

# Examine GDP.raw
#head(GDP.raw,n=50)
#tail(GDP.raw,n=200)
#freq.na(GDP.raw)   # Look for columns of all NA's
#str(GDP.raw)

#Keep rows 5:194 that have valid data, Appears valid for 2012 dataset, recheck source in future years
GDP_DataRows <- GDP.raw[5:194, ]
#Keep the columns with data we need for the study
GDP_DataRowsValidCols <- GDP_DataRows[,c(1,2,4,5)]

#Rename the columns to be descriptive
names(GDP_DataRowsValidCols) <- c("CountryCode","Ranking","CountryName","GDP_Millions_USD")

#Remove the commas from the GDP_Millions_USD column
GDP_DataRowsValidCols$GDP_Millions_USD <- gsub(",","",GDP_DataRowsValidCols$GDP_Millions_USD)

#cast the GDP_Millions_USD column as numeric
GDP_DataRowsValidCols$GDP_Millions_USD <- as.numeric(GDP_DataRowsValidCols$GDP_Millions_USD)


#Verify data classes
#str(GDP_DataRowsValidCols)
#head(GDP_DataRowsValidCols)

#Give it a new name going forward
GDP_Clean <- GDP_DataRowsValidCols

#Verify new cleaned data
#str(GDP_Clean)

#Sort the data
#GDP_Clean <- arrange(GDP_Clean,CountryCode)



##############################################################################
#Examine IncomeGroupByCountry_raw.csv
#head(IG.raw, n= 20)
#tail(IG.raw, n=100)

#Throw out the columns we don't need for this study
IG.reduced <-IG.raw[c(1,2,3)]
#head(IG.reduced, n= 20)
#tail(IG.reduced, n=20)
#IG.reduced[IG.reduced$IncomeGroup =="",]

#Rename the fields we need
names(IG.reduced) <-c("CountryCode", "CountryName","IncomeGroup")

#str(IG.reduced)
#summary(IG.reduced)

#Noticed that there are summary rows with blank Incomegroups that had a country code but looked like regions
#Remove the summary rows with blank Incomegroups
#and Create a new clean dataset to work with
paste(nrow(IG.reduced),"Rows found in Income group dataset before removing blank IncomeGroups",sep=" ")
IG_Removed <- IG.reduced[IG.reduced$IncomeGroup=="",]
IG_Clean <- IG.reduced[!IG.reduced$IncomeGroup=="",]
paste(nrow(IG_Clean),"Rows in Income group dataset after removing blank IncomeGroups",sep=" ")
RowsRemoved <-nrow(IG.reduced)-nrow(IG_Clean)
paste(RowsRemoved,"Rows removed",sep = " ")
#Sort the data
IG_Clean <- arrange(IG_Clean,CountryCode)


#Save cleaned csv file
relativeSourcePath =c("./Analysis/Data")
filename = c("GDPbyCountry_Clean.csv")
pathtofile <- paste(relativeSourcePath, filename, sep="/")
paste("Write cleaned GDP data     :", pathtofile, sep = " ")
write.csv(GDP_Clean, file =pathtofile)


#Save cleaned csv file
relativeSourcePath =c("./Analysis/Data")
filename = c("IncomeGroupByCountry_Clean.csv")
pathtofile <- paste(relativeSourcePath, filename, sep="/")
paste("Write cleaned Income Group :", pathtofile, sep = " ")
write.csv(IG_Clean, file =pathtofile)






