FROM rocker/r-ubuntu as base

RUN apt-get update
RUN apt-get install -y pandoc
RUN apt-get install -y vim
    
RUN mkdir /project
WORKDIR /project

RUN mkdir -p renv
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json

RUN mkdir renv/.cache
ENV RENV_PATHS_CACHE renv/.cache

RUN R -e "renv::restore(prompt = FALSE)"

COPY final_project_report.Rmd .
RUN mkdir data_files
COPY data_files/ data_files/
RUN mkdir code
COPY code/ code/
RUN mkdir output
COPY output/ output/
COPY README.md .
COPY makefile .

RUN mkdir /project/report


CMD make final_project_report.html && mv final_project_report.html report