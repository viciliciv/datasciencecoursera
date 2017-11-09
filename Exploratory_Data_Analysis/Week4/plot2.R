getwd()
setwd('Exp.Data')
list.files()
summ_pm<-readRDS('summarySCC_PM25.rds')
head(summ_pm)

library(dplyr)
library(ggplot2)
str(summ_pm)

##2

balt<-summ_pm%>%
        filter(fips == '24510')%>%
        select(year, Emissions)%>%
        group_by(year)%>%
        summarise(total_emission = sum(Emissions))
png('plot2.png', 480, 480)
plot(balt$year, balt$total_emission, xlab = 'year', ylab = 'PM2.5 (tonnes)',
     main = 'PM2.5 Total Emissions - Baltimore' )
dev.off()

##Based on the plot, PM2.5 in Baltimore has decreased significantly between 1999 and 2008