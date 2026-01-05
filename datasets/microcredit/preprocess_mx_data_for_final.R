#!/usr/bin/env Rscript
library(tidyverse)

base_dir <- "/home/rgiordan/Documents/git_repos/stat151a"

# you should change this too if you want to write
output_dir <- file.path(base_dir, "datasets/microcredit")

################
# Load the data

# I have saved a copy of the script used to create microcredit_project_data.RData
# in this directory; it is called import_organise_data_v7.R
microcredit_env <- new.env()
load(file.path(output_dir, "microcredit_project_data.RData"), envir=microcredit_env)

mx_length <- 21523
all_cols <- ls(microcredit_env)
mx_cols <- all_cols[str_detect(all_cols, "^angelucci_.*")]
mx_col_lengths <- sapply(mx_cols, \(col) length(microcredit_env[[col]]))  
mx_cols_keep <- mx_cols[mx_col_lengths == mx_length]
stopifnot(length(mx_cols_keep) > 0)

mx_df <- data.frame(row=1:mx_length)
for (col in mx_cols_keep) {
  new_col <- sub("^angelucci_", "", col)
  mx_df[[new_col]] <- microcredit_env[[col]]
}

nrow(mx_df)
sum(complete.cases(mx_df))

mx_df$ppp_conv <- microcredit_env$the_temptation_standardiser_USD_PPP_per_fortnight[1]
summarize(mx_df, across(matches(".*"), ~ sum(!is.na(.x)))) %>% t()

save(mx_df, file="microcredit_mx_final_project_data.Rdata")


