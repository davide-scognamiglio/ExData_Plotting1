#CHECK FOR DEPENDENCIES AND LOADING PACKAGES
list.of.packages <- c("readr", "dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
library(readr)
library(dplyr)

#GET DATA
dataset_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(dataset_url, destfile = "./dataset.zip")
unzip("./dataset.zip")

#DATA IMPORT AND TIDYING
raw_dataset <- read_delim("household_power_consumption.txt",
                          ";",
                          escape_double = FALSE,
                          col_types = cols(Date = col_date(format = "%d/%m/%Y"),
                                           Time = col_time(format = "%H:%M:%S")),
                          trim_ws = TRUE,
                          na = "?")
tidy_dataset <- na.omit(raw_dataset)
tidy_dataset <- subset(tidy_dataset, Date == "2007-02-01" |  Date == "2007-02-02")
DateTime <- paste(tidy_dataset$Date, tidy_dataset$Time)
DateTime <- setNames(DateTime, "DateTime")
tidy_dataset <- tidy_dataset[ ,!(names(tidy_dataset) %in% c("Date","Time"))]
tidy_dataset <- cbind(DateTime, tidy_dataset)

#PLOT 4
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(tidy_dataset, {
    plot(Global_active_power~DateTime, type="l", 
         ylab="Global Active Power (kilowatts)", xlab="")
    plot(Voltage~DateTime, type="l", 
         ylab="Voltage (volt)", xlab="")
    plot(Sub_metering_1~DateTime, type="l", 
         ylab="Global Active Power (kilowatts)", xlab="")
    lines(Sub_metering_2~DateTime,col='Red')
    lines(Sub_metering_3~DateTime,col='Blue')
    legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
           legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    plot(Global_reactive_power~DateTime, type="l", 
         ylab="Global Rective Power (kilowatts)",xlab="")
})
dev.copy(png,"plot4.png", width = 480, height = 480)
dev.off()