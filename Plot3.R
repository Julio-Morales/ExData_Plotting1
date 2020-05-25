# 0. Libraries.
# 

# 1. Getting data from source.
#
# According to assignment, data can be obtained from the following URL in zip 
# format.
#

zipfileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zfile <- "./Data/Dataset.zip"

# 1.a Preparing to extract files.
# 
# Data is stored in directory "./Data". If it does not exist, it would be 
# created.
# All zipped files will be extracted into "./Data" directory.

if(!file.exists(".Data")) {dir.create("./Data")}
download.file(zipfileUrl,destfile = zfile, method = "curl")
unzip(zfile,exdir = "./Data")

# 1.b Loading files into R tables.
# 
# Dataset is in text format contained at 
# "./Data/household_power_consumption.txt". This file has 
# headers at the first row and data is separated by ";" and
# Date is formatted as "%d/%m/%y", for instance, requires 
# dates are 2007-02-01 and 2007-02-02 with format "1/2/2007"
# and "2/2/2007", therefore conversion is needed.
#
# In addition, date and time must be joined in a new variable
# called datetime.
#

RawPowerConsumption <- read.table("./Data/household_power_consumption.txt",sep = ";", header =  TRUE,stringsAsFactors = FALSE)
filterdf <- subset(RawPowerConsumption,Date == "1/2/2007" | Date == "2/2/2007",select = Date:Sub_metering_3)
filterdf$datetime <- as.POSIXct(strptime(paste(filterdf$Date,filterdf$Time), "%d/%m/%Y %H:%M:%S"))

# Plot 3. Multivariable
#
# Require plot uses Sub_metering_1, Sub_metering_2 and Sub_metering_3 variables
# by time. 
# 
# Also, graph must be constructed and save it to a PNG file with a width of 480  
# pixels and a height of 480 pixels.
#

png(filename = "plot3.png",width = 480, height = 480)
plot(filterdf$datetime, as.numeric(filterdf$Sub_metering_1) ,type="l",xlab="",ylab="Energy sub metering")
lines(filterdf$datetime, as.numeric(filterdf$Sub_metering_2),col="red")
lines(filterdf$datetime, as.numeric(filterdf$Sub_metering_3),col="blue")
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lty=1,cex = 0.8)
dev.off()

