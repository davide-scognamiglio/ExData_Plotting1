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

#PLOT 2
par(mar = c(4, 4, 2, 2))
tidy_dataset$DateTime <- as.POSIXct(DateTime)
plot(tidy_dataset$Global_active_power~tidy_dataset$DateTime,
     type="l",
     ylab="Global Active Power (kilowatts)",
     xlab="")
dev.copy(png,"plot2.png", width = 480, height = 480)
dev.off()


