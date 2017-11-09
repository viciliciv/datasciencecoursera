getwd()
setwd('Exp.Data')
list.files()
summ_pm<-readRDS('summarySCC_PM25.rds')
head(summ_pm)

library(dplyr)
library(ggplot2)
str(summ_pm)



###1
sums<-summ_pm%>%
        select(year, Emissions)%>%
        group_by(year)%>%
        summarise(total_emission = sum(Emissions))
png('plot1.png', 480, 480)
plot(sums$year, sums$total_emission, xlab = 'year', ylab = 'PM2.5 (tonnes)', 
     main = 'Total PM2.5 Emissions in USA')
dev.off()

#calculates percent difference of PM2.5 between 1999 and 2008
(sums$total_emission[sums$year == 2008] - sums$total_emission[sums$year == 1999])/sums$total_emission[sums$year == 1999]

###Total PM2.5 has decreased significantly since 1999 by 53%.