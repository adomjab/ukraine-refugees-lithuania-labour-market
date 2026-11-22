# Runs the full pipeline. Outputs are written to figures/ and tables/.
# 00_load_data.R and functions.R are sourced inside each script.
# make_synthetic_data.R is NOT run here: the synthetic data is already in data/.

source(here::here("R", "01_treatment.R"))
source(here::here("R", "02_main_regressions.R"))
source(here::here("R", "03_further_implications.R"))
source(here::here("R", "04_fiscal_contribution.R"))
source(here::here("R", "05_stylised_facts.R"))