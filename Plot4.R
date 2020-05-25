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

# Plot 4. Multigraphs
#
# This plot sets in one png four graphs: previous graphs, voltage and Global 
# Reactive Power by time.
#
# Unique legend have no line in this version, therefore, "topright" parameter 
# can not be used because legend erase the area of the plot. A manual adjustment
# have to be done.
#
# Also, graph must be constructed and save it to a PNG file with a width of 480  
# pixels and a height of 480 pixels.
#

png(filename = "plot4.png",width = 480, height = 480)

par(mfrow = c(2,2), mar = c(4, 4, 2, 1))

# Global Active Power plot

plot(filterdf$datetime, as.numeric(filterdf$Global_active_power),type="l",xlab="",ylab="Global Active Power")

# Voltage plot.

plot(filterdf$datetime, as.numeric(filterdf$Voltage),type="l",xlab="datetime",ylab="Voltage")

# Energy sub metering plot.

plot(filterdf$datetime, as.numeric(filterdf$Sub_metering_1) ,type="l",xlab="",ylab="Energy sub metering")
lines(filterdf$datetime, as.numeric(filterdf$Sub_metering_2),col="red")
lines(filterdf$datetime, as.numeric(filterdf$Sub_metering_3),col="blue")
legend(x=quantile(filterdf$datetime,probs = 0.35),y=max(filterdf$Sub_metering_1),c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lty=1,cex = 0.8,box.lty = 0)

# Global Reactive Power plot.

plot(filterdf$datetime, as.numeric(filterdf$Global_reactive_power),type="l",xlab="datetime",ylab="Global_reactive_power")

# Closing PNG File.

dev.off()

# Restoring par.
par(mfrow = c(1,1))