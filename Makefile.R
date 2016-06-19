######################################################
# Make file for week 6 case study, Worldbank income groups
# Author: Randy Lisbona
# Updated 6/15/2016
#######################################################

# Load libraries used in this project
library("downloader")
#install.packages("dplyr")
library("dplyr")
#install.packages("plyr")
library("plyr")
library("questionr")
library("ggplot2")
library("magrittr")
#install.packages("devtools")
library(devtools)
#install_github("plotflow", "trinker")
#install.packages("scales")
library("knitr")
library("scales")

# Set working directory

Currentdir <- getwd()
setwd(Currentdir)

#setwd("C:/Users/anobs/Documents/GitHub/Unit6Casestudy")

# Download worldbank data sets  
#      /analysis/data/GDPbyCountry_raw.csv
#      /analysis/data/IncomeGroupByCountry_raw.csv
source("./Analysis/GatherWorldBankData.R", echo = FALSE,print.eval=TRUE)

# Create cleaned .csv files
#      /analysis/data/GDPbyCountry_Clean.csv
#      /analysis/data/IncomeGroupByCountry_Clean.csv

source("./Analysis/CleanWorldBankData.R", echo = FALSE,print.eval=TRUE)

# Merge the data
source("./Analysis/MergeWorldBankData.R", echo = FALSE, print.eval=TRUE)


# Analysis
source("./Analysis/AnalyzeWorldBankData.R", echo = FALSE, print.eval=TRUE)
