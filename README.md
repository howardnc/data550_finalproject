# DATA550 Final Project

> Looking at effects of purpose in life on 
  risk of cognitive impairment on Health and Retirement Study participants
  using Cox Proportional Hazards model

------------------------------------------------------------------------

## Initial code description

`code/build_table1.R`

  - creates summary statistics dataframe for table building

`code/run_analysis.R`

  - runs Cox model on data and saves the coxph object

`code/build_cumhazplot.R`

  - builds a ggsurvplot object visualizing cumualative hazard from `code/run_analysis.R`
  
`code/render_report.R`

  - creates the HTML report from 'final_project_report.Rmd'

`Makefile`

  - contains rules for building the report
  - `make .reportbuild` will generate the objects for compiling the report
  - it will also create an empty file called `.reportbuild` in the project root directory, so that `make` properly knows when to update outputs

------------------------------------------------------------------------

