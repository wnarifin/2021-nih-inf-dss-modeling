# 02-km

# KM one group

# analysis

# library
library(survival)
library(coin)  # for glioma data
library(TH.data)
library(survminer)
library(broom)
library(gtsummary)

# data
?aml  # about the dataset
acute = aml
str(acute)

# explore
tbl_summary(acute)
table(acute$status)  # number of events

# KM
sur_aml = survfit(Surv(time, status) ~ 1, data = acute)
sur_aml  # median survival time = 27 (95%CI: 18, 45)
summary(sur_aml)  # note the `survival`` column, the survival probability
ggsurvplot(sur_aml, conf.int = F)

# KM for groups

# data
?glioma  # about the dataset
gli = glioma
str(gli)
gli4 = subset(gli, histology == "GBM")  # grade 4 glioma
str(gli4)

# explore
tbl_summary(gli4)

# KM
sur_gli4 = survfit(Surv(time, event) ~ group, data = gli4)
sur_gli4  # median survival times/group, 0.95UCL cannot be estimated
summary(sur_gli4)
ggsurvplot(sur_gli4)

# Log-rank test
survdiff(Surv(time, event) ~ group, data = gli4)
surv_pvalue(sur_gli4)
