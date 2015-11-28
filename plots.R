plot_data <- read.table('linfit_filtered.tsv', header = TRUE, sep = '\t', quote = '\"')
#countries that show max/min gdpper cap(extremes), plot gdppc & lifeexp 
gap_data_clean2 <- read.table('gap_data_clean.tsv', header = TRUE, sep = '\t', quote = '\"')
filteredcountry <- levels(plot_data$country)
levels((gap_data_clean2$country))
suppressPackageStartupMessages(library(dplyr))
library(ggplot2)
gap_data_clean2 <- gap_data_clean2 %>% filter(country %in% filteredcountry) %>% droplevels()
levels((gap_data_clean2$country))

gap_data_clean2 %>% filter(continent == 'Africa') %>% 
	ggplot(aes(year, gdpPercap, colour=country, size=lifeExp))+scale_x_log10()+geom_point()+geom_smooth(se=FALSE)
ggsave("Africa_gdp_life.png")
gap_data_clean2 %>% filter(continent == 'Americas') %>% 
	ggplot(aes(year, gdpPercap, colour=country, size=lifeExp))+geom_point()+scale_x_log10()+geom_smooth(se=FALSE)
ggsave("Americas_gdp_life.png")

gap_data_clean2 %>% filter(continent == 'Asia') %>% 
	ggplot(aes(year, gdpPercap, colour=country, size=lifeExp))+geom_point()+scale_x_log10()+geom_smooth(se=FALSE)
ggsave("Asia_gdp_life.png")

gap_data_clean2 %>% filter(continent == 'Europe') %>% 
	ggplot(aes(year, gdpPercap, colour=country, size=lifeExp))+geom_point()+scale_x_log10()+geom_smooth(se=FALSE)
ggsave("Europe_gdp_life.png")
