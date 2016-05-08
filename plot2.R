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

# Make the plot
png("plot2.png", width=480, height=480)
plot(datetime, globalActivePower, type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.off()
