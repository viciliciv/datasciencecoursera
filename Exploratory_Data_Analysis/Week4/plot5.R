getwd()
setwd('Exp.Data')
list.files()
summ_pm<-readRDS('summarySCC_PM25.rds')
head(summ_pm)

library(dplyr)
library(ggplot2)
str(summ_pm)

list.files()
source_class<-readRDS('Source_Classification_Code.rds')
head(source_class)
str(source_class)

test<-source_class%>%
        select(EI.Sector)%>%
        group_by(EI.Sector)%>%
        unique()

combined<-merge(summ_pm, source_class, by = 'SCC')


##5

num_five<-combined%>%
        filter(grepl('Mobile', EI.Sector))%>%
        filter(fips == '24510')%>%
        select(year, Emissions)%>%
        group_by(year)%>%
        summarise(Total.Emissions = round(sum(Emissions)))%>%
        ungroup()

num_five_plot<-ggplot(num_five, aes(year, Total.Emissions))+
        geom_point()+
        geom_line()+
        labs(title = 'Emissions from Motor Vehicle Sources - Baltimore',
             x = 'Year', y = 'PM2.5 (Tonnes)')

png('plot5.png', 480, 480)
num_five_plot
dev.off()

##Since 1999, emission emitted by motor vehicle sources have decreased. But PM2.5 has emissions has increased since 2002. 