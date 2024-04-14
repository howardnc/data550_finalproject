final_project_report.html: final_project_report.Rmd .reportbuild
	Rscript code/render_report.R

# creates output
.reportbuild: code/build_table1.R code/run_analysis.R code/build_cumhazplot.R 
	Rscript code/build_table1.R && Rscript code/run_analysis.R && Rscript code/build_cumhazplot.R

.PHONY: clean install
clean:
	rm -f output/*.rds && rm -f final_project_report.html && rm -f output/*.RData
	
install:
	R -e "renv::restore()"