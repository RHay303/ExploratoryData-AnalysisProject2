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
vehiclesBaltimoreNEI <- vehiclesNEI[fips == "24510",]
vehiclesBaltimoreNEI[, city := c("Baltimore City")]

#limit data to only show Los Angeles
vehiclesLANEI <- vehiclesNEI[fips == "06037",]
vehiclesLANEI[, city := c("Los Angeles")]

#combine both cities into one dataset
bothNEI <- rbind(vehiclesBaltimoreNEI,vehiclesLANEI)

#create plot 

png("plot6.png")

g <- ggplot(bothNEI, aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  labs(x="year", y=expression("Total Emission (10^5-Tons)")) + 
  labs(title=expression("Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))

print(g)

while (!is.null(dev.list()))  dev.off()

## --------------------------------------------------------------------------------------------------------------
#convert Rstudio rmd file to r file
knitr::purl("plot6.Rmd")


