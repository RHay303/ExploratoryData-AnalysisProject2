## ----setup, include=FALSE--------------------------------------------------------------------------------------
library(knitr)
library("data.table")
knitr::opts_chunk$set(echo = TRUE)
setwd("C:/Users/rp303/OneDrive/Documents/coursera data science/ExploratoryData-AnalysisProject2")


## --------------------------------------------------------------------------------------------------------------


path <- getwd()
filename<-"dataFiles.zip"

if(!file.exists(filename)){
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
    unzip(zipfile = "dataFiles.zip")
}

#load data into SCC (Source Classification Code) and NEI (SummarySCC_PM25) if we haven't already

if(!exists("SCC")){
  SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
}
if(!exists("NEI")){
  NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))
}


## --------------------------------------------------------------------------------------------------------------

#limit data to only show Baltimore

data2<-(NEI[NEI$fips == "24510",])

#add up emissions for each year for Baltimore

data3<-aggregate(Emissions~year,data = data2,FUN = sum)

#create plot 
png(filename="plot2.png")

barplot(height=data3$Emissions, names.arg=data3$year, xlab="Year", ylab="Emissions by Ton", main="Total Emissions for Baltimore")

#
while (!is.null(dev.list()))  dev.off()


## --------------------------------------------------------------------------------------------------------------
#convert Rstudio rmd file to r file
knitr::purl("plot2.Rmd")


