## script to build cumulative hazard plot for report

here::i_am("code/build_cumhazplot.R")

library(tidyverse)
library(survival)
library(survminer)

tertiles <- readRDS(file = here::here("data_files/tertiles_dat.RDS"))

cox.thirds <- readRDS(file = here::here("output/cox_model.rds"))

surv3 <- readRDS(file = here::here("output/surv3.rds"))

new_data <- with(tertiles, expand.grid(pil_thirds = unique(pil_thirds), Age_bl = mean(Age_bl), depavg = mean(depavg), education = "HS", Sex_Final = "Female", ethnicity = "White"))
thirds_obj <- survfit(cox.thirds, newdata = new_data)

thirds_cumhaz_plot <- ggsurvplot(fit = thirds_obj, data=new_data,
                                 fun = "cumhaz",  # For cumulative hazard
                                 xlab = "Time (Years)", 
                                 ylab = "Cumulative Hazard",
                                 ylim = c(0.00, 0.15),
                                 palette = c("#E7B800", "#2E9FDF"),
                                 legend = "right", 
                                 legend.title = "Purpose in Life Score",
                                 legend.labs = c("Upper Tertile", "Lower Tertile"),
                                 ggtheme = theme_minimal()
)


thirds_cumhaz_plot$plot <- thirds_cumhaz_plot$plot + scale_x_continuous(labels = function(x) x / 12, breaks = seq(0, max(tertiles$timeR), by = 12))

save(thirds_cumhaz_plot, file = here::here("output/cumhazplot.RData"))