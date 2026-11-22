# 00_load_data.R
options(scipen = 999)

# Tables folder
dir.create(here::here("tables"), showWarnings = FALSE)
# Figures folder
dir.create(here::here("figures"), showWarnings = FALSE)

#############
# Libraries #
#############
library(here)
library(haven)    
library(tidyverse)
library(ggplot2)
library(patchwork)
library(sf)
library(broom)
library(fixest)

#######################
# CPI df
#######################
# 2025 = 100
cpi <- read.csv(here('data', 'cpi.csv')) %>%
  select(Time, Value) %>%
  mutate(Time = as.Date(paste0(gsub('M', '-', Time), '-01'), format = '%Y-%m-%d')) %>%
  filter(Time >= as.Date('2015-01-01') & Time <= as.Date('2024-12-01')) %>%
  rename(date = Time,
         cpi = Value) %>%
  mutate(cpi_rebased = cpi / 80.4309 * 100)

#######################
###### SoDra data #####
#######################
df <- read_dta(here('data', 'municipality_GENDER.dta')) %>%
  mutate(
    year = 1960 + (monthly %/% 12),
    month = 1 + (monthly %% 12),
    quarter = ceiling(month / 3),
    date = as.Date(sprintf('%d-%02d-01', year, month))
  ) %>%
  mutate(municipality_name = str_replace_all(municipality_old, c('rajono savivaldybė' = 'r. sav.',
                                                                 'miesto savivaldybė' = 'm. sav.',
                                                                 'savivaldybė' = 'sav.')))

df <- merge(df, cpi, by = 'date')

df_women <- df %>%
  filter(FEMALE == 1)

df_men <- df %>%
  filter(FEMALE == 0)

# Transport
df_tr <- read_dta(here('data', 'municipality_GENDER_noTRANSP.dta')) %>%
  mutate(
    year = 1960 + (monthly %/% 12),
    month = 1 + (monthly %% 12),
    quarter = ceiling(month / 3),
    date = as.Date(sprintf('%d-%02d-01', year, month))
  ) %>%
  mutate(municipality_name = str_replace_all(municipality_old, c('rajono savivaldybė' = 'r. sav.',
                                                                 'miesto savivaldybė' = 'm. sav.',
                                                                 'savivaldybė' = 'sav.')))

df_tr <- merge(df_tr, cpi, by = 'date')

df_women_tr <- df_tr %>%
  filter(FEMALE == 1)

df_men_tr <- df_tr %>%
  filter(FEMALE == 0)

# Controls
df_controls <- read_dta(here('data', 'municipality_CONTROLS.dta')) %>%
  mutate(
    year = 1960 + (monthly %/% 12),
    month = 1 + (monthly %% 12),
    quarter = ceiling(month / 3),
    date = as.Date(sprintf('%d-%02d-01', year, month))
  )

########################
# Summed df
#####################
df_sum <- df %>%
  group_by(year, month, date, monthly, municipality, municipality_name) %>%
  summarise(across(PPL:UBon_BLR, sum, na.rm = TRUE)) %>%
  ungroup()

df_pop <- df_sum %>%
  select(date, municipality, municipality_name, PPL, EMP_full, PPL_LTU, EMP_full_LTU) %>%
  rename(local_pop = 'PPL',
         local_emp = 'EMP_full',
         lt_pop = 'PPL_LTU',
         lt_emp = 'EMP_full_LTU')

pre_pop <- df_sum %>%
  filter(year >= 2015 & year <= 2018) %>%
  group_by(municipality) %>%
  summarise(pop = mean(PPL, na.rm = TRUE))

df_women <- merge(df_women, df_pop, by = c('date', 'municipality', 'municipality_name'))
df_women <- merge(df_women, pre_pop, by = c('municipality')) %>%
  mutate(pre_pop = pop / sum(pre_pop$pop))

df_men <- merge(df_men, df_pop, by = c('date', 'municipality', 'municipality_name'))
df_men <- merge(df_men, pre_pop, by = c('municipality')) %>%
  mutate(pre_pop = pop / sum(pre_pop$pop))

df_sum <- merge(df_sum, pre_pop, by = 'municipality') %>%
  mutate(pre_pop = pop / sum(pre_pop$pop))

df_sum_tr <- df_tr %>%
  group_by(year, month, date, monthly, municipality, municipality_name) %>%
  summarise(across(FRM:UBon_BLR, sum, na.rm = TRUE))

df_pop_tr <- df_sum_tr %>%
  select(date, municipality, PPL, EMP_full, PPL_LTU, EMP_full_LTU) %>%
  rename(local_pop = 'PPL',
         local_emp = 'EMP_full',
         lt_pop = 'PPL_LTU',
         lt_emp = 'EMP_full_LTU')

df_women_tr <- merge(df_women_tr, df_pop_tr, by = c('date', 'municipality', 'monthly', 'year', 'month'))
df_men_tr <- merge(df_men_tr, df_pop_tr, by = c('date', 'municipality', 'monthly', 'year', 'month'))

########################
### Map coordinates ###
#######################
coords <- read_sf(here('data', 'municipalities.geojson')) %>%
  filter(admin_level == '5') %>%
  mutate(municipality_name = str_replace_all(name, c('rajono savivaldybė' = 'r. sav.',
                                                     'miesto savivaldybė' = 'm. sav.',
                                                     'savivaldybė' = 'sav.')))

########################
# groups (no transport)  avg.
########################
s_avg_tot_tr <- df_sum_tr %>%
  filter(year <= 2018) %>%
  group_by(year, municipality) %>%
  summarise(ua = mean(PPL_UKR, na.rm = TRUE)) %>%
  ungroup() %>%
  group_by(year) %>%
  summarise(ua = sum(ua, na.rm = TRUE)) %>%
  ungroup() %>%
  summarise(ua = mean(ua, na.rm = TRUE))

groups_tr_avg <- df_sum_tr %>%
  filter(year <= 2018) %>%
  group_by(municipality, municipality_name) %>%
  summarise(ua = mean(PPL_UKR, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(s = ua / s_avg_tot_tr$ua * 100,
         treat = ifelse(s >= 1, 1, 0),
         treat05 = ifelse(s >= 0.5, 1, 0),
         treat2 = ifelse(s >= 2, 1, 0))

###########################
# Time-invariant controls
##########################
# Female and sector shares
df_controls_fixed <- df_controls %>%
  filter(year <= 2018) %>%
  group_by(municipality) %>%
  summarise(across(CONT_AGE:LOWSKILL, mean, na.rm = TRUE)) %>%
  rename(female_share = FEMALE)
############################
# Manual matches table
############################
manual_matches <- tibble(
  treated = c('Vilniaus m. sav.', 'Klaipėdos m. sav.', 'Kauno m. sav.', 'Klaipėdos r. sav.',
              'Šiaulių m. sav.', 'Vilniaus r. sav.', 'Kėdainių r. sav.',
              'Visagino sav.', 'Kauno r. sav.', 'Panevėžio m. sav.'),
  control = list(
    c('Švenčionių r. sav.', 'Molėtų r. sav.', 'Širvintų r. sav.', 'Elektrėnų sav.',
      'Trakų r. sav.', 'Šalčininkų r. sav.'),
    c('Palangos m. sav.', 'Kretingos r. sav.', 'Plungės r. sav.', 'Rietavo sav.',
      'Šilalės r. sav.', 'Šilutės r. sav.', 'Neringos sav.'),
    c('Jonavos r. sav.', 'Kaišiadorių r. sav.', 'Prienų r. sav.',
      'Kazlų Rūdos sav.', 'Šakių r. sav.', 'Jurbarko r. sav.', 'Raseinių r. sav.'),
    c('Palangos m. sav.', 'Kretingos r. sav.', 'Plungės r. sav.', 'Rietavo sav.',
      'Šilalės r. sav.', 'Šilutės r. sav.', 'Neringos sav.'),
    c('Šiaulių r. sav.'),
    c('Švenčionių r. sav.', 'Molėtų r. sav.', 'Širvintų r. sav.', 'Elektrėnų sav.',
      'Trakų r. sav.', 'Šalčininkų r. sav.'),
    c('Raseinių r. sav.', 'Radviliškio r. sav.', 'Panevėžio r. sav.', 'Ukmergės r. sav.',
      'Jonavos r. sav.'),
    c('Zarasų r. sav.', 'Ignalinos r. sav.'),
    c('Jonavos r. sav.', 'Kaišiadorių r. sav.', 'Prienų r. sav.',
      'Kazlų Rūdos sav.', 'Šakių r. sav.', 'Jurbarko r. sav.', 'Raseinių r. sav.'),
    c('Panevėžio r. sav.')
  )
) %>%
  unnest(control) %>%
  mutate(match_id = paste(treated, row_number(), sep = '_'))
