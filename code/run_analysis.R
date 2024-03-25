## script to run cox model on data

here::i_am("code/run_analysis.R")

library(tidyverse)
library(survival)
library(survminer)

tertiles <- readRDS(file = here::here("data_files/tertiles_dat.RDS"))

surv3 <- Surv(time = tertiles$timeR, 
              event = tertiles$onset,
              type = "right")

## fitting thirds model
cox.thirds <- coxph(surv3 ~ pil_thirds + Age_bl + depavg + strata(ethnicity)
                    + Sex_Final + education, data = tertiles)

saveRDS(surv3, file = here::here("output/surv3.rds"))

saveRDS(cox.thirds, file = here::here("output/cox_model.rds"))