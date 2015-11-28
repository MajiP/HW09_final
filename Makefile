all: report.html

clean: 
	rm -f *.tsv *.png report.html Rplots.pdf

gapminder.tsv: download.R
	Rscript download.R
	
gap_data_clean.tsv: analysis.R gapminder.tsv
	Rscript analysis.R
	rm -f Rplots.pdf

linfit_filtered.tsv: stats.R gap_data_clean.tsv
	Rscript stats.R
	
plots: plots.R linfit_filtered.tsv gap_data_clean.tsv
	Rscript plots.R
	rm -f Rplots.pdf
	
report.html: report.Rmd plots analysis.R
	Rscript -e 'rmarkdown::render("report.Rmd")'