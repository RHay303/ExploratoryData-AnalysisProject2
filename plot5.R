## ----setup, include=FALSE--------------------------------------------------------------------------------------
library(knitr)
library(ggplot2)
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

#Subset data to only that related to search term of 'vehicle'

condition <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case=TRUE)
vehiclesSCC <- SCC[condition, SCC]
vehiclesNEI <- NEI[NEI[, SCC] %in% vehiclesSCC,]

#limit data to only show Baltimore
data2<-vehiclesNEI[fips=="24510",]

#create plot 

png("plot5.png")

g <- ggplot(data2,aes(factor(year),Emissions)) +
  geom_bar(stat="identity") +
  labs(x="year", y=expression("Total Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))

print(g)

while (!is.null(dev.list()))  dev.off()

## --------------------------------------------------------------------------------------------------------------
#convert Rstudio rmd file to r file
knitr::purl("plot5.Rmd")


