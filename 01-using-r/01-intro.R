# Title: Using R for medical research ====

# Part 1: Introduction to R & RStudio ====

## Installation ====

# - R @ https://cran.r-project.org/
# - RStudio @ http://www.rstudio.com/
# - Web-based RStudio @ https://rstudio.cloud/

## RStudio Interface ====

# 1. Script
# 2. Console
# 3. Environment & History
# 4. Files & others

## R Script ====

## New Script
# File > New File > R Script

## Object
# - name assigned on left side of "<-" / "="
# - variable, data (data frame, matrix, list)
x <- 1
y = 2
z = x + y
z  # type object name, you'll get the value

## Save R Script
# - in a chosen directory/location

## New R Project ====
# - systematic way to work with R
# File > New Project > New Directory > New Project  # start new
# File > New Project > Existing Directory  # for existing folder

## Working Directory ====
# - by default, opening .Rproject file will automatically set the project folder as working directory
# - at times, make sure working in the right folder
# Panel > Files tab > More > Set As Working Directory / Go to Working Directory

## Functions and Packages ====

## Function
# - function(), think of MS Excel function
# - structure:
# function(argument1 = value, argument2 = value)
mean(x = 1:10)  # mean of numbers from 1 to 10
mean(1:10)

## Packages / Libraries
# - a collection of functions
# - install car, psych from Panel > Packages tab
# - load installed libraries
library(car)
library(psych)

## Help!!! ====
# ? if we know the name of the function
?psych
?library
# ?? if we know what the function does, search help database
??mean
# - most of the time, not helpful for new users, Google is better
