########################
# Functions
########################

# Panel data function. Merges treatment and builds variables
# df: df_women, df_men, df_sum
# pop_var = PPL when using df_sum

make_panel <- function(df, pop_var = 'local_pop') {
  merge(df, groups_tr_avg, by = c('municipality', 'municipality_name')) %>%
    arrange(date) %>%
    group_by(municipality) %>%
    mutate(event = monthly - 746,
           share_ua = (PPL_UKR / .data[[pop_var]]) * 100,
           real_wage_lt = WAGE_full_LTU / cpi_rebased,
           real_wage_ua = WAGE_full_UKR / cpi_rebased,
           log_real_lt = log(real_wage_lt),
           log_real_ua = log(real_wage_ua),
           wage_gap = log(real_wage_lt) - log(real_wage_ua),
           emp_rate_ltu = EMP_full_LTU / PPL_LTU,
           emp_rate_ua = EMP_full_UKR / PPL_UKR,
           post = ifelse(date >= as.Date('2022-03-01'), 1, 0),
           lt_growth = log(PPL_LTU) - log(dplyr::lag(PPL_LTU))) %>%
    ungroup() %>%
    filter(date >= as.Date('2019-01-01')) %>%
    select(-c(AGE_29, AGE_3054, AGE_55))
}

# Dynamic DiD function
# treatment:
# treat if threshold = 1% (this is the default)
# treat05 if threshold = 0.5%
# treat2 if threshold = 2%

# outcome:
# share_ua - share of Ukrainians
# emp_rate_ua - share of employed Ukrainians
# log_real_ua - log real wage of Ukrainians
# emp_rate_lt - share of employed Lithuanians
# log_real_lt - log real wage of Lithuanians

run_event_study <- function(data, outcome, treatment = 'treat') {
  reg <- feols(.[outcome] ~ i(event, .[treatment], ref = -1) |
                 municipality + date,
               data = data,
               cluster = ~municipality)
  
  reg_coefs <- tidy(reg, conf.int = TRUE, conf.level = 0.95) %>%
    filter(grepl('event', term)) %>%
    mutate(event = as.numeric(str_extract(term, "-?\\d+")),
           monthly = event + 746,
           year = 1960 + (monthly %/% 12),
           month = 1 + (monthly %% 12),
           date = as.Date(sprintf("%d-%02d-01", year, month)))
  
  reg_coefs
}

# title: the title of the figure
# file: name of the exported figure file

plot_event_study <- function(reg_coefs, title, file) {
  p <- ggplot(data = reg_coefs, aes(x = date,
                                    y = estimate,
                                    ymin = conf.low, ymax = conf.high)) +
    geom_pointrange(size = 0.1,
                    linewidth = 0.4,
                    position = position_dodge(width = 20),
                    color = 'springgreen4') +
    geom_vline(xintercept = as.Date('2022-02-01'),
               linetype = 'dashed',
               color = 'black',
               linewidth = 0.3) +
    geom_hline(yintercept = 0,
               linetype = 'dashed',
               color = 'black',
               linewidth = 0.3) +
    labs(title = title,
         y = 'Coefficients',
         x = '',
         color = '',
         shape = '') +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))
  
  # Export to figures folder
  ggsave(here::here('figures', file),
         plot = p,
         width = 8,
         height = 4)
  
  p
}

# Static DiD: baseline, heterogeneous trends, matched neighbours, population weights
# Estimates all four specifications and exports them as LaTeX (.tex) and Markdown (.md) tables
# treatment:
# treat if threshold = 1% (default)
# treat05 if threshold = 0.5%
# treat2 if threshold = 2%
# file: file name without extension, e.g. 'static_share_ua_women'

run_static <- function(data, outcome, file,
                       treatment = 'treat',
                       controls = df_controls_fixed,
                       matches = manual_matches) {
  
  # Add fixed controls and linear time trend
  data_ctrl <- merge(data, controls, by = 'municipality') %>%
    mutate(time_trend = as.numeric(factor(date)))
  
  # Matched sample: each treated municipality + its bordering controls
  matches <- matches %>%
    mutate(match_id = treated)
  
  unit_lookup <- bind_rows(
    matches %>%
      distinct(treated) %>%
      rename(municipality = treated) %>%
      mutate(treated_unit = 1,
             match_id = municipality),
    # Controls appearing in multiple groups get multiple rows here
    matches %>%
      select(municipality = control, match_id) %>%
      mutate(treated_unit = 0)
  ) %>%
    rename(municipality_name = 'municipality')
  
  matched <- data_ctrl %>%
    inner_join(unit_lookup, by = 'municipality_name', relationship = 'many-to-many')
  
  # 1. Main specification 
  static_main <- feols(.[outcome] ~ .[treatment]:post |
                         municipality + date,
                       data = data,
                       cluster = ~municipality)
  
  # 2. Controls interacted with time trends
  # AGE_55, PUBLIC, LOWSKILL omitted as reference
  static_int <- feols(.[outcome] ~ .[treatment]:post +
                        female_share:time_trend + AGE_29:time_trend + AGE_3054:time_trend +
                        PRIMARY:time_trend + MANUF:time_trend + CONSTR:time_trend +
                        TRADE:time_trend + TRANSPORT:time_trend + HOSP:time_trend +
                        ICT:time_trend + FIN:time_trend + PROF:time_trend + ADMIN:time_trend +
                        OTHERSERV:time_trend + HIGHSKILL:time_trend + CLERICAL:time_trend +
                        SERVSALES:time_trend |
                        municipality + date,
                      data = data_ctrl,
                      cluster = ~municipality)
  
  # 3. Matched municipalities
  static_match <- feols(.[outcome] ~ treated_unit*post +
                          female_share:time_trend + AGE_29:time_trend + AGE_3054:time_trend +
                          PRIMARY:time_trend + MANUF:time_trend + CONSTR:time_trend +
                          TRADE:time_trend + TRANSPORT:time_trend + HOSP:time_trend +
                          ICT:time_trend + FIN:time_trend + PROF:time_trend + ADMIN:time_trend +
                          OTHERSERV:time_trend + HIGHSKILL:time_trend + CLERICAL:time_trend +
                          SERVSALES:time_trend |
                          match_id + date,
                        data = matched,
                        cluster = ~match_id)
  
  # 4. Population weights
  static_weight <- feols(.[outcome] ~ .[treatment]:post +
                           female_share:time_trend + AGE_29:time_trend + AGE_3054:time_trend +
                           PRIMARY:time_trend + MANUF:time_trend + CONSTR:time_trend +
                           TRADE:time_trend + TRANSPORT:time_trend + HOSP:time_trend +
                           ICT:time_trend + FIN:time_trend + PROF:time_trend + ADMIN:time_trend +
                           OTHERSERV:time_trend + HIGHSKILL:time_trend + CLERICAL:time_trend +
                           SERVSALES:time_trend |
                           municipality + date,
                         data = data_ctrl,
                         cluster = ~municipality,
                         weights = ~pre_pop)
  
  models <- list(static_main, static_int, static_match, static_weight)
  
  # Number of treated and control municipalities in each sample
  n_tr  <- n_distinct(data$municipality[data[[treatment]] == 1])
  n_ctl <- n_distinct(data$municipality[data[[treatment]] == 0])
  n_tr_match  <- n_distinct(matched$municipality[matched$treated_unit == 1])
  n_ctl_match <- n_distinct(matched$municipality[matched$treated_unit == 0])
  
  table_lines <- list('Population weights' = c('', '', '', 'Yes'),
                      'Heterogeneous trends' = c('', 'Yes', 'Yes', 'Yes'),
                      'Treated municipalities' = c(n_tr, n_tr, n_tr_match, n_tr),
                      'Control municipalities' = c(n_ctl, n_ctl, n_ctl_match, n_ctl))
  
  # LaTeX table 
  etable(models,
         tex = TRUE,
         keep = '%post',
         fitstat = c('n', 'r2', 'my', 'rmse'),
         extralines = table_lines,
         file = here::here('tables', paste0(file, '.tex')))
  
  # Markdown table (readable on GitHub)
  md_table <- etable(models,
                     keep = '%post',
                     fitstat = c('n', 'r2', 'my', 'rmse'),
                     extralines = table_lines)
  
  writeLines(knitr::kable(md_table, format = 'pipe', row.names = FALSE),
             here::here('tables', paste0(file, '.md')))
  
  invisible(models)
}


# Time series by treatment group
plot_timeseries <- function(data, outcome, title, file) {
  df_ts <- data %>%
    group_by(date, treat) %>%
    summarise(value = mean(.data[[outcome]], na.rm = TRUE), .groups = 'drop') %>%
    mutate(treat = ifelse(treat == 1, 'Treated', 'Control'),
           treat = factor(treat, levels = c('Treated', 'Control')))
  
  p <- ggplot(data = df_ts, aes(x = date,
                                y = value,
                                group = treat,
                                color = treat,
                                linetype = treat)) +
    geom_line() +
    scale_color_manual(values = c('Treated' = '#F8766D',
                                  'Control' = '#00BA38')) +
    geom_vline(xintercept = as.Date('2022-02-01'),
               linetype = 'dashed',
               color = 'black',
               linewidth = 0.3) +
    labs(title = title,
         x = '',
         y = '',
         color = '',
         linetype = '') +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5),
          legend.position = 'bottom',
          legend.background = element_rect(fill = "white", color = "black", linewidth = 0.3),
          legend.margin = margin(4, 6, 4, 6))
  
  # Export to figures folder
  ggsave(here::here('figures', file),
         plot = p,
         width = 8,
         height = 4)
  
  p
}

# Time series by gender (men left, women right) ( for 05_stylised_facts.R)
# y: column to plot
# ylab: y-axis label
# title: figure title
# file: name of the exported figure file
plot_gender_ts <- function(data, y, ylab, title, file) {
  p <- ggplot(data = data, aes(x = date,
                               y = .data[[y]],
                               group = type,
                               color = type,
                               linetype = type)) +
    geom_line() +
    facet_wrap(~FEMALE,
               scales = 'fixed') +
    labs(title = title,
         x = '',
         y = ylab,
         linetype = '',
         color = '') +
    geom_vline(xintercept = as.Date('2022-02-01'),
               linetype = 'dashed',
               color = 'black',
               linewidth = 0.4) +
    scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
    scale_y_continuous(n.breaks = 12) +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5),
          legend.position = 'bottom',
          legend.background = element_rect(fill = "white", color = "black", linewidth = 0.3),
          legend.margin = margin(4, 6, 4, 6))
  
  # Export to figures folder
  ggsave(here::here('figures', file),
         plot = p,
         width = 9,
         height = 4)
  
  p
}