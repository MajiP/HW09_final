gap_data_clean <- read.table('gap_data_clean.tsv', header = TRUE, sep = '\t', quote = '\"')
suppressPackageStartupMessages(library(dplyr))

#write a function to plot linear regression of life expectancy vs. gdp per capita
#save intercept, slope and sigma-standard deviation of residual in a dataframe
#write out results for only those 3 countries which show lowest sigma by continent
linfit_func <- function(dat){
	linfit <- lm(lifeExp~log(gdpPercap), dat)
	summ <- summary(lm(lifeExp~log(gdpPercap), dat))
	setNames(data.frame(t(coef(linfit)), summ$sigma), c("intercept", "slope", "residSigma"))
}

linfitresults <- gap_data_clean %>% group_by(continent, country) %>% 
	do(linfit_func(.)) %>% 
	ungroup() %>% 
	arrange(residSigma)
	
linfit_filtered <- linfitresults %>% group_by(continent) %>% 
	filter(min_rank(residSigma)<4)

write.table(linfit_filtered, "linfit_filtered.tsv", quote = FALSE, sep="\t")

