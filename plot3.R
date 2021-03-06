# Exploratory Data Analysis - Course Project 2 - plot3
#   This is my work for the second assignment (plot 3)

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

}

#Get the Maryland records only
NEIMaryland <- NEI[NEI$fips == '24510',]

#Get sum total of each type of pollution
#NEIMarylandFactors <- ddply(NEIMaryland, .(year, type), summarize, EmissionsTotal = sum(Emissions))

#Get the emissions

png(file = 'plot3.png', 
		width = 480, 
		height = 480,
		bg = 'transparent')
		
#g <- ggplot(NEIMarylandFactors, aes(year, EmissionsTotal))
g <- ggplot(NEIMaryland, aes(year, Emissions))

#p <- g + geom_point() + facet_grid(. ~ type) + geom_smooth(method = "lm") + coord_cartesian(ylim = c(-1, 2500))
#p <- g + geom_point() + facet_grid(. ~ type) + geom_smooth(method = "lm",se=FALSE) + coord_cartesian(ylim = c(-1, 100))
#p <- g + geom_point() + facet_grid(. ~ type)  + geom_line()
#p <- g + geom_point() + facet_grid(. ~ type)  + geom_boxplot()
p <- g + geom_point() + facet_grid(. ~ type) + geom_smooth(method = "lm") + coord_cartesian(ylim = c(-1, 400)) + labs(title = "Emissions") + labs(x = "Year") + labs(y = "Emissions")

print(p)


dev.off();
