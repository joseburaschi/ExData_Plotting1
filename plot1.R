# Exploratory Data Analysis
# Project 1 
# March 2015
#
# load libraries required for this exercise
library(sqldf)
# sqldf also requires the following packages: gsubfn, proto, RSQLite, DBI, tcltk

# Set working directory
#setwd("/Users")

# Retrieve and echo current working directory to which the file will be downloaded
getwd()

# URL and name of dataset to download to create PNG formatted output
sourceDatasetURL <- "https://d396qusza40orc.cloudfront.net/exdata/data/"
zippedFileName <- "household_power_consumption.zip"
unzippedFileName <- "household_power_consumption.txt"
filteredFileName <- "householdsToProcess.txt"
plotFileName <- "plot1.png"

# Download file command
download.file(paste(sourceDatasetURL,zippedFileName,sep=""), destfile=zippedFileName, method="curl")
unzip(zippedFileName, overwrite = TRUE)

# Filer file to only 2007-02-01 and 2007-02-02 dated samples
#
# On Macs using a system command to run egrep is faster instead of using sqldf
#
#if (.Platform$OS.type == 'unix') {
#  system(paste("egrep '^[12]{1}\\/2\\/2007;' ", unzippedFileName, " > ", filteredFileName ))
#  householdConsumption = read.table(filteredFileName, sep = ";", header = FALSE)
#} 

dataFileConn <- file(unzippedFileName)

# Filer file to only 2007-02-01 and 2007-02-02 dated samples
householdConsumption <- read.csv2.sql(dbname = tempfile(), sql = "select * from dataFileConn where Date = '1/2/2007' or Date = '2/2/2007'", overwrite=TRUE)

# close sqldf connection
close(dataFileConn)
sqldf()

# assign column names if none are assigned
# colnames(householdConsumption) = c('Date','Time','Global_active_power','Global_reactive_power','Voltage','Global_intensity','Sub_metering_1','Sub_metering_2','Sub_metering_3')

#  Examine head of file
#head(householdConsumption)

#Test
#as.POSIXct(strptime("1/2/2007 01:53:00", "%d/%m/%Y %H:%M:%S"))

#Add columnn with date time value concatenating Date and Time columns
householdConsumption$dTime = as.POSIXct(strptime(paste(householdConsumption$Date,householdConsumption$Time), "%d/%m/%Y %H:%M:%S"))

#Add column for the day of the week
# hC$wd = weekdays(hC$dTime)

if (length(dev.list()) > 0) {
  dev.off(dev.list()["RStudioGD"])
}

png(plotFileName, height = 480, width = 480, units = "px", bg = "transparent")
par(mfrow = c(1,1), bg="transparent")
hist(householdConsumption$Global_active_power,col = "Red", freq = TRUE, xlab = "Global Active Power (kilowatts)", main = "Global Active Power", cex.axis=0.75, cex.lab=0.75, cex.main=0.9)

#Alternate way to print to PNG File copy plot to a PNG file
#dev.copy(png, file = plotFileName, width = 480, height = 480, units = "px", bg="transparent")
dev.off()
