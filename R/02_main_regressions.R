source(here::here("R", "00_load_data.R"))
source(here::here("R", "functions.R"))

########################
# Panels
########################
dynamic_women_tr <- make_panel(df_women)
dynamic_men_tr   <- make_panel(df_men)

################################################################################
# First stage: Ukrainian women share
################################################################################
# Figure 5
plot_timeseries(dynamic_women_tr, 'share_ua', 'Ukrainian women share', 'ts_share_ua_women.png')
run_event_study(dynamic_women_tr, 'share_ua') %>%
  plot_event_study('Ukrainian women share', 'es_share_ua_women.png')

# Table 2
run_static(dynamic_women_tr, 'share_ua', 'static_share_ua_women')

# Robustness: alternative thresholds (Figures B.1B, B.2B)
run_event_study(dynamic_women_tr, 'share_ua', treatment = 'treat05') %>%
  plot_event_study('Ukrainian women share (0.5% threshold)', 'es_share_ua_women_05.png')
run_event_study(dynamic_women_tr, 'share_ua', treatment = 'treat2') %>%
  plot_event_study('Ukrainian women share (2% threshold)', 'es_share_ua_women_2.png')

# Coefficients 
run_static(dynamic_women_tr, 'share_ua', 'static_share_ua_women_05', treatment = 'treat05')
run_static(dynamic_women_tr, 'share_ua', 'static_share_ua_women_2',  treatment = 'treat2')

################################################################################
# Ukrainian women
################################################################################
# Figure 6, Table 3: employment
plot_timeseries(dynamic_women_tr, 'emp_rate_ua', 'Ukrainian women employment rate', 'ts_emp_ua_women.png')
run_event_study(dynamic_women_tr, 'emp_rate_ua') %>%
  plot_event_study('Ukrainian women employment rate', 'es_emp_ua_women.png')
run_static(dynamic_women_tr, 'emp_rate_ua', 'static_emp_ua_women')

# Figure 7, Table 4: wages
plot_timeseries(dynamic_women_tr, 'log_real_ua', 'Ukrainian women log real wage', 'ts_wage_ua_women.png')
run_event_study(dynamic_women_tr, 'log_real_ua') %>%
  plot_event_study('Ukrainian women log real wage', 'es_wage_ua_women.png')
run_static(dynamic_women_tr, 'log_real_ua', 'static_wage_ua_women')

################################################################################
# Lithuanian women
################################################################################
# Figure 8, Table 5: employment
plot_timeseries(dynamic_women_tr, 'emp_rate_ltu', 'Lithuanian women employment rate', 'ts_emp_lt_women.png')
run_event_study(dynamic_women_tr, 'emp_rate_ltu') %>%
  plot_event_study('Lithuanian women employment rate', 'es_emp_lt_women.png')
run_static(dynamic_women_tr, 'emp_rate_ltu', 'static_emp_lt_women')

# Figure 9, Table 6: wages
plot_timeseries(dynamic_women_tr, 'log_real_lt', 'Lithuanian women log real wage', 'ts_wage_lt_women.png')
run_event_study(dynamic_women_tr, 'log_real_lt') %>%
  plot_event_study('Lithuanian women log real wage', 'es_wage_lt_women.png')
run_static(dynamic_women_tr, 'log_real_lt', 'static_wage_lt_women')

# Table 7: migratory response 
run_static(dynamic_women_tr, 'lt_growth', 'static_growth_lt_women')

################################################################################
# Men
################################################################################
# Figure 10, Table A.1: Ukrainian men share
plot_timeseries(dynamic_men_tr, 'share_ua', 'Ukrainian men share', 'ts_share_ua_men.png')
run_event_study(dynamic_men_tr, 'share_ua') %>%
  plot_event_study('Ukrainian men share', 'es_share_ua_men.png')
run_static(dynamic_men_tr, 'share_ua', 'static_share_ua_men')

# Figure 11, Table A.2: Lithuanian men employment
plot_timeseries(dynamic_men_tr, 'emp_rate_ltu', 'Lithuanian men employment rate', 'ts_emp_lt_men.png')
run_event_study(dynamic_men_tr, 'emp_rate_ltu') %>%
  plot_event_study('Lithuanian men employment rate', 'es_emp_lt_men.png')
run_static(dynamic_men_tr, 'emp_rate_ltu', 'static_emp_lt_men')

# Figure 12, Table A.3: Lithuanian men wages
plot_timeseries(dynamic_men_tr, 'log_real_lt', 'Lithuanian men log real wage', 'ts_wage_lt_men.png')
run_event_study(dynamic_men_tr, 'log_real_lt') %>%
  plot_event_study('Lithuanian men log real wage', 'es_wage_lt_men.png')
run_static(dynamic_men_tr, 'log_real_lt', 'static_wage_lt_men')

# Table A.4: migratory response
run_static(dynamic_men_tr, 'lt_growth', 'static_growth_lt_men')
