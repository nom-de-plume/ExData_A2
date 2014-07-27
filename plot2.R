# Exploratory Data Analysis - Course Project 2 - plot2
#   This is my work for the second assignment (plot 2)

#Should move loading data to another function/script as it is common to all plots

#load necessary libraries
library(reshape2)



#static variables
doLoadData <- FALSE #choose whether to load the data from the file (just shortcut if data is already loaded)

urlFileName <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zipFileName <- "./exdata_data_NEI_data.zip"
sccFileName <- "./Source_Classification_Code.rds"
neiFileName <- "./summarySCC_PM25.rds"

# download and/or extract file if it does not exist
if (!file.exists(zipFileName)) {
	download.file(urlFileName, zipFileName, 'curl')
}

if (!file.exists(sccFileName) || !file.exists(neiFileName)) {
	unzip(zipFileName);
}


# from here on we assume that rds files exists 

# load data
if (doLoadData) {
	## This first line will likely take a few seconds. Be patient! 
	NEI <- readRDS(neiFileName)
	SCC <- readRDS(sccFileName)

}

#Get the maryland records only
NEIMaryland <- NEI[NEI$fips == '24510',]

#Get the total emissions
total_emissions_maryland <- tapply(NEIMaryland$Emissions, NEIMaryland$year, sum)

V1 <- as.numeric(names(total_emissions_maryland))
V2 <-as.vector(total_emissions_maryland)

#Do the actual histogram plot and export to png
png(file = 'plot2.png', 
		width = 480, 
		height = 480,
		bg = 'transparent')

plot(V1, V2, 
        type='b',
		ylab = 'Total Emissions (PM_{2.5}) (Maryland)',
        xlab = 'Year')

dev.off()

