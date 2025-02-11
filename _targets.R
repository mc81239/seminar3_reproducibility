# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline -- using groundhog for reproducibility, this is a bit inefficient but works ok
library(groundhog)
groundhog::groundhog.library(c("targets", "dplyr", "readr", "ggplot2", "stargazer"), "2025-01-01")

# library(tarchetypes) # Load other packages as needed.

# Set target options:
#tar_option_set(
#  packages = c("tidyverse", "stargazer") # Packages that your targets need for their tasks.
#)

# Run the R scripts in the R/ folder with your custom functions:
# Note: we are using a **different** script here to the one we used before -- now functions_targets.R. This is just because I wanted to use functions
# that return figures/tables to the workspace, rather than writing files to disk. You can use either, it doesn't matter.
tar_source("./R/functions/functions_targets.R")

# Define global variables:
table_dir <- "./output/tables/"
figure_dir <- "./output/figures/"

# Replace the target list below with your own:
list(
  tar_target(
    name = file,
    command = "./data/raw/WHR_2017.csv", format = "file"),
  
  tar_target(
    name = data,
    command = ingest_data(file)),
  
  tar_target(
    name = data_scaled,
    command = scale_data(data, variables = c("Happiness_score", "GDP_pc", "Life_expectancy"))),
  
  tar_target(
    name = plot_gdp_pc ,
    command = simple_plot(data_scaled, yvar = "Happiness_score", xvar = "GDP_pc", outdir = figure_dir, fname = "plot_gdp_pc_target.jpg")),
  
  tar_target(
    name = plot_life_exp,
    command = simple_plot(data_scaled, yvar = "Happiness_score", xvar = "Life_expectancy", outdir = figure_dir, fname = "plot_life_exp_target.jpg")),
  
  tar_target(
    name = model_gdp_pc,
    command = simple_reg(data_scaled, yvar = "Happiness_score", xvar = "GDP_pc", outdir = table_dir, fname = "table_gdp_pc_target.tex")),
  
  tar_target(
    name = model_life_exp,
    command = simple_reg(data_scaled, yvar = "Happiness_score", xvar = "Life_expectancy", outdir = table_dir, fname = "table_life_exp_target.tex"))
)
