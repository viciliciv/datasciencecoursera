library(sqldf)
library(dplyr)

#reads using sqldf to filter out for specified date.
#avoids of reading the large file
nums<-read.csv.sql('household_power_consumption.txt', 
                   "select * from file where Date in ('2/2/2007', '1/2/2007') ", sep=';')
df<-nums
df$weekday<-weekdays(as.Date(df$Date,'%d/%m/%Y'))
df$date_time<-paste(df$weekday,df$Date,df$Time)
df$date_time<-strptime(df$date_time, "%A %d/%m/%Y %H:%M:%S")
str(df)
number_list<-c('Global_active_power', 'Global_reactive_power', 'Voltage', 'Global_intensity', 'Sub_metering_1',
               'Sub_metering_2', 'Sub_metering_3')
df[number_list]<-sapply(df[number_list], as.numeric)

png('plot1.png')
hist(df$Global_active_power, xlab = 'Global Active Power (kilowatts)', col = 'red', 
     main = 'Global Active Power')
dev.off()
