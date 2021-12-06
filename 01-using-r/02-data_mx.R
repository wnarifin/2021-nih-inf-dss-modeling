# Title: Using R for medical research ====

# Part 2: Data Management ====

## Read Data ====

## Built in data sets
data()
AirPassengers
ChickWeight
sleep
?sleep

## Reading data sets
# We have these files:
# - cholest.csv
# - cholest.sav
# - cholest.dta
# - cholest.xlsx
# Always make sure that you set the working directory first!
data.csv = read.csv("cholest.csv")  # most natural way to open data in R

library(foreign)  # library to read .sav (SPSS) and .dta (STATA) files
data.sav = read.spss("cholest.sav", to.data.frame = TRUE)  #SPSS
data.dta = read.dta("cholest.dta")  # STATA

library(readxl)  # library to read excel files, must install first
data.xls = read_excel("cholest.xlsx", sheet = 1)

data.web = read.csv("https://wnarifin.github.io/data/sbp.csv")

## Display data ====

## Basics
str(data.sav)  # Basic info
dim(data.sav)  # Dimension (row/case column/variable)
names(data.sav)  # Variable names

## View data
head(data.sav)  # View data, first 6 rows
tail(data.sav)  # View data, last 6 rows
data.sav  # View all
View(data.sav)  # View, graphical way

## Data structure ====

## The basic variable types
str(data.sav)
# - num = numerical
# - factor = categorical
# - basically a variable in R is a VECTOR
data_num = c(1,2,3,4,5)
str(data_num)

data_cat = factor( c("M", "F", "M", "F", "M") )
str(data_cat)

# - others, e.g. time-series, date etc.

## The basic containers
# - Data frame
str(data.sav)
data.frame(data_num, data_cat)
data_frame = data.frame(data_num, data_cat)
str(data_frame)

# - List
list(data_num, data_cat)
data_list = list(data_num, data_cat)
str(data_list)

# - Matrix
matrix(data = c(data_num, data_cat), nrow = 5, ncol = 2)
data_matrix = matrix(data = c(data_num, data_cat), nrow = 5, ncol = 2)
data_matrix
str(data_matrix)  # shown as num

# - others e.g. tibble

## Subsetting ====
# - select part of data for analysis
data = read.spss("cholest.sav", to.data.frame = TRUE)
str(data)

### using $ ====
# variable / column
data$age

### using [row , column] ====
# variable / column
data[ , 2]
data[ , "age"]

# observation / row
data[7, ]

# row and column
data[73, 2]
data[73, "age"]

# columns
data[ , c("chol", "age", "sex")]
data[ , c(1:2, 4)]
data[ , c(1, 2, 4)]

# rows
data[7:14, ]

# rows and columns
data[7:14, c(2, 4)]
data[7:14, c("chol", "age")]
data[c(1:2, 7:14), c(2, 4)]
data[c(1:2, 7:14), c("chol", "age")]

# exclude columns and rows
data[ , -2]
data[-c(1:35, 40:75), ]
data[-c(1:35, 40:75), -c(1:2, 4)]

### using subset() ====

# - may use logical expressions
# 1. Equal ==
# 2. More than or equal >=
# 3. Less than or equal <=
# 4. More than >
# 5. Less than <
# 6. Not equal !=
subset(data, age > 45)
subset(data, sex == "female")
subset(data, select = c(chol, age, sex))
subset(data, select = chol:sex)
subset(data, age >= 45, select = c(age, sex))
subset(data, age >= 45, select = -c(age, sex))  # exclude age & sex

# - additional logical expressions
# 7. AND &
# 8. OR |
subset(data, age <= 35 & sex == "female", select = c(age, sex))
subset(data, age <= 35 | sex == "female", select = c(age, sex))

# assign selected data part for easier analysis
data_short = data[1:10, c("age", "sex")]
data_short
str(data_short)

### using dplyr ====
# - commonly used along with tidyverse
# - used together with %>% pipe operation
# 1. filter(), also check ?filter for variations
# 2. select()
# 3. slice() family, also check ?slice()
library(dplyr)
data %>% filter(age <= 35)
data %>% select(age, sex)
data %>% slice(1:10)

# select observations 20:30, age < 35 & sex == female, variables age, sex
data %>% select(age, sex) %>%
  filter(age <= 35 & sex == "female") %>%
  slice(1:10)
data_shorter = data %>% select(age, sex) %>%
  filter(age <= 35 & sex == "female") %>%
  slice(1:10)
data_shorter

## Sorting data ====
# - using arrange() from dplyr
# arrange(data, variable1, variable2, ...)
arrange(data, age)
arrange(data, desc(age))
arrange(data, sex, desc(age))
# may also use %>% style

## Transforming data ====

### Create new variable ====
# using $
data$age_month = data$age * 12
head(data)
# using mutate()
data = data %>% mutate(age_month1 = age * 12)
head(data)

### Recode numerical to categorical ====

## binary
data$exercise_cat = ifelse(data$exercise >= 4, "active", "sedentary")
str(data)  # as chr
data$exercise_cat = as.factor(data$exercise_cat)  # convert to factor
str(data)  # as factor
levels(data$exercise_cat)
table(data$exercise_cat)

## > 2 categories
data$age_cat = cut(data$age, breaks = c(-Inf, 40, 50, Inf),
                   labels = c("<= 40", "> 40 - 50", "> 50"))
levels(data$age_cat)
table(data$age_cat)

## by mutate()
# - mutate() creates new variables
library(forcats)
data = data %>% mutate(exercise_cat1 = as_factor(ifelse(exercise >= 4, "active", "sedentary")),
                       age_cat1 = cut(age, breaks = c(-Inf, 40, 50, Inf),
                                      labels = c("<= 40", "> 40 - 50", "> 50")))
str(data)
levels(data$exercise_cat1)
levels(data$age_cat1)
data %>% select(exercise_cat1, age_cat1) %>% summary()

# combine categories
data$age_cat2 = fct_collapse(data$age_cat,
                             "more than 40" = c("> 40 - 50", "> 50"))
levels(data$age_cat2)
table(data$age_cat2)  # combined
