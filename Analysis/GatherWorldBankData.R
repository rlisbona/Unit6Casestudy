# Downloads the worldbank datasets, unless they have already been downloaded

# 
casestudy.link.GDPbyCountry <-c("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv")
casestudy.link.IncomeGroupByCountry <- c("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")


# download GDP by Country data
source.url = casestudy.link.GDP
relativeSourcePath =c("./Analysis/Data")
GDP.filename = c("GDPbyCountry_raw.csv")
GDP.pathtofile <- paste(relativeSourcePath, GDP.filename, sep="/")
#pathtofile
if (!file.exists(GDP.pathtofile)) download(source.url,GDP.pathtofile)


# download IncomeGroup stats
source.url = casestudy.link.Edstats

IG.filename = c("IncomeGroupByCountry_raw.csv")
IG.pathtofile <- paste(relativeSourcePath, IG.filename, sep="/")
#pathtofile
if (!file.exists(IG.pathtofile)) download(source.url,IG.pathtofile)
