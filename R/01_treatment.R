source(here::here("R", "00_load_data.R"))
################################################################################
#########################
# Summary statistics
#########################
# Lithuanian tables
df_lt_wage <- df %>%
  mutate(years = case_when(
    date >= as.Date('2015-01-01') & date < as.Date('2019-01-01') ~ 'pre-analysis',
    date >= as.Date('2019-01-01') & date < as.Date('2022-03-01') ~ 'pre-war',
    date >= as.Date('2022-03-01') ~ 'post-war'
  ),
  years = factor(years, levels = c('pre-analysis', 'pre-war', 'post-war')),
  WAGE_full_LTU = log(WAGE_full_LTU/cpi_rebased)) %>%
  select(years, monthly, municipality, FEMALE, WAGE_full_LTU) %>%
  group_by(years, FEMALE) %>%
  summarise(WAGE_full_LTU = mean(WAGE_full_LTU, na.rm = TRUE)) %>%
  ungroup() %>%
  pivot_longer(-c(FEMALE, years), names_to = 'variable', values_to = 'value') %>%
  pivot_wider(names_from = FEMALE, values_from = value)%>%
  rename(lt_men = '0',
         lt_women = '1') %>%
  mutate(variable = str_remove(variable, '_LTU'))

df_lt_ppl <- df %>%
  mutate(years = case_when(
    date >= as.Date('2015-01-01') & date < as.Date('2019-01-01') ~ 'pre-analysis',
    date >= as.Date('2019-01-01') & date < as.Date('2022-03-01') ~ 'pre-war',
    date >= as.Date('2022-03-01') ~ 'post-war'
  ),
  years = factor(years, levels = c('pre-analysis', 'pre-war', 'post-war'))) %>%
  select(years, monthly, municipality, FEMALE, PPL_LTU, EMP_full_LTU,
         MW_LTU) %>%
  group_by(years, monthly, FEMALE) %>%
  summarise(across(PPL_LTU:MW_LTU, sum, na.rm = TRUE)) %>%
  ungroup() %>%
  group_by(years, FEMALE) %>%
  summarise(across(PPL_LTU:MW_LTU, mean, na.rm = TRUE)) %>%
  ungroup() %>%
  pivot_longer(-c(FEMALE, years), names_to = "variable", values_to = "value") %>%
  pivot_wider(names_from = FEMALE, values_from = value) %>%
  rename(lt_men = '0',
         lt_women = '1') %>%
  mutate(variable = str_remove(variable, '_LTU'))


# Ukrainian tables
df_ua_wage <- df %>%
  mutate(years = case_when(
    date >= as.Date('2015-01-01') & date < as.Date('2019-01-01') ~ 'pre-analysis',
    date >= as.Date('2019-01-01') & date < as.Date('2022-03-01') ~ 'pre-war',
    date >= as.Date('2022-03-01') ~ 'post-war'
  ),
  years = factor(years, levels = c('pre-analysis', 'pre-war', 'post-war')),
  WAGE_full_UKR = log(WAGE_full_UKR/cpi_rebased)) %>%
  select(years, monthly, municipality, FEMALE, WAGE_full_UKR) %>%
  group_by(years, FEMALE) %>%
  summarise(WAGE_full_UKR = mean(WAGE_full_UKR, na.rm = TRUE)) %>%
  ungroup() %>%
  pivot_longer(-c(FEMALE, years), names_to = "variable", values_to = "value") %>%
  pivot_wider(names_from = FEMALE, values_from = value) %>%
  rename(ua_men = '0',
         ua_women = '1') %>%
  mutate(variable = str_remove(variable, '_UKR'))

df_ua_ppl <- df %>%
  mutate(years = case_when(
    date >= as.Date('2015-01-01') & date < as.Date('2019-01-01') ~ 'pre-analysis',
    date >= as.Date('2019-01-01') & date < as.Date('2022-03-01') ~ 'pre-war',
    date >= as.Date('2022-03-01') ~ 'post-war'
  ),
  years = factor(years, levels = c('pre-analysis', 'pre-war', 'post-war'))) %>%
  select(years, monthly, municipality, FEMALE, PPL_UKR, EMP_full_UKR,
         MW_UKR) %>%
  group_by(years, monthly, FEMALE) %>%
  summarise(across(PPL_UKR:MW_UKR, sum, na.rm = TRUE)) %>%
  ungroup() %>%
  group_by(years, FEMALE) %>%
  summarise(across(PPL_UKR:MW_UKR, mean, na.rm = TRUE)) %>%
  ungroup() %>%
  pivot_longer(-c(FEMALE, years), names_to = "variable", values_to = "value") %>%
  pivot_wider(names_from = FEMALE, values_from = value) %>%
  rename(ua_men = '0',
         ua_women = '1') %>%
  mutate(variable = str_remove(variable, '_UKR'))

# Merging
df_wage <- merge(df_lt_wage, df_ua_wage, by = c('years', 'variable')) %>%
  mutate(variable = factor(variable, levels = c('WAGE_full', 'WAGE_part')),
         across(lt_men:ua_women, ~ round(.x, 2))) %>%
  select(years, variable, lt_women, ua_women, lt_men, ua_men)

df_ppl <- merge(df_lt_ppl, df_ua_ppl, by = c('years', 'variable')) %>%
  mutate(variable = factor(variable, levels = c('PPL', 'EMP_full',
                                                'MW')),
         across(lt_men:ua_women, round))

df_summary <- bind_rows(df_ppl, df_wage) %>%
  select(years, variable, lt_women, ua_women, lt_men, ua_men)

print(df_summary)

df_summary_out <- df_summary %>%
  arrange(years, variable) %>%
  mutate(variable = recode(variable,
                           PPL       = 'Employees',
                           EMP_full  = 'Full-time employed',
                           MW        = 'Minimum-wage earners',
                           WAGE_full = 'Log real wage (full-time)')) %>%
  rename(Period = years, Variable = variable,
         `LT women` = lt_women, `UA women` = ua_women,
         `LT men`   = lt_men,   `UA men`   = ua_men)

# Table output to repo
write_csv(df_summary_out, here::here('tables', 'summary_stats.csv'))

################################################################################
################################
###### Shares map no transport
################################
map_exposure_tr_avg <- merge(coords, groups_tr_avg, by = 'municipality_name')

# 2015-2018
map_ua_prewar <- ggplot(map_exposure_tr_avg) +
  geom_sf(aes(fill = s), color = 'black', lwd = 0.3) +
  scale_fill_distiller(palette = 'Greens', direction = 1, n.breaks = 8,
                       limits = c(0, NA),
                       guide = guide_colourbar(
                         theme = theme(legend.key.height = unit(4, 'cm'),
                                       legend.key.width  = unit(1, 'cm'))
                       )) +
  labs(title = 'Distribution of Ukrainians before the war', fill = '') +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = 'inside',
        legend.position.inside = c(0.2, 0.3))

map_ua_prewar

ggsave(here::here('figures', 'map_ua_prewar.png'),
       plot = map_ua_prewar, width = 8, height = 6, dpi = 300, bg = 'white')

################################
###### Exposure groups map
################################
groups_tr_avg <- groups_tr_avg %>%
  mutate(s1 = ifelse(s >= 1, 'Treated', 'Control'),
         s05 = ifelse(s >= 0.5, 'Treated', 'Control'),
         s2 = ifelse(s >= 2, 'Treated', 'Control'))

map_exposure_tr_avg <- merge(coords, groups_tr_avg, by = 'municipality_name')

map_treatment <- ggplot(map_exposure_tr_avg) +
  geom_sf(aes(fill = s1),
          color = 'black',
          lwd = 0.3) +
  scale_fill_manual(
    values = c('Treated' = '#F8766D',
               'Control' = '#00BA38'),
    breaks = c('Treated', 'Control')) +
  labs(title = 'Treatment distribution',
       fill = '') +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = 'inside',
        legend.position.inside = c(0.2, 0.3),
        legend.key.size = unit(1.5, 'cm'))

map_treatment

ggsave(here::here('figures', 'map_treatment.png'),
       plot = map_treatment,
       width = 8, height = 6, dpi = 300, bg = 'white')

##############################
# Matching treated to neighbors
##############################
# Three groups for map
treated_manual <- manual_matches %>%
  distinct(treated) %>%
  rename(municipality_name = treated) %>%
  mutate(treated_manual = 1)

control_manual <- manual_matches %>%
  distinct(control) %>%
  rename(municipality_name = control) %>%
  mutate(control_manual = 1)

map_groups_manual <- coords %>%
  left_join(groups_tr_avg, by = 'municipality_name') %>%
  merge(treated_manual, by = 'municipality_name', all.x = TRUE) %>%
  merge(control_manual, by = 'municipality_name', all.x = TRUE) %>%
  mutate(
    group_map = case_when(
      treated_manual == 1 ~ 'Treated',
      control_manual == 1 ~ 'Control',
      TRUE ~ 'Not used'
    ),
    group_map = factor(group_map,
                       levels = c('Treated', 'Control', 'Not used'))
  )


# Map
map_matched <- ggplot(map_groups_manual) +
  geom_sf(aes(fill = group_map),
          color = 'black',
          lwd = 0.3) +
  scale_fill_manual(
    values = c('Treated' = '#F8766D',
               'Control' = '#00BA38',
               'Not used' = 'grey80'),
    breaks = c('Treated', 'Control', 'Not used')) +
  coord_sf(lims_method = 'geometry_bbox') +
  labs(title = 'Matched treatment distribution',
       fill = '') +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = 'inside',
        legend.position.inside = c(0.2, 0.3),
        legend.key.size = unit(1.5, 'cm'))

map_matched

ggsave(here::here('figures', 'map_matched.png'),
       plot = map_matched,
       width = 8, height = 6, dpi = 300, bg = 'white')
