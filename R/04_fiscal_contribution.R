source(here::here("R", "00_load_data.R"))

####################
## Wage bill
####################
# Estimated female Ukrainian refugees employed, their wage bill and taxes paid
df_bill <- df_women %>%
  select(date, year, municipality, EMP_full_UKR, WAGE_full_UKR) %>%
  group_by(municipality) %>%
  mutate(ref = EMP_full_UKR[date == as.Date('2022-02-01')],
         refugees = ifelse(EMP_full_UKR - ref >= 0, EMP_full_UKR - ref, 0)) %>%
  ungroup() %>%
  filter(date >= as.Date('2022-03-01')) %>%
  mutate(bill = refugees * WAGE_full_UKR,
         income_tax = bill * 0.2,
         social_security_tax = bill * 0.1252,
         health_tax = bill * 0.0698) %>%
  drop_na()

# Table 10: totals by year + overall total
df_bill_total <- df_bill %>%
  group_by(year) %>%
  summarise(bill = sum(bill, na.rm = TRUE),
            income_tax = sum(income_tax, na.rm = TRUE),
            social_security_tax = sum(social_security_tax, na.rm = TRUE),
            health_tax = sum(health_tax, na.rm = TRUE)) %>%
  mutate(year = as.character(year)) %>%
  bind_rows(summarise(., year = 'Total', across(bill:health_tax, sum)))

bill_table <- df_bill_total %>%
  mutate(across(bill:health_tax, ~ format(round(.x), big.mark = ','))) %>%
  rename(Year = year,
         'Total wage bill' = bill,
         'Income tax' = income_tax,
         'Social insurance contributions' = social_security_tax,
         'Health insurance contributions' = health_tax)
bill_table
writeLines(knitr::kable(bill_table, format = 'latex', booktabs = TRUE, align = 'lrrrr'),
           here::here('tables', 'wage_bill.tex'))
writeLines(knitr::kable(bill_table, format = 'pipe', align = 'lrrrr'),
           here::here('tables', 'wage_bill.md'))
