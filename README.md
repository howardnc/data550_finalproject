# DATA550 Final Project

> Looking at effects of purpose in life on 
  risk of cognitive impairment on Health and Retirement Study participants
  using Cox Proportional Hazards model. This will build a report providing
  summary statistics, Cox regression results, and a cumulative hazard plot
  between lower and upper tertiles of Purpose in Life scores.

------------------------------------------------------------------------

## Code Description

`code/build_table1.R`

  - creates summary statistics dataframe for table building

`code/run_analysis.R`

  - runs Cox model on data and saves the coxph object

`code/build_cumhazplot.R`

  - builds a ggsurvplot object visualizing cumulative hazard from `code/run_analysis.R`
  
`code/render_report.R`

  - creates the HTML report from 'final_project_report.Rmd'

`Makefile`

  - contains rules for building the report, docker image, and running the docker image
  - `make .reportbuild` will generate the objects for compiling the report
  - it will also create an empty file called `.reportbuild` in the project root directory, so that `make` properly knows when to update outputs
  - `project_image` rule will take Renv files and directory files needed to build Docker image
  - `pull_image` dependency rule for `da_dockerhub_report` using Dockerhub image
  - `da_dockerhub_report` builds the report using Dockerhub image
  - `da_local_report` builds the report using locally built Docker image
  
`Dockerfile`

  - contains container structure and commands to run report building in the container

------------------------------------------------------------------------

### Build Report Locally:

  - run `make project_image` to build the local Docker image (may take some time).
  - run `make da_local_report` to build the report which will output to /report folder.

### Build Report with Dockerhub Image:

  - run `make da_dockerhub_report` to pull Dockerhub image and being report-building.
  - Built report will appear in report/ folder.
