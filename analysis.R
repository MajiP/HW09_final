gap_data <- read.table('gapminder.tsv', header = TRUE, sep = '\t', quote = '\"')

suppressPackageStartupMessages(library(dplyr))
library(ggplot2)

glimpse(gap_data)

#I want to know how many observations there are for each country by continet and year
table(gap_data$continent, gap_data$year)
nlevels(gap_data$country)
levels(gap_data$continent)

#I plot the change in gdp per capita for each continent
gap_data %>% ggplot(aes(year, gdpPercap)) + geom_point()+scale_y_log10()+facet_wrap(~continent)+stat_summary(fun.y=mean, colour="red", geom="point") +theme(axis.text.x=element_blank())
gap_gdp <- gap_data %>% group_by(continent) %>% summarise(gdpsd=sd(gdpPercap)) %>% ungroup()

#i want to reorder continents on basis of gdppercap std deviation, excluding Oceania which has only 2 countries
gap_new <- gap_gdp %>% mutate(continent=reorder(continent, gdpsd)) %>% filter(continent!="Oceania") %>%  droplevels()
newcontlevels <- levels(gap_new$continent)
gap_data <- gap_data %>% filter(continent!="Oceania") %>% mutate(continent=factor(as.character(continent), levels=newcontlevels)) %>% arrange(continent)
levels(gap_data$continent)

#now I plot the same graph with new continent order and save it to file
gap_data %>% ggplot(aes(year, gdpPercap)) + geom_point()+facet_wrap(~continent)+stat_summary(fun.y=mean, colour="red", geom="point") +theme(axis.text.x=element_blank())
ggsave("gdpPercap.png")

#filtering  max and min gdp percap per continent by year
gap_gdpminmax <- gap_data %>% 
	group_by(continent, year) %>%
	mutate(rankgroup=ifelse(min_rank(gdpPercap)<2,1,(ifelse(min_rank(desc(gdpPercap))<2,2,0)))) %>% 
	filter(rankgroup>0) %>% 
	droplevels() 

levels(gap_gdpminmax$country)
new_countrylevels <- levels(gap_gdpminmax$country)
#this plot gives the change in gdp per cap for coutnries whih show extremes of gdp per cap for each continent
gap_gdpminmax %>% ggplot(aes(year, gdpPercap, colour=factor(country))) + geom_point(aes(shape=factor(rankgroup), size=4))+facet_wrap(~continent, ncol=1)+stat_summary(fun.y=mean, colour="black", geom="point") +theme(axis.text.x=element_blank())
ggsave("min_maxgdppercap.png")

#keep these country levels which show min/max gdppercap for a year from main data
gap_data <- gap_data %>% filter(country %in% new_countrylevels) %>%  droplevels()
levels(gap_data$country)
write.table(gap_data, "gap_data_clean.tsv", quote=FALSE, sep="\t")
