# make_synthetic_data.R
#
# Creates synthetic stand-ins for the confidential SoDra files:
#   data/municipality_GENDER.dta
#   data/municipality_GENDER_noTRANSP.dta
#   data/municipality_CONTROLS.dta
#
# Same columns, column order and formats as the real files, so 00_load_data.R
# and all later scripts run unchanged. Values are simulated from arbitrary rules:
# magnitudes, municipality sizes, wage levels and effect sizes are deliberately
# NOT calibrated to the real data or to the thesis results.
#
# Kept from the thesis design (needed for the code to run):
#   - real municipality names
#   - the same 10 treated municipalities (those in manual_matches)
# Built-in patterns (so the pipeline produces visible output):
#   - After March 2022, Ukrainian women rise, more in treated municipalities
#   - Ukrainian men fall after the invasion
#   - No effect on Lithuanian employment or wages
#
# cpi.csv and municipalities.geojson are public and are not simulated.

library(tidyverse)
library(haven)
library(here)

set.seed(2026)

out_files <- here('data', c('municipality_GENDER.dta',
                            'municipality_GENDER_noTRANSP.dta',
                            'municipality_CONTROLS.dta'))
if (any(file.exists(out_files))) {
  stop('Data files already exist in data/. Move or delete them before running this script.')
}

add_noise <- function(x, sd = 0.02) x * rnorm(length(x), 1, sd)

################################
# 1. Municipalities
################################
# Real names, so they match manual_matches and municipalities.geojson
city <- c('Alytaus', 'Kauno', 'Klaipėdos', 'Palangos', 'Panevėžio', 'Šiaulių', 'Vilniaus')
other_sav <- c('Birštono', 'Druskininkų', 'Elektrėnų', 'Kalvarijos', 'Kazlų Rūdos',
               'Marijampolės', 'Neringos', 'Pagėgių', 'Rietavo', 'Visagino')
district <- c('Akmenės', 'Alytaus', 'Anykščių', 'Biržų', 'Ignalinos', 'Jonavos', 'Joniškio',
              'Jurbarko', 'Kaišiadorių', 'Kauno', 'Kėdainių', 'Kelmės', 'Klaipėdos', 'Kretingos',
              'Kupiškio', 'Lazdijų', 'Mažeikių', 'Molėtų', 'Pakruojo', 'Panevėžio', 'Pasvalio',
              'Plungės', 'Prienų', 'Radviliškio', 'Raseinių', 'Rokiškio', 'Skuodo', 'Šakių',
              'Šalčininkų', 'Šiaulių', 'Šilalės', 'Šilutės', 'Širvintų', 'Švenčionių', 'Tauragės',
              'Telšių', 'Trakų', 'Ukmergės', 'Utenos', 'Varėnos', 'Vilkaviškio', 'Vilniaus', 'Zarasų')

# Treated municipalities (same as in manual_matches)
treated_names <- c('Vilniaus m. sav.', 'Klaipėdos m. sav.', 'Kauno m. sav.', 'Klaipėdos r. sav.',
                   'Šiaulių m. sav.', 'Vilniaus r. sav.', 'Kėdainių r. sav.',
                   'Visagino sav.', 'Kauno r. sav.', 'Panevėžio m. sav.')

municipalities <- tibble(
  municipality_old = c(paste(city, 'miesto savivaldybė'),
                       paste(other_sav, 'savivaldybė'),
                       paste(district, 'rajono savivaldybė'))
) %>%
  mutate(municipality = row_number(),
         nuts3 = 'synthetic',
         name = str_replace_all(municipality_old, c('rajono savivaldybė' = 'r. sav.',
                                                    'miesto savivaldybė' = 'm. sav.',
                                                    'savivaldybė' = 'sav.')),
         treated = name %in% treated_names)

# Pre-war share of all Ukrainians (%), as computed in groups_tr_avg.
# Shares are assigned at random within groups, so they do not follow the real distribution:
#   treated: 7 above 2%, 3 between 1% and 2% (in random order)
#   5 random untreated municipalities: between 0.5% and 1% (treated only at the 0.5% threshold)
#   all other municipalities: below 0.5%
mid_group <- sample(which(!municipalities$treated), 5)

municipalities <- municipalities %>%
  mutate(s = runif(n(), 0.25, 0.45))
municipalities$s[municipalities$treated] <- sample(c(18, 15, 12, 10, 8, 6, 4, 1.8, 1.5, 1.2))
municipalities$s[mid_group] <- runif(5, 0.6, 0.9)

municipalities <- municipalities %>%
  mutate(s_norm = s / sum(s),
         ref_w = s^1.3 / sum(s^1.3),          # refugees concentrate where Ukrainians lived
         # Arbitrary sizes, not real registration counts
         size = round(ifelse(treated, runif(n(), 30000, 150000), runif(n(), 3000, 20000))),
         size_norm = size / sum(size),
         wage_mult = runif(n(), 0.85, 1.25),
         AGE_29 = runif(n(), 0.18, 0.26),
         AGE_55 = runif(n(), 0.22, 0.32),
         AGE_3054 = 1 - AGE_29 - AGE_55)

################################
# 2. Gender panel: counts by nationality and sector
################################
# _notr = outside transport, _tr = transport sector
panel <- expand_grid(municipalities, monthly = 660:779, FEMALE = c(0, 1)) %>%
  mutate(t = (monthly - 660) / 12,
         war_m = pmax(0, monthly - 745),      # months since February 2022
         post = as.numeric(monthly >= 746),

         # Ukrainians (arbitrary national totals)
         ua_nat = 3000 + 2000 * pmin(monthly - 660, 85) / 85,
         ua_base = ua_nat * s_norm * ifelse(FEMALE == 1, 0.3, 0.7),
         refugees = ifelse(FEMALE == 1 & war_m > 0,
                           25000 * (1 - exp(-war_m / 6)) * ref_w,
                           0),
         UKR_notr = pmax(1, round(add_noise(ua_base * ifelse(FEMALE == 0 & post == 1, 0.7, 1) +
                                              refugees))),
         UKR_tr = round(add_noise(ifelse(FEMALE == 0,
                                         ua_base * 0.8 * ifelse(post == 1, 0.7, 1),
                                         UKR_notr * 0.05))),

         # Lithuanians (flat apart from noise)
         LTU_notr = round(add_noise(size / 2 * ifelse(FEMALE == 1, 0.95, 0.85), 0.01)),
         LTU_tr = round(add_noise(size / 2 * ifelse(FEMALE == 1, 0.05, 0.15), 0.01)),

         # Belarusians
         BLR_notr = round(add_noise(size * ifelse(FEMALE == 1, 0.001, 0.002) * (1 + 0.1 * t))),
         BLR_tr = round(add_noise(size * ifelse(FEMALE == 1, 0, 0.001) * (1 + 0.1 * t))),

         # Other nationalities (only enter the totals)
         oth_nat = ifelse(FEMALE == 1, 2000 + 300 * t, 5000 + 2000 * t),
         oth_tshare = ifelse(FEMALE == 1, 0.05, 0.4),
         OTH_notr = round(add_noise(oth_nat * size_norm * (1 - oth_tshare))),
         OTH_tr = round(add_noise(oth_nat * size_norm * oth_tshare)),

         # Full-time employment and low-attachment (minimum wage) rates
         emp_LTU = 0.80,
         emp_UKR = ifelse(FEMALE == 1, ifelse(post == 1, 0.70, 0.75), 0.80),
         emp_BLR = 0.80,
         emp_OTH = 0.80,
         mw_LTU = 0.10,
         mw_UKR = ifelse(FEMALE == 1, ifelse(post == 1, 0.20, 0.10), 0.10),
         mw_BLR = 0.10,
         mw_OTH = 0.10,

         # Nominal wages (round, arbitrary levels)
         WAGE_full_LTU = add_noise(1000 * 1.05^t * wage_mult * ifelse(FEMALE == 1, 0.9, 1)),
         WAGE_full_UKR = add_noise(WAGE_full_LTU * 0.9),
         WAGE_full_BLR = add_noise(WAGE_full_LTU * 0.9),
         WAGE_full = WAGE_full_LTU,
         WAGE_part = WAGE_full * 0.5,
         WAGE_part_LTU = WAGE_full_LTU * 0.5,
         WAGE_part_UKR = WAGE_full_UKR * 0.5,
         WAGE_part_BLR = WAGE_full_BLR * 0.5,

         # Firms: steady growth
         FRM = round(add_noise(size * 0.03 * (1 + 0.02 * t), 0.01)))

################################
# 3. Assemble a file: all sectors or transport excluded
################################
build_file <- function(panel, sector) {
  d <- panel

  for (nat in c('LTU', 'UKR', 'BLR', 'OTH')) {
    n <- d[[paste0(nat, '_notr')]]
    if (sector == 'full') n <- n + d[[paste0(nat, '_tr')]]

    emp <- pmin(1, d[[paste0('emp_', nat)]] * rnorm(nrow(d), 1, 0.01))

    d[[paste0('PPL_', nat)]]      <- n
    d[[paste0('EMP_full_', nat)]] <- round(n * emp)
    d[[paste0('EMP_part_', nat)]] <- round(n * 0.05)
    d[[paste0('MW_', nat)]]       <- round(n * d[[paste0('mw_', nat)]])
    d[[paste0('UBon_', nat)]]     <- round(n * 0.02)
    d[[paste0('UB_bft_', nat)]]   <- round(n * 0.01)
  }

  # Totals include all nationalities
  for (v in c('PPL', 'EMP_full', 'EMP_part', 'MW', 'UBon', 'UB_bft')) {
    d[[v]] <- d[[paste0(v, '_LTU')]] + d[[paste0(v, '_UKR')]] +
      d[[paste0(v, '_BLR')]] + d[[paste0(v, '_OTH')]]
  }

  if (sector == 'notr') d$FRM <- round(d$FRM * 0.93)

  # Same column order as the real files
  d %>%
    select(monthly, municipality, FEMALE, FRM,
           PPL, PPL_LTU, PPL_UKR, PPL_BLR,
           EMP_full, EMP_part, EMP_full_LTU, EMP_part_LTU,
           EMP_full_UKR, EMP_part_UKR, EMP_full_BLR, EMP_part_BLR,
           MW, MW_LTU, MW_UKR, MW_BLR,
           UBon, UBon_LTU, UBon_UKR, UBon_BLR,
           UB_bft, UB_bft_LTU, UB_bft_UKR, UB_bft_BLR,
           WAGE_full, WAGE_part, WAGE_full_LTU, WAGE_part_LTU,
           WAGE_full_UKR, WAGE_part_UKR, WAGE_full_BLR, WAGE_part_BLR,
           AGE_29, AGE_3054, AGE_55, municipality_old, nuts3)
}

################################
# 4. Controls file
################################
sectors <- c('PUBLIC', 'PRIMARY', 'MANUF', 'CONSTR', 'TRADE', 'TRANSPORT',
             'HOSP', 'ICT', 'FIN', 'PROF', 'ADMIN', 'OTHERSERV')

sector_shares <- matrix(rgamma(nrow(municipalities) * length(sectors), shape = 5),
                        ncol = length(sectors))
sector_shares <- sector_shares / rowSums(sector_shares)
colnames(sector_shares) <- sectors

muni_controls <- municipalities %>%
  select(municipality, treated, size, AGE_29, AGE_3054, AGE_55) %>%
  bind_cols(as_tibble(sector_shares)) %>%
  mutate(CONT_AGE = runif(n(), 38, 46),
         female_share = runif(n(), 0.45, 0.55),
         # Random skill levels and municipality-specific trends, unrelated to treatment
         high_0 = runif(n(), 0.15, 0.30),
         cler_0 = runif(n(), 0.08, 0.14),
         serv_0 = runif(n(), 0.15, 0.25),
         high_trend = rnorm(n(), 0, 0.003))

controls <- expand_grid(muni_controls, monthly = 660:779) %>%
  mutate(t = (monthly - 660) / 12,
         FEMALE = female_share,
         # Skill shares
         HIGHSKILL = add_noise(high_0 + high_trend * t, 0.01),
         CLERICAL = add_noise(cler_0, 0.01),
         SERVSALES = add_noise(serv_0, 0.01),
         LOWSKILL = 1 - HIGHSKILL - CLERICAL - SERVSALES,
         FRM = round(add_noise(size * 0.03 * (1 + 0.02 * t), 0.01))) %>%
  select(monthly, municipality, CONT_AGE, AGE_29, AGE_3054, AGE_55, FEMALE,
         PUBLIC, PRIMARY, MANUF, CONSTR, TRADE, TRANSPORT, HOSP, ICT, FIN,
         PROF, ADMIN, OTHERSERV, HIGHSKILL, CLERICAL, SERVSALES, LOWSKILL, FRM)

################################
# 5. Write .dta files
################################
write_dta(build_file(panel, 'full'), out_files[1])
write_dta(build_file(panel, 'notr'), out_files[2])
write_dta(controls, out_files[3])
