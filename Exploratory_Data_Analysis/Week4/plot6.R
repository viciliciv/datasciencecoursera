getwd()
setwd('Exp.Data')
list.files()
summ_pm<-readRDS('summarySCC_PM25.rds')
head(summ_pm)

library(dplyr)
library(ggplot2)
library(gridExtra)
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

#####

##6
num_six<-combined%>%
        filter(grepl('Mobile', EI.Sector))%>%
        filter(fips %in% c('24510', '06073'))%>%
        mutate(Location = ifelse(fips == '24510', 'Baltimore City, MD', 'Los Angeles County'))%>%
        select(year, Emissions, Location)%>%
        group_by(year, Location)%>%
        summarise(Total.Emissions = round(sum(Emissions)))%>%
        ungroup()

num_six_plot<-ggplot(num_six, aes(year, Total.Emissions))+
        geom_point(aes(color = Location))+
        geom_line(aes(color = Location))+
        labs(title = 'Emissions from Motor Vehicle Sources',
             x = 'Year', y = 'PM2.5 (Tonnes)')

init_six<-num_six%>%
        filter(year == '1999')%>%
        select(Location, init_emissions = Total.Emissions)

ext_num_six<-merge(num_six, init_six, by = 'Location', all.x = TRUE)
ext_num_six<-ext_num_six%>%
        mutate(Diff_Emissions = round((Total.Emissions-init_emissions)/init_emissions*100,2))
str(ext_num_six)


ext_num_six_plot<-ggplot(subset(ext_num_six, year == '2008'), aes(factor(year),Diff_Emissions, fill = Location))+
        geom_bar(stat = 'identity', position = position_dodge())+
        geom_label(aes(label = Diff_Emissions), show.legend = FALSE)+
        labs(title = 'Percent Difference in Emissions between 1999 and 2008', x ='Year', y = 'PM2.5 Percent Difference')


png('plot6.png', 480, 480)
grid.arrange(num_six_plot, ext_num_six_plot)
dev.off()

##Although LA county reduced significantly more PM2.5, Baltimore showed the largest percentage difference in reducing PM2.5 emissions since 1999. 