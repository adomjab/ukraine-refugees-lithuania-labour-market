source(here::here("R", "00_load_data.R"))
source(here::here("R", "functions.R"))

################################################################################
# Aggregates excluding transport sector
# (needed to split registrations into transport / other sectors)
################################################################################
# Ukrainians
ua_tr <- df_tr %>%
  group_by(date, monthly, year, month, FEMALE) %>%
  summarise(ua = sum(PPL_UKR, na.rm = TRUE),
            ppl = sum(PPL, na.rm = TRUE),
            ua_work = sum(EMP_full_UKR, na.rm = TRUE),
            ua_mw = sum(MW_UKR, na.rm = TRUE),
            ubon = sum(UBon_UKR, na.rm = TRUE)) %>%
  ungroup()

ua_long_tr <- ua_tr %>%
  select(date, ua, ua_work, ua_mw, FEMALE) %>%
  pivot_longer(-c(date, FEMALE),
               names_to = 'type',
               values_to = 'ua') %>%
  mutate(type = case_when(
    type == 'ua' ~ 'Registered in SoDra',
    type == 'ua_work' ~ 'Employed full-time',
    type == 'ua_mw' ~ 'Low-attachment',
    TRUE ~ type ),
    type = factor(type, levels = c('Registered in SoDra', 'Employed full-time',
                                   'Low-attachment')),
    FEMALE = ifelse(FEMALE == 1, 'Women', 'Men'))

# Lithuanians
lt_tr <- df_tr %>%
  group_by(date, monthly, year, month, FEMALE) %>%
  summarise(lt = sum(PPL_LTU, na.rm = TRUE),
            ppl = sum(PPL, na.rm = TRUE),
            lt_work = sum(EMP_full_LTU, na.rm = TRUE),
            lt_mw = sum(MW_LTU, na.rm = TRUE),
            ubon = sum(UBon_LTU, na.rm = TRUE)) %>%
  ungroup()

lt_long_tr <- lt_tr %>%
  select(date, lt, lt_work, lt_mw, FEMALE) %>%
  pivot_longer(-c(date, FEMALE),
               names_to = 'type',
               values_to = 'lt') %>%
  mutate(type = case_when(
    type == 'lt' ~ 'Registered in SoDra',
    type == 'lt_work' ~ 'Employed full-time',
    type == 'lt_mw' ~ 'Low-attachment',
    TRUE ~ type ),
    type = factor(type, levels = c('Registered in SoDra', 'Employed full-time',
                                   'Low-attachment')),
    FEMALE = ifelse(FEMALE == 1, 'Women', 'Men'))

# Other countries
other_tr <- df_tr %>%
  mutate(other = PPL - PPL_LTU - PPL_UKR,
         other_work = EMP_full - EMP_full_LTU - EMP_full_UKR,
         other_mw = MW - MW_LTU - MW_UKR,
         other_ubon = UBon - UBon_LTU - UBon_UKR) %>%
  group_by(date, monthly, year, month, FEMALE) %>%
  summarise(other = sum(other, na.rm = TRUE),
            ppl = sum(PPL, na.rm = TRUE),
            other_work = sum(other_work, na.rm = TRUE),
            other_mw = sum(other_mw, na.rm = TRUE),
            other_ubon = sum(other_ubon, na.rm = TRUE)) %>%
  ungroup()

other_long_tr <- other_tr %>%
  select(date, other, other_work, other_mw, FEMALE) %>%
  pivot_longer(-c(date, FEMALE),
               names_to = 'type',
               values_to = 'other') %>%
  mutate(type = case_when(
    type == 'other' ~ 'Registered in SoDra',
    type == 'other_work' ~ 'Employed full-time',
    type == 'other_mw' ~ 'Low-attachment',
    TRUE ~ type ),
    type = factor(type, levels = c('Registered in SoDra', 'Employed full-time',
                                   'Low-attachment')),
    FEMALE = ifelse(FEMALE == 1, 'Women', 'Men'))

################################################################################
# Figure 1: Ukrainian citizens registered in SoDra
################################################################################
ua_gend <- df %>%
  group_by(date, year, month, FEMALE) %>%
  summarise(ua = sum(PPL_UKR, na.rm = TRUE),
            ppl = sum(PPL, na.rm = TRUE),
            ua_work = sum(EMP_full_UKR, na.rm = TRUE),
            ua_mw = sum(MW_UKR, na.rm = TRUE),
            ubon = sum(UBon_UKR, na.rm = TRUE)) %>%
  ungroup()

ua_long_gend <- ua_gend %>%
  select(date, ua, ua_work, ua_mw, FEMALE) %>%
  pivot_longer(-c(date, FEMALE),
               names_to = 'type',
               values_to = 'ua') %>%
  mutate(type = case_when(
    type == 'ua' ~ 'Registered in SoDra',
    type == 'ua_work' ~ 'Employed full-time',
    type == 'ua_mw' ~ 'Low-attachment',
    TRUE ~ type ),
    type = factor(type, levels = c('Registered in SoDra', 'Employed full-time',
                                   'Low-attachment')),
    FEMALE = ifelse(FEMALE == 1, 'Women', 'Men'))

plot_gender_ts(ua_long_gend, 'ua', 'People',
               'Ukrainian citizens registered in SoDra', 'ts_ua_gender.png')

################################################################################
# Figure A.1: Lithuanian citizens registered in SoDra
################################################################################
lt_gend <- df %>%
  group_by(date, year, month, FEMALE) %>%
  summarise(lt = sum(PPL_LTU, na.rm = TRUE),
            ppl = sum(PPL, na.rm = TRUE),
            lt_work = sum(EMP_full_LTU, na.rm = TRUE),
            lt_mw = sum(MW_LTU, na.rm = TRUE),
            ubon = sum(UBon_LTU, na.rm = TRUE)) %>%
  ungroup()

lt_long_gend <- lt_gend %>%
  select(date, lt, lt_work, lt_mw, FEMALE) %>%
  pivot_longer(-c(date, FEMALE),
               names_to = 'type',
               values_to = 'lt') %>%
  mutate(type = case_when(
    type == 'lt' ~ 'Registered in SoDra',
    type == 'lt_work' ~ 'Employed full-time',
    type == 'lt_mw' ~ 'Low-attachment',
    TRUE ~ type ),
    type = factor(type, levels = c('Registered in SoDra', 'Employed full-time',
                                   'Low-attachment')),
    FEMALE = ifelse(FEMALE == 1, 'Women', 'Men'))

plot_gender_ts(lt_long_gend, 'lt', 'People',
               'Lithuanian citizens registered in SoDra', 'ts_lt_gender.png')

################################################################################
# Figure A.3: Citizens of other countries registered in SoDra
################################################################################
other_gend <- df %>%
  mutate(other = PPL - PPL_LTU - PPL_UKR,
         other_work = EMP_full - EMP_full_LTU - EMP_full_UKR,
         other_mw = MW - MW_LTU - MW_UKR,
         other_ubon = UBon - UBon_LTU - UBon_UKR) %>%
  group_by(date, year, month, FEMALE) %>%
  summarise(other = sum(other, na.rm = TRUE),
            ppl = sum(PPL, na.rm = TRUE),
            other_work = sum(other_work, na.rm = TRUE),
            other_mw = sum(other_mw, na.rm = TRUE),
            other_ubon = sum(other_ubon, na.rm = TRUE)) %>%
  ungroup()

other_long_gend <- other_gend %>%
  select(date, other, other_work, other_mw, FEMALE) %>%
  pivot_longer(-c(date, FEMALE),
               names_to = 'type',
               values_to = 'other') %>%
  mutate(type = case_when(
    type == 'other' ~ 'Registered in SoDra',
    type == 'other_work' ~ 'Employed full-time',
    type == 'other_mw' ~ 'Low-attachment',
    TRUE ~ type ),
    type = factor(type, levels = c('Registered in SoDra', 'Employed full-time',
                                   'Low-attachment')),
    FEMALE = ifelse(FEMALE == 1, 'Women', 'Men'))

plot_gender_ts(other_long_gend, 'other', 'People',
               'Citizens of other countries registered in SoDra', 'ts_other_gender.png')

################################################################################
# Figure A.2: Ukrainian / Lithuanian ratio
################################################################################
gend_merged <- merge(lt_long_gend, ua_long_gend, by = c('date', 'FEMALE', 'type')) %>%
  mutate(ratio = ua / lt)

plot_gender_ts(gend_merged, 'ratio', 'Ratio',
               'Ukrainian/Lithuanian ratio in SoDra', 'ts_ua_lt_ratio.png')

################################################################################
# Figure 2: Ukrainians by employment sector
################################################################################
ua_all_tr_gend <- merge(ua_long_gend, ua_long_tr, by = c('date', 'type', 'FEMALE')) %>%
  mutate(transport = `ua.x` - `ua.y`) %>%
  filter(type == 'Registered in SoDra') %>%
  rename(`Registered in SoDra` = 'ua.x',
         `In other sectors` = 'ua.y',
         `In transport sector` = 'transport') %>%
  select(-type) %>%
  pivot_longer(-c(date, FEMALE),
               names_to = 'type',
               values_to = 'ua') %>%
  mutate(type = factor(type, c('Registered in SoDra', 'In transport sector',
                               'In other sectors')))

plot_gender_ts(ua_all_tr_gend, 'ua', 'People',
               'Ukrainian citizens by employment sector', 'ts_ua_sector.png')

################################################################################
# Figure A.4: Lithuanians by employment sector
################################################################################
lt_all_tr_gend <- merge(lt_long_gend, lt_long_tr, by = c('date', 'type', 'FEMALE')) %>%
  mutate(transport = lt.x - lt.y) %>%
  filter(type == 'Registered in SoDra') %>%
  rename(`Registered in SoDra` = 'lt.x',
         `In other sectors` = 'lt.y',
         `In transport sector` = 'transport') %>%
  select(-type) %>%
  pivot_longer(-c(date, FEMALE),
               names_to = 'type',
               values_to = 'lt') %>%
  mutate(type = factor(type, c('Registered in SoDra', 'In transport sector',
                               'In other sectors')))

plot_gender_ts(lt_all_tr_gend, 'lt', 'People',
               'Lithuanian citizens by employment sector', 'ts_lt_sector.png')

################################################################################
# Figure A.5: Ukrainian / Lithuanian ratio by employment sector
################################################################################
relative_transp <- merge(lt_all_tr_gend, ua_all_tr_gend, by = c('date', 'FEMALE', 'type')) %>%
  mutate(ratio = ua / lt)

plot_gender_ts(relative_transp, 'ratio', 'Ratio',
               'Ukrainian/Lithuanian ratio by employment sector', 'ts_ua_lt_ratio_sector.png')

################################################################################
# Figure A.6: Citizens of other countries by employment sector
################################################################################
other_all_tr_gend <- merge(other_long_gend, other_long_tr, by = c('date', 'type', 'FEMALE')) %>%
  mutate(transport = `other.x` - `other.y`) %>%
  filter(type == 'Registered in SoDra') %>%
  rename(`Registered in SoDra` = 'other.x',
         `In other sectors` = 'other.y',
         `In transport sector` = 'transport') %>%
  select(-type) %>%
  pivot_longer(-c(date, FEMALE),
               names_to = 'type',
               values_to = 'other') %>%
  mutate(type = factor(type, c('Registered in SoDra', 'In transport sector',
                               'In other sectors')))

plot_gender_ts(other_all_tr_gend, 'other', 'People',
               'Citizens of other countries by employment sector', 'ts_other_sector.png')
