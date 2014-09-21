# Exploratory Data Analysis - Course Project 2 - plot6
#   This is my work for the second assignment (plot 6)

#Should move loading data to another function/script as it is common to all plots

#load necessary libraries
library(plyr)



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
NEISCCMarylandAndLosAngeles <- NEISCC[NEISCC$fips == '24510' | NEISCC$fips == '06037',]

#I assume that for 'motor' emissions, the dataset would contain the word 'motor'
#  hence, we take only the subset with that data
NEISCCMarylandAndLosAngelesMotorFactors <- subset(NEISCCMarylandAndLosAngeles, grepl('(?i)motor', NEISCCMarylandAndLosAngeles$Short.Name))

#Get sum total of each type of pollution
#NEISCCMarylandAndLosAngelesMotorFactorsTotal <- ddply(NEISCCMarylandAndLosAngelesMotorFactors, .(fips, year), summarize, EmissionsTotal = sum(Emissions))

f <- factor(NEISCCMarylandAndLosAngelesMotorFactors$fips, labels = c('Emissions (Los Angeles - Motor)', 'Emissions (Baltimore City - Motor)'))
panel.regression <- function(x, y, ...) {
  panel.xyplot(x, y, ...) # show points 
  panel.lmline(x, y, col=2)  # show smoothed line 
}

trellis.device(device='png', filename='plot6.png')

plot <- xyplot(NEISCCMarylandAndLosAngelesMotorFactors$Emissions 
		~ NEISCCMarylandAndLosAngelesMotorFactors$year 
		| f, 
	panel = panel.regression,
	xlab="Year",
	ylab="Emissions",	
	layout = c(2, 1))



print(plot)
              

dev.off()
