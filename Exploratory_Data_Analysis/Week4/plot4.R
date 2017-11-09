getwd()
setwd('Exp.Data')list.files()
summ_pm<-readRDS('summarySCC_PM25.rds')
head(summ_pm)

library(dplyr)
library(ggplot2)
str(summ_pm)

##4
list.files()
source_class<-readRDS('Source_Classification_Code.rds')
head(source_class)
str(source_class)

test<-source_class%>%
        select(EI.Sector)%>%
        group_by(EI.Sector)%>%
        unique()

combined<-merge(summ_pm, source_class, by = 'SCC')

head(combined)

num_four<-combined%>%
        filter(grepl('Coal$', EI.Sector))%>%
        filter(year %in%c('1999','2002','2005','2008'))%>%
        select(year, Emissions)%>%
        group_by(year)%>%
        summarise(Total.Emissions = round(sum(Emissions),0))%>%
        ungroup()

num_four_plot<-ggplot(num_four,aes(year, Total.Emissions))+
        geom_line()+
        geom_point()+
        labs(title = 'Coal Combustion Related Sources - Total PM2.5', x = 'Year', y = "PM2.5 Emission (tonnes)")
png('plot4.png', 480,480)
num_four_plot
dev.off()

##PM2.5 by coal combustion-related sources have decreased significantly since 1999.