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

png(filename = "plot4.png", width = 480, height = 480)
par(mfrow = c(2,2))

with(dt, {
  # Plot 1
  plot(Global_active_power, type = "l", ylab = "Global Active Power")
  axis.Date(side = 2, at = dt$Date, format="%a", labels = TRUE)
  
  # Plot 2
  plot(Voltage, type = "l", ylab = "Voltage")
  axis.Date(side = 2, at = dt$Date, format="%a", labels = TRUE)
  
  # Plot 3
  plot(Sub_metering_1, type = "s", col = "black", ylab = "Energy sub metering")
  lines(Sub_metering_2, type = "s", col = "red")
  lines(Sub_metering_3, type = "s", col = "blue")
  legend(x="topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1, 1), col = c("black", "red", "blue"), bty = "n")
  
  # Plot 4
  plot(Global_reactive_power, type = "l")
})
dev.off()
