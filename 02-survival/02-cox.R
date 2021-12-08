# 03-cox

# analysis

# library
library(survival)
library(TH.data)
library(survminer)
library(broom)
library(gtsummary)

# data
?lung  # about the dataset
lca = na.omit(lung)  # omit subjects with missing data
str(lca)
table(lca$status)  # status: 1=censored, 2=dead
lca$status = lca$status - 1  # turn to our usual 0/1
lca$sex = factor(lca$sex, levels = 1:2, labels = c("male", "female"))
table(lca$ph.ecog)  # only one obs. = 3, set to 2
lca[lca$ph.ecog == 3, ]$ph.ecog = 2
lca$ph.ecog = factor(lca$ph.ecog)
str(lca$ph.ecog)

# explore
tbl_summary(lca,
            statistic = all_continuous() ~ "{mean} ({sd})",
            digits = all_continuous() ~ 1)
table(lca$status)  # number of events

# univariable
cox_lca0 = coxph(Surv(time, status) ~ 1, data = lca)  # empty model
summary(cox_lca0)  # remember, no intercept in Cox PH, so there's nothing here
names(lca)
cat(names(lca), sep = " + ")  # makes our life easier to copy all the var names
# for current analysis, we are not using `ph.karno` and `pat.carno`
add1(cox_lca0, scope = ~ age + sex + ph.ecog + meal.cal + wt.loss,
     test = "Chisq")  # LR test
# since `meal.cal` and `wt.loss`'s P-values < 0.25, we skip these variables
# from multivariable model

# multivariable model
# we include the selected variables into our multivariable model
cox_lca1 = coxph(Surv(time, status) ~ age + sex + ph.ecog, data = lca)
summary(cox_lca1)
# focus on the sig. of the included vars
# `age` not sig.
# the results also give the HRs i.e. `exp(coef)`
# `likelihood ratio test`, i.e. LR test of the present model vs empty model.

# remove age
cox_lca = coxph(Surv(time, status) ~ sex + ph.ecog, data = lca)
summary(cox_lca)

# multicollinearity, MC
cox_lca
# there's no large SE for all the vars

# # interaction, *
add1(cox_lca, scope = ~ . + sex * ph.ecog, test = "Chisq")
# insig. *

# Proportional hazards assumption ====

# Test for constant coefficients over time
ph_test_lca = cox.zph(cox_lca, terms = FALSE)  # pg.ecog2 hazard not proportionate
ph_test_lca
# global test of constant coefficient over time not sig. -- proportionate

# Plot of coefficient over time with Schoenfeld residuals
ggcoxzph(ph_test_lca)
# the points scattered fairly equally above and below the estimated coefficient
# lines over time. The points jumping above and below maybe because of
# categorical predictors, may look better if we have numerical predictors

# KM curve plot
# sex
sur_lca_sex = survfit(Surv(time, status) ~ sex, data = lca)
ggsurvplot(sur_lca_sex)  # clearly parallel lines = proportionate hazards
# ph.ecog
sur_lca_ph.ecog = survfit(Surv(time, status) ~ ph.ecog, data = lca)
ggsurvplot(sur_lca_ph.ecog)  # ph.ecog = 2 looks less parallel to the other two

# Log-minus-log plot
ggsurvplot(sur_lca_sex, fun = "cloglog")
ggsurvplot(sur_lca_ph.ecog, fun = "cloglog")

# Cumulative hazard, H(t) plot
ggsurvplot(sur_lca_sex, fun = "cumhaz")
ggsurvplot(sur_lca_ph.ecog, fun = "cumhaz")

# Interpretation ====

# Text summary
cox_lca_final = cox_lca
summary(cox_lca_final)  # details
tidy(cox_lca_final, exponentiate = T, conf.int = T)  # text friendly, easy to export to Excel
tbl_regression(cox_lca_final, exponentiate = T)  # nicer table
# Female has lower hazard with HR = 0.60 (40% lower) than male, controlling for other predictors.
# Ecog score 1 has higher hazard with HR = 1.38 (38% higher) than ECOG score 0, controlling for other predictors.
# Ecog score 2 has higher hazard with HR = 2.55 (155% higher) than ECOG score 0, controlling for other predictors.

# Forest plot
ggforest(cox_lca_final, data = lca)

# Adjusted survival curve from Cox PH model
ggadjustedcurves(cox_lca_final, data = lca, variable = "sex")
ggadjustedcurves(cox_lca_final, data = lca, variable = "ph.ecog")

# Model equation ====
tidy(cox_lca_final)
# log(h(t) / h0(t)) = -0.51 * sex (female) + 0.32 * ph.ecog (= 1) + 0.94 * ph.ecog (= 2)

# Prediction ====

# each data points
lca$hr = predict(cox_lca_final, type = "risk")  # hazards ratio for each subject
# relative to baseline subject, i.e. sex = "male", ph.ecog = "0"
head(lca)

# for each combinations
new_data = data.frame(sex = c("male", "male", "male", "female", "female", "female"),
                      ph.ecog = c("0", "1", "2", "0", "1", "2"))
new_data
new_hr = predict(cox_lca_final, new_data, type = "risk")
data.frame(new_data, hr = round(new_hr, 3))

# Median survival times and survival probabilities
# - http://www.drizopoulos.com/courses/emc/ep03_%20survival%20analysis%20in%20r%20companion
# - using `new_data` above
new_cox = survfit(cox_lca_final, newdata = new_data)  # get survival data from Cox PH model
cbind(new_data, surv_median(new_cox))  # median survival times
summary(new_cox, times = c(100, 200, 300))  # survival probability at 100, 200 and 300 days

