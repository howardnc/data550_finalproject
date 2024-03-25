### script to build table 1 for data 550 final project

here::i_am("code/build_table1.R")

library(tidyverse)
library(gtsummary)
library(gt)
library(gtExtras)

load(file = here::here("data_files/Pilcog Final Over 45.RData"))
dat <- pilcog_45plus

# make summaries of covariates of interest
summarize_group <- function(data, group_name) {
  summary_df <- data %>%
    filter(ethnicity == group_name) %>%
    summarise(
      mean_age_bl = mean(Age_bl, na.rm = TRUE),
      median_age_bl = median(Age_bl, na.rm = TRUE),
      min_age_bl = min(Age_bl, na.rm = TRUE),
      max_age_bl = max(Age_bl, na.rm = TRUE),
      mean_age_end = mean(age_end, na.rm = TRUE),
      median_age_end = median(age_end, na.rm = TRUE),
      min_age_end = min(age_end, na.rm = TRUE),
      max_age_end = max(age_end, na.rm = TRUE),
      mean_PILscore = mean(PILscore, na.rm = TRUE),
      median_PILscore = median(PILscore, na.rm = TRUE),
      min_PILscore = min(PILscore, na.rm = TRUE),
      max_PILscore = max(PILscore, na.rm = TRUE),
      mean_depavg = mean(depavg, na.rm = TRUE),
      median_depavg = median(depavg, na.rm = TRUE),
      min_depavg = min(depavg, na.rm = TRUE),
      max_depavg = max(depavg, na.rm = TRUE),
      count = n()
    ) %>%
    mutate(group = group_name)
  
  full_summary <- summary_df
  categorical_covariates <- c("Sex_Final", "onset", "education")
  
  for (cat_cov in categorical_covariates) {
    cat_summary <- data %>%
      filter(ethnicity == group_name) %>%
      count(!!sym(cat_cov)) %>%
      mutate(perc = n / sum(n) * 100) %>%
      pivot_wider(names_from = !!sym(cat_cov), values_from = c(n, perc), names_prefix = paste0(cat_cov, "_"))  # Transform to wide format
    
    
    cat_summary$group <- group_name
    
    # combine summaries
    if (nrow(cat_summary) > 0) {
      full_summary <- merge(full_summary, cat_summary, by = "group", all = TRUE)
    }
  }
  
  return(full_summary)
}

# apply to ethnicities
groups <- c("Black", "White", "Hispanic", "Other")
group_summaries <- lapply(groups, function(g) summarize_group(dat, g))

# total summaries
total_summary <- dat %>%
  summarise(
    mean_age_bl = mean(Age_bl, na.rm = TRUE),
    median_age_bl = median(Age_bl, na.rm = TRUE),
    min_age_bl = min(Age_bl, na.rm = TRUE),
    max_age_bl = max(Age_bl, na.rm = TRUE),
    mean_age_end = mean(age_end, na.rm = TRUE),
    median_age_end = median(age_end, na.rm = TRUE),
    min_age_end = min(age_end, na.rm = TRUE),
    max_age_end = max(age_end, na.rm = TRUE),
    mean_PILscore = mean(PILscore, na.rm = TRUE),
    median_PILscore = median(PILscore, na.rm = TRUE),
    min_PILscore = min(PILscore, na.rm = TRUE),
    max_PILscore = max(PILscore, na.rm = TRUE),
    mean_depavg = mean(depavg, na.rm = TRUE),
    median_depavg = median(depavg, na.rm = TRUE),
    min_depavg = min(depavg, na.rm = TRUE),
    max_depavg = max(depavg, na.rm = TRUE),
    count = n()
  ) %>%
  mutate(group = "Total")

# categorical covariate summaries
cat_summ <- function(data){
  n <- nrow(data)
  sex <- table(data$Sex_Final)
  edu <- table(data$education)
  onset <- table(data$onset)
  
  cat_summary <- data.frame(n_Sex_Final_Female = sex[1], n_Sex_Final_Male = sex[2],
                            perc_Sex_Final_Female = (sex[1] / n) * 100, perc_Sex_Final_Male = (sex[2] / n)* 100,
                            n_onset_0 = onset[1], n_onset_1 = onset[2],perc_onset_0 = (onset[1] / n)* 100, perc_onset_1 = (onset[2] / n)* 100,
                            n_education_HS = edu[1], n_education_College = edu[2], 'n_education_Less than HS' = edu[3],
                            'n_education_Some College' = edu[4],perc_education_HS = (edu[1] / n)* 100, perc_education_College = (edu[2] / n)* 100,
                            'perc_education_Less than HS' = (edu[3] / n)* 100, 'perc_education_Some College' = (edu[4] / n)* 100, check.names = FALSE)
}

cat_total_summ <- cat_summ(dat)

# Combine all summaries
table1 <- do.call(rbind, group_summaries)
total_summary <- cbind(total_summary,cat_total_summ)
order_names <- colnames(table1)
total_summary <- total_summary %>% dplyr::select(order_names)
table1 <- rbind(table1, total_summary)
rownames(table1) <- NULL 
####

# build our table
table1 <- table1 %>%
  mutate('Baseline Age' = paste(mean_age_bl, median_age_bl, min_age_bl, max_age_bl, sep = " / ")) %>%
  mutate('End Age' = paste(mean_age_end, median_age_end, min_age_end, max_age_end, sep = " / ")) %>%
  mutate('Purpose in Life Score' = paste(mean_PILscore, median_PILscore, min_PILscore, max_PILscore, sep = " / ")) %>%
  mutate('Average Depression' = paste(mean_depavg, median_depavg, min_depavg, max_depavg, sep = " / ")) %>%
  mutate('Female' = paste(n_Sex_Final_Female, perc_Sex_Final_Female, sep = " / ")) %>%
  mutate('Onset' = paste(n_onset_1, perc_onset_1, sep = " / ")) %>%
  mutate('College' = paste(n_education_College, perc_education_College, sep = " / ")) %>%
  mutate('Some College' = paste(`n_education_Some College`, `perc_education_Some College`, sep = " / ")) %>%
  mutate('High School (HS)' = paste(n_education_HS, perc_education_HS, sep = " / ")) %>%
  mutate('Less than HS' = paste(`n_education_Less than HS`, `perc_education_Less than HS`, sep = " / "))


table1 <- table1 %>%
  mutate('Baseline Age' = sprintf("%.0f / %.0f / (%.0f, %.0f)", mean_age_bl, median_age_bl, min_age_bl, max_age_bl)) %>%
  mutate('End Age' = sprintf("%.0f / %.0f / (%.0f, %.0f)", mean_age_end, median_age_end, min_age_end, max_age_end)) %>%
  mutate('Purpose in Life Score' = sprintf("%.1f / %.1f / (%.0f, %.0f)", mean_PILscore, median_PILscore, min_PILscore, max_PILscore)) %>%
  mutate('Average Depression' = sprintf("%.1f / %.1f / (%.0f, %.0f)", mean_depavg, median_depavg, min_depavg, max_depavg)) %>%
  mutate('Female' = sprintf("%.0f (%.0f%%)", n_Sex_Final_Female, perc_Sex_Final_Female)) %>%
  mutate('Onset' = sprintf("%.0f (%.0f%%)", n_onset_1, perc_onset_1)) %>%
  mutate('College' = sprintf("%.0f (%.0f%%)", n_education_College, perc_education_College)) %>%
  mutate('Some College' = sprintf("%.0f (%.0f%%)", `n_education_Some College`, `perc_education_Some College`)) %>%
  mutate('High School (HS)' = sprintf("%.0f (%.0f%%)", n_education_HS, perc_education_HS)) %>%
  mutate('Less than HS' = sprintf("%.0f (%.0f%%)", `n_education_Less than HS`, `perc_education_Less than HS`))

table1 <- table1 %>% dplyr::select(group,`Baseline Age`,`End Age`,`Purpose in Life Score`,`Average Depression`,
                                   Female,Onset,College,`Some College`,`High School (HS)`,`Less than HS`)

table1_t <- t(table1)

table1_t <- as.data.frame(table1_t, stringsAsFactors = FALSE)

# adjusting columns
colnames(table1_t) <- table1_t[1,]

table1_t <- table1_t[-1,]
table1_t$Covariate <- rownames(table1_t)
rownames(table1_t) <- NULL
table1_t <- table1_t %>% dplyr::select(Covariate,everything())


saveRDS(table1_t, file = here::here("output/table1.rds"))