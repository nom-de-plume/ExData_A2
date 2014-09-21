# Exploratory Data Analysis - Course Project 2 - plot5
#   This is my work for the second assignment (plot 5)

#Should move loading data to another function/script as it is common to all plots

#load necessary libraries
library(ggplot2)
#library(plyr)



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
	
	#Merging datasets so we can work on getting the correct data out
	NEISCC <- merge(NEI, SCC, by='SCC', all.x=TRUE, all.y=FALSE)

}

#Get the Maryland records only
NEISCCMaryland <- NEISCC[NEISCC$fips == '24510',]

#I assume that for 'motor' emissions, the dataset would contain the word 'motor'
#  hence, we take only the subset with that data
NEISCCMarylandMotorFactors <- subset(NEISCCMaryland, grepl('(?i)motor', NEISCCMaryland$Short.Name))

#Get sum total of each type of pollution
#NEISCCMarylandMotorFactorsTotal <- ddply(NEISCCMarylandMotorFactors, .(year), summarize, EmissionsTotal = sum(Emissions))

png(file = 'plot5.png', 
		width = 480, 
		height = 480,
		bg = 'transparent')

g <- ggplot(NEISCCMarylandMotorFactors, aes(year, Emissions))

p <- g + geom_point() + geom_smooth(method = "lm") + coord_cartesian(ylim = c(-1, 20)) + labs(title = "Motor Emissions (Baltimore City)") + labs(x = "Year") + labs(y = "Emissions")

print(p)

dev.off()
