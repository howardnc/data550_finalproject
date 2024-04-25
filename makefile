final_project_report.html: final_project_report.Rmd .reportbuild
	Rscript code/render_report.R

# creates output
.reportbuild: code/build_table1.R code/run_analysis.R code/build_cumhazplot.R 
	Rscript code/build_table1.R && Rscript code/run_analysis.R && Rscript code/build_cumhazplot.R
	


.PHONY: clean install da_report report
clean:
	rm -f output/*.rds && rm -f final_project_report.html && rm -f output/*.RData \
	&& rm -f report/*.html
	
install:
	R -e "renv::restore()"
	
	
# DOCKER-ASSOCITATED RULES
PROJECTFILES = final_project_report.Rmd code/build_table1.R code/run_analysis.R \
               code/build_cumhazplot.R Makefile
RENVFILES = renv.lock renv/activate.R renv/settings.json

# rule to build image 
project_image: Dockerfile $(PROJECTFILES) $(RENVFILES)
	docker build -t project_image .
	touch $@

# rule to run locally built image with volume mount
da_local_report:
	docker run -v "/$$(pwd)/report":/project/report project_image

# rule to pull dockerhub image 
pull_image:
	docker pull nchoward/project_image:latest

# Rule to run the dockerhub image with volume mount
da_dockerhub_report: pull_image
	docker run -v "/$$(pwd)/report":/project/report nchoward/project_image
