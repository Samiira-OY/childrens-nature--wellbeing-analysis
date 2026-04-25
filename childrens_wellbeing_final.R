# =============================================================================
# Children's Connection to Nature and Reported Happiness
# Author: Samiira Osman Yusuf
# BSc Social Data Science, University College London
# =============================================================================
# Data source:
#   - Children's People and Nature Survey (C-PaNS), Natural England
#   - File: c-pans_waves_1-6_holiday_2021_term_2023_open_access.csv
#   - Available from: https://www.gov.uk/government/collections/people-and-nature-survey
# =============================================================================

# ── 0. Setup ──────────────────────────────────────────────────────────────────

rm(list = ls())   # clear environment
graphics.off()    # close any open plots
cat("\014")       # clear console


# ── 1. Load Packages ──────────────────────────────────────────────────────────

library(tidyverse)
library(ggplot2)
library(patchwork)


# ── 2. Import Data ────────────────────────────────────────────────────────────

df <- read_csv("c-pans_waves_1-6_holiday_2021_term_2023_open_access.csv")


# ── 3. Select Variables ───────────────────────────────────────────────────────

# Y  = CS_Wellbeing_happy (happiness, 0-10)
# X  = CS_Q11 (connection to nature, 1-7)
# x2 = CS_Q9  (environmental attitudes, 1-5)
# x3 = CS_S_Region (region)
# x4 = Period (term time / school holiday)

df <- df %>%
  select(CS_Wellbeing_happy,  # Y
         CS_Q11,              # X
         CS_Q9,               # control
         CS_S_Region,         # control
         Period)              # control


# ── 4. Recode Variables ───────────────────────────────────────────────────────

## 4.1 Recode wellbeing (fix any 11s to 10, keep 0-10 scale)
df <- df %>%
  mutate(CS_Wellbeing_happy = ifelse(CS_Wellbeing_happy > 10, 10, CS_Wellbeing_happy))

## 4.2 Recode Period (1 = term time, 2 = school holiday)
df <- df %>%
  mutate(Period = factor(Period,
                         levels = c(1, 2),
                         labels = c("Term time", "School holiday")))

## 4.3 Recode Region (1-9 -> named UK regions)
df <- df %>%
  mutate(CS_S_Region = factor(CS_S_Region,
                              levels = 1:9,
                              labels = c("North East", "North West",
                                         "Yorkshire and the Humber",
                                         "East Midlands", "West Midlands",
                                         "East England", "London",
                                         "South East", "South West")))


# ── 5. Recoding Checks ────────────────────────────────────────────────────────

# Check distinct values in each variable
df %>% summarise(across(everything(), n_distinct))

# 1. Check wellbeing (should be 0-10 only)
table(df$CS_Wellbeing_happy, useNA = "ifany")

# 2. Check Period (should show "Term time" and "School holiday")
table(df$Period, useNA = "ifany")

# 3. Check Region (should show 9 named regions)
table(df$CS_S_Region, useNA = "ifany")

# 4. Check CS_Q11 (connection to nature, 1-7)
table(df$CS_Q11, useNA = "ifany")

# 5. Check CS_Q9 (thoughts on importance of environment, 1-5)
table(df$CS_Q9, useNA = "ifany")


# ── 6. Missingness Check ──────────────────────────────────────────────────────

vars <- c("CS_Wellbeing_happy", "CS_Q11", "CS_Q9", "CS_S_Region", "Period")

total_n <- nrow(df)

missing_summary <- df %>%
  summarise(across(all_of(vars), ~sum(is.na(.)), .names = "Missing_{col}")) %>%
  pivot_longer(everything(),
               names_to  = "Variable",
               values_to = "Missing_N") %>%
  mutate(Variable    = gsub("Missing_", "", Variable),
         Total_N     = total_n,
         Missing_Pct = round((Missing_N / total_n) * 100, 2),
         Valid_N     = Total_N - Missing_N,
         Valid_Pct   = round((Valid_N / Total_N) * 100, 2))

missing_summary


# ── 7. Complete-Case Dataset ──────────────────────────────────────────────────

df_complete <- df %>%
  drop_na(CS_Wellbeing_happy, CS_Q11, CS_Q9, CS_S_Region, Period)

final_N <- nrow(df_complete)
final_N  # should return 11796


# ── 8. Descriptive Statistics ─────────────────────────────────────────────────

# 1) Wellbeing (Y)
wellbeing_stats <- df %>%
  summarise(n      = sum(!is.na(CS_Wellbeing_happy)),
            mean   = mean(CS_Wellbeing_happy, na.rm = TRUE),
            sd     = sd(CS_Wellbeing_happy, na.rm = TRUE),
            median = median(CS_Wellbeing_happy, na.rm = TRUE),
            min    = min(CS_Wellbeing_happy, na.rm = TRUE),
            max    = max(CS_Wellbeing_happy, na.rm = TRUE))

wellbeing_freq <- df %>%
  count(CS_Wellbeing_happy) %>%
  mutate(pct = round(n / sum(n) * 100, 2))

wellbeing_stats
wellbeing_freq

# 2) Connection to Nature (X)
conn_stats <- df %>%
  summarise(n      = sum(!is.na(CS_Q11)),
            mean   = mean(CS_Q11, na.rm = TRUE),
            sd     = sd(CS_Q11, na.rm = TRUE),
            median = median(CS_Q11, na.rm = TRUE),
            min    = min(CS_Q11, na.rm = TRUE),
            max    = max(CS_Q11, na.rm = TRUE))

conn_freq <- df %>%
  count(CS_Q11) %>%
  mutate(pct = round(n / sum(n) * 100, 2))

conn_stats
conn_freq

# Descriptive statistics for final complete-case counts
final_stats <- df_complete %>%
  summarise(
    final_mean_happy = mean(CS_Wellbeing_happy),
    final_sd_happy   = sd(CS_Wellbeing_happy),
    final_mean_conn  = mean(CS_Q11),
    final_sd_conn    = sd(CS_Q11),
    final_mean_env   = mean(CS_Q9),
    final_sd_env     = sd(CS_Q9)
  )

final_stats


# ── 9. Visualisations ─────────────────────────────────────────────────────────

p1 <- ggplot(df_complete, aes(x = CS_Wellbeing_happy)) +
  geom_histogram(binwidth = 1, fill = "grey70", color = "black") +
  labs(title = "Reported Happiness", x = "Happiness (0-10)", y = "Count") +
  theme_minimal()

p2 <- ggplot(df_complete, aes(x = CS_Q11)) +
  geom_histogram(binwidth = 1, fill = "grey70", color = "black") +
  labs(title = "Connection to Nature", x = "Connection (1-7)", y = "Count") +
  theme_minimal()

p3 <- ggplot(df_complete, aes(x = CS_Q9)) +
  geom_histogram(binwidth = 1, fill = "grey70", color = "black") +
  labs(title = "Environmental Attitudes", x = "Attitudes (1-5)", y = "Count") +
  theme_minimal()

p4 <- ggplot(df_complete, aes(x = CS_S_Region)) +
  geom_bar(fill = "grey70", color = "black") +
  labs(title = "Regional Distribution", x = "Region", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

p5 <- ggplot(df_complete, aes(x = Period)) +
  geom_bar(fill = "grey70", color = "black") +
  labs(title = "Survey Period", x = "Period", y = "Count") +
  theme_minimal()

# Top row: 3 plots
top_row <- p1 | p2 | p3

# Bottom row: 2 plots (with empty space for balance)
bottom_row <- p4 | p5 | plot_spacer()

# Combine rows
(top_row) / (bottom_row)


# ── 10. Multicollinearity Check ───────────────────────────────────────────────

library(car)

model_temp <- lm(CS_Wellbeing_happy ~ CS_Q11 + CS_Q9 + CS_S_Region + Period,
                 data = df_complete)

vif(model_temp)


# ── 11. Linearity Checks ──────────────────────────────────────────────────────

# Happiness vs Connection to Nature
ggplot(df_complete, aes(x = CS_Q11, y = CS_Wellbeing_happy)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm") +
  labs(title = "Linearity Check: Happiness vs Connection to Nature")

# Happiness vs Environmental Attitudes
ggplot(df_complete, aes(x = CS_Q9, y = CS_Wellbeing_happy)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm") +
  labs(title = "Linearity Check: Happiness vs Environmental Attitudes")


# ── 12. Set Reference Groups ──────────────────────────────────────────────────

df_complete$CS_S_Region <- relevel(df_complete$CS_S_Region, ref = "London")
df_complete$Period       <- relevel(df_complete$Period,       ref = "Term time")


# ── 13. Final Regression Model ────────────────────────────────────────────────

model_final <- lm(CS_Wellbeing_happy ~ CS_Q11 + CS_Q9 + CS_S_Region + Period,
                  data = df_complete)

summary(model_final)


# ── 14. Outlier Check (Cook's Distance) ───────────────────────────────────────

plot(model_temp, which = 4)  # Cook's distance

# =============================================================================
# End of script
# =============================================================================
