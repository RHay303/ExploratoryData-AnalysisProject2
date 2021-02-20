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

#split the Emissions_year, from the NEI data object and compute the sum by year
#results is a sum of Emissions for each year

data1 <- aggregate(Emissions~year,data = NEI,FUN = sum)

#Create the barplot and save to png file
dev.list()

png(filename = "plot1.png")

barplot(
  (data1$Emissions)/10^6,
  names.arg = data1$year,
  col = "blue",
  xlab = "Year",
  ylab = "PM2.5 Emissions (10^6 Tons)",
  main = "PM2.5 Emissions for all US Sources (Total)"
  )

#
while (!is.null(dev.list()))  dev.off()


## --------------------------------------------------------------------------------------------------------------
#convert Rstudio rmd file to r file
knitr::purl("plot1.Rmd")


