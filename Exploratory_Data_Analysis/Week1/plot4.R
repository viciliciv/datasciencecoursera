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

png('plot4.png')
par(mfrow = c(2,2), mar=c(4,4,2,1))
with(df,{
        plot(date_time, Global_active_power, type = 'l', ylab = 'Global Active Power (kilowatts)', xlab = '')
        plot(date_time, Voltage, type = 'l')
        plot(df$date_time, df$Sub_metering_1, type = 'n', ylab = 'Energy sub metering', xlab = '')
        with(df, lines(date_time, Sub_metering_1, col = 'black'))
        with(df, lines(date_time, Sub_metering_2, col = 'red'))
        with(df, lines(date_time, Sub_metering_3, col = 'blue'))
        legend('topright', pch = 1, col = c('black', 'red', 'blue'), legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_2'))
        plot(date_time,Global_reactive_power, type = 'l')
})
dev.off()
