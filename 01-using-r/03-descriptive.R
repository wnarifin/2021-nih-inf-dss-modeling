# Title: Using R for medical research ====

# Part 3: Descriptive statistics ====

## data ====
library(foreign)
library(dplyr)  # to use %>%, select()
data = read.spss("cholest.sav", to.data.frame = TRUE)

## summary() ====
summary(data)

## describe() [psych package] ====
# - for numerical variables
library(psych)
data %>% select(chol:exercise) %>% describe()

## desc_cat() [desc_cat_fun.R, custom function] ====
# - for categorical variable
source("https://raw.githubusercontent.com/wnarifin/medicalstats-in-R/master/functions/desc_cat_fun.R")
data %>% select(sex, categ) %>% desc_cat()

## tbl_summary [gtsummary package] ====
library(gtsummary)
tbl_summary(data)
tbl_summary(data, statistic = all_continuous() ~ "{mean} ({sd})",
            digits = all_continuous() ~ 1)
tbl_summary(data,
            by = sex,
            statistic = all_continuous() ~ "{mean} ({sd})",
            digits = all_continuous() ~ 1)
tbl_summary(data,
            by = categ,
            statistic = all_continuous() ~ "{mean} ({sd})",
            digits = all_continuous() ~ 1)

# Others ====
# can explore dplyr, janitor, rstatix packages
# https://healthdata.usm.my:3939/mva/data-wrangling.html#group-data-and-get-summary-statistics
# https://epirhandbook.com/en/descriptive-tables.html#descriptive-tables
# https://epirhandbook.com/en/simple-statistical-tests.html#rstatix-package
