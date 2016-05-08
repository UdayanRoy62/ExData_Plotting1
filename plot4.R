dataFile <- "household_power_consumption.txt"

# If dataFile is not in the working directory, the following code looks for 
# the corresponding zipped file. If the zipped data file is in the working directory,
# the code unzips. If even the zipped data file is missing from the working directory,
# the code downloads the data from the Web and unzips it.

if(!file.exists(dataFile)) {
  zipped_file <- "exdata-data-household_power_consumption.zip"
  if(!file.exists(zipped_file)) {
    temp <- tempfile()
    download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
    dataFile <- unzip(temp)
    unlink(temp)
    rm(temp)
  } 
  else {
    # zipped_file <- "exdata-data-household_power_consumption.zip"
    dataFile <- unzip(zipped_file)
    rm(zipped_file)
  }
}

# Next, read the data and subset it for the two days we are interested in
data <- read.table(dataFile, header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".", na.strings="?")
subSetData <- data[data$Date %in% c("1/2/2007","2/2/2007") ,]
rm(data)

# Next, prepare the data for plotting
datetime <- strptime(paste(subSetData$Date, subSetData$Time, sep=" "), "%d/%m/%Y %H:%M:%S") 
globalActivePower <- as.numeric(subSetData$Global_active_power)
globalReactivePower <- as.numeric(subSetData$Global_reactive_power)
voltage <- as.numeric(subSetData$Voltage)
subMetering1 <- as.numeric(subSetData$Sub_metering_1)
subMetering2 <- as.numeric(subSetData$Sub_metering_2)
subMetering3 <- as.numeric(subSetData$Sub_metering_3)

# Make the plot
png("plot4.png", width=480, height=480)
par(mfrow = c(2, 2)) 

plot(datetime, globalActivePower, type="l", xlab="", ylab="Global Active Power", cex=0.2)

plot(datetime, voltage, type="l", xlab="datetime", ylab="Voltage")

plot(datetime, subMetering1, type="l", ylab="Energy Submetering", xlab="")
lines(datetime, subMetering2, type="l", col="red")
lines(datetime, subMetering3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=, lwd=2.5, col=c("black", "red", "blue"), bty="o")

plot(datetime, globalReactivePower, type="l", xlab="datetime", ylab="Global_reactive_power")

dev.off()
