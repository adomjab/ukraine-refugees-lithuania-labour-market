source(here::here("R", "00_load_data.R"))
source(here::here("R", "functions.R"))

###########################
# Further labour market implications
###########################
df_labour <- merge(df_controls, groups_tr_avg, by = 'municipality') %>%
  filter(date >= as.Date('2019-01-01')) %>%
  mutate(post = ifelse(date >= as.Date('2022-03-01'), 1, 0),
         event = monthly - 746) %>%
  select(municipality, municipality_name, date, event, FRM, LOWSKILL, CLERICAL,
         SERVSALES, HIGHSKILL, treat, post) %>%
  rename(low_skill = LOWSKILL,
         clerical = CLERICAL,
         servsales = SERVSALES,
         high_skill = HIGHSKILL,
         firms = FRM) %>%
  merge(pre_pop, by = 'municipality') %>%
  mutate(pre_pop = pop / sum(pre_pop$pop))

################################################################################
# Firm activity (Figure 13, Table 8)
################################################################################
# Time series with separate axes for treated and control
df_firms_ts <- df_labour %>%
  group_by(treat, date) %>%
  summarise(firms = mean(firms, na.rm = TRUE), .groups = 'drop') %>%
  mutate(treat = factor(ifelse(treat == 1, 'Treated', 'Control'),
                        levels = c('Treated', 'Control')))

scale_factor <- mean(df_firms_ts$firms[df_firms_ts$treat == 'Treated'], na.rm = TRUE) /
  mean(df_firms_ts$firms[df_firms_ts$treat == 'Control'], na.rm = TRUE)

p_firms <- df_firms_ts %>%
  mutate(firms_plot = ifelse(treat == 'Control', firms * scale_factor, firms)) %>%
  ggplot(aes(x = date, y = firms_plot, group = treat, colour = treat, linetype = treat)) +
  geom_line() +
  geom_vline(xintercept = as.Date('2022-02-01'),
             linetype = 'dashed', color = 'black', linewidth = 0.3) +
  scale_color_manual(values = c('Treated' = '#F8766D', 'Control' = '#00BA38')) +
  scale_y_continuous(name = 'Treated firms',
                     sec.axis = sec_axis(~ . / scale_factor, name = 'Control firms')) +
  labs(title = 'Number of firms', x = '', color = '', linetype = '') +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = 'bottom',
        legend.background = element_rect(fill = 'white', color = 'black', linewidth = 0.3),
        legend.margin = margin(4, 6, 4, 6))

ggsave(here::here('figures', 'ts_firms.png'), plot = p_firms, width = 8, height = 4)

run_event_study(df_labour, 'firms') %>%
  plot_event_study('Number of firms', 'es_firms.png')
run_static(df_labour, 'firms', 'static_firms')

################################################################################
# Skill composition
################################################################################
# Figure 14, Table 9: low-skill share
plot_timeseries(df_labour, 'low_skill', 'Low-skill share', 'ts_low_skill.png')
run_event_study(df_labour, 'low_skill') %>%
  plot_event_study('Low-skill share', 'es_low_skill.png')
run_static(df_labour, 'low_skill', 'static_low_skill')

# Figure A.7, Table A.5: clerical share
plot_timeseries(df_labour, 'clerical', 'Clerical share', 'ts_clerical.png')
run_event_study(df_labour, 'clerical') %>%
  plot_event_study('Clerical share', 'es_clerical.png')
run_static(df_labour, 'clerical', 'static_clerical')

# Figure A.8, Table A.6: services and sales share
plot_timeseries(df_labour, 'servsales', 'Services and sales share', 'ts_servsales.png')
run_event_study(df_labour, 'servsales') %>%
  plot_event_study('Services and sales share', 'es_servsales.png')
run_static(df_labour, 'servsales', 'static_servsales')

# Figure A.9, Table A.7: high-skill share
plot_timeseries(df_labour, 'high_skill', 'High-skill share', 'ts_high_skill.png')
run_event_study(df_labour, 'high_skill') %>%
  plot_event_study('High-skill share', 'es_high_skill.png')
run_static(df_labour, 'high_skill', 'static_high_skill')

