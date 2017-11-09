getwd()
setwd('Exp.Data')
list.files()
summ_pm<-readRDS('summarySCC_PM25.rds')
head(summ_pm)

library(dplyr)
library(ggplot2)
str(summ_pm)


##3
balt_type<-summ_pm%>%
        filter(fips == '24510')%>%
        filter(year %in% c('1999','2002','2005','2008'))%>%
        mutate(type = factor(type))%>%
        select(year,type, Emissions)%>%
        group_by(year,type)%>%
        summarise(total_emission = sum(Emissions))%>%
        ungroup()
str(balt_type)
balt_type_plot<-ggplot(balt_type,aes(year, total_emission))+
        geom_line(aes(color = type))+
        geom_point(aes(color = type))+
        labs(title = 'Total Emissions by Type - Baltimore', x= 'Year', y= 'PM2.5 (Tonnes)')
png('plot3.png', 480, 480)
balt_type_plot
dev.off()

##Emission of PM2.5 by Non-Road, Nonpoint, and On-Road type has decreased since 1999 but Point type has increased since 1999.