# Exploratory data analysis - Week 1 assignment

library(data.table)

# Dataset to download and unzip
data.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

data.filename <- "household_power_consumption.txt"

# Note: Somehow doesn't detect ? as NA... according to docs, this happens only after
# conversion to numeric, hence it fails. So read all as character first, then
# convert to NA
dt <- fread(data.filename, sep=";", header=TRUE, na.strings = c("?"), 
            colClasses = rep("character", 9))
setkey(dt)

dt <- dt[Date == "1/2/2007" | Date == "2/2/2007"]

dt[,Date := as.Date(Date)]
set(dt, j="Time", value=lapply(dt[,Time], strptime, format="%T"))
dt[,Global_active_power := as.numeric(Global_active_power)]
dt[,Global_reactive_power := as.numeric(Global_reactive_power)]
dt[,Voltage := as.numeric(Voltage)]
dt[,Global_intensity := as.numeric(Global_intensity)]
dt[,Sub_metering_1 := as.numeric(Sub_metering_1)]
dt[,Sub_metering_2 := as.numeric(Sub_metering_2)]
dt[,Sub_metering_3 := as.numeric(Sub_metering_3)]

png(filename = "plot1.png", width = 480, height = 480)
hist(dt$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
dev.off()
