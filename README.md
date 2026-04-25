# Children's Connection to Nature and Reported Happiness

**Statistical analysis of children's wellbeing and nature connectedness using the Children's People and Nature Survey (C-PaNS)**

This project analyses the association between children's connection to nature and their reported happiness across England, using survey data from Natural England. The analysis applies multiple linear regression to examine whether nature connectedness predicts children's wellbeing after controlling for environmental attitudes, region, and survey period.

---

## 📄 Full Report

**[→ View full report with results and analysis](./Analysis_of_children_s_connection_to_nature_vs_reported_happiness.pdf)**

Includes dataset description, sample design, summary statistics, regression results, diagnostic checks, and full interpretation.

---

## Key Findings

- Children with stronger **connection to nature** report higher happiness — each one-point increase in nature connectedness is associated with a 0.13-point increase in reported happiness (p < 0.001)
- **Pro-environmental attitudes** show an even stronger association — a one-unit increase corresponds to a 0.34-point increase in happiness (p < 0.001)
- Children in the **East of England and South East** report slightly lower happiness than London after controlling for other factors
- Children surveyed during **school holidays** report 0.11-point lower happiness than those surveyed in term-time (p < 0.001)
- The model explains a modest but statistically significant proportion of variation in happiness (adjusted R² = 0.070, F = 82.15, p < 0.001)
- Diagnostic checks confirmed **no influential outliers** (Cook's distances well below 0.5) and **no multicollinearity** (VIF values close to 1)

---

## Data Source

| Dataset | Source | Period |
|---|---|---|
| Children's People and Nature Survey (C-PaNS) | Natural England | 2021–2023 |

- Waves 1–6, collected during both term-time and school holiday periods
- Quota-based sampling via Kantar's Profiles panel, with quotas for age, region, and ethnicity
- Original sample: 12,103 observations → Final analytic sample: **11,796** (complete-case analysis)
- Data available from: [gov.uk/government/collections/people-and-nature-survey](https://www.gov.uk/government/collections/people-and-nature-survey)

---

## Variables

| Variable | Description | Scale |
|---|---|---|
| `CS_Wellbeing_happy` | Reported happiness (outcome) | 0–10 |
| `CS_Q11` | Connection to nature | 1–7 |
| `CS_Q09` | Environmental attitudes | 1–5 |
| `CS_S_Region` | Region of residence (9 categories) | Categorical |
| `Period` | Survey period (term-time vs school holiday) | Binary |

---

## Methods

### Data Preparation
- Complete-case analysis applied — 307 observations removed due to missing data on analytic variables
- Missingness checks indicated data are **Missing Completely At Random (MCAR)** — complete-case approach is appropriate
- Survey design and non-response weights not applied as analysis focuses on estimating associations rather than population estimates

### Statistical Analysis
- **Descriptive statistics** — means, standard deviations, frequency distributions for all variables
- **Multiple linear regression** — predicting happiness from nature connectedness, controlling for environmental attitudes, region, and survey period
- **Diagnostic checks** — Cook's distance for outliers, VIF/GVIF for multicollinearity, linearity plots for continuous predictors
- Reference categories: London (region), Term-time (period)

---

## Repository Structure

```
childrens-wellbeing-analysis/
│
├── analysis.R                                                    # Full R script
├── Analysis_of_children_s_connection_to_nature_vs_reported_happiness.pdf  # Full report
├── README.md
└── LICENSE
```

---

## How to Reproduce

### Requirements
R (≥ 4.1.0) with the following packages:

```r
install.packages(c("tidyverse", "ggplot2", "patchwork", "car"))
```

### Data
Download the C-PaNS open access dataset from:
[gov.uk/government/collections/people-and-nature-survey](https://www.gov.uk/government/collections/people-and-nature-survey)

Save as: `c-pans_waves_1-6_holiday_2021_term_2023_open_access.csv` in your working directory.

### Run
1. Clone this repository
2. Place the CSV data file in your working directory
3. Open and run `analysis.R` in RStudio

---

## Tools & Packages

| Package | Purpose |
|---|---|
| `tidyverse` | Data wrangling, cleaning, and transformation |
| `ggplot2` | Data visualisation and distribution plots |
| `patchwork` | Combining multiple plots into a single figure |
| `car` | VIF multicollinearity diagnostic |

---

## Author

**Samiira Osman Yusuf**
BSc Social Data Science, University College London
[linkedin.com/in/samiira-yusuf-36192b35a](https://linkedin.com/in/samiira-yusuf-36192b35a) | [github.com/Samiira-OY](https://github.com/Samiira-OY)
