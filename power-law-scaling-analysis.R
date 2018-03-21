#---
#title: "Power Law Scaling Proposal vs Alternate Linear Models in MSAs"
#author: "Alex Haase"
#output:
#  word_document: default
#  pdf_document: default
#  html_document: default
#---
#Overview
#Required Libraries

require(boot)
library(MASS)
library(ggplot2)

rm(list=ls()) # clear global environment
getwd() # double check wd

msadata = read.csv("http://dept.stat.lsa.umich.edu/~bbh/s485/data/gmp-2006.csv", TRUE, ",")
class(msadata) #create msa dataframe

#msadata objects
msaName = msadata$MSA #MSA name (metropolitan statistical areas)
pcgmp = msadata$pcgmp #per-capita GMP
pop = msadata$pop #population
finance = msadata$finance
prof.tech = msadata$prof.tech
ict = msadata$ict
management = msadata$management

#Conceptual Preliminaries and Initial Hypothesis

#primary fields: MSA name, pcgmp, pop
#comparison variables: prof.tech, information, ict, management

#I agree with the competing theory to the supra-linear power
#law scaling proposition. It seems more reasonable that 
#moving alone is not the only factor to attribute to economic
#productivity; it can also be attributed to current financial
#establishments and concentrations, along with information,
#communication, and technology.


#Explanatory Analysis and GMP equation

#per-capita_GMP = GMP/N, therefore: GMP = pop * per-capita_GMP
gmp = pop * as.double(pcgmp)
#gmp[1] #testing
#gmp[2] #testing


#Summarizing the proportions of data by variable and handling Missing data


#first ommitting each case with an "NA" present per each variable

omit_finance = na.omit(finance)
omit_prof.tech = na.omit(prof.tech)
omit_itc = na.omit(ict)
omit_management = na.omit(management)

financeMean = mean(omit_finance)
#financeMean

prof.TechMean = mean(omit_prof.tech)
#prof.TechMean

itcMean = mean(omit_itc)
#itcMean

managementMean = mean(omit_management)
#managementMean

#removing entire rows with "NA" present in the dataset
#str(msadata)
#complete.cases(msadata) #return boolean for rows with NA

clean_msadata = msadata[complete.cases(msadata), ] #no NA's
#str(clean_msadata)
#clean_msadata


#Scatterplots via ggplot with smoothing

#GMP vs Pop 
gmp_vs_pop_Plot = ggplot(msadata, aes(x=pop, y=gmp)) + 
  geom_point(shape=18, color="blue") +
  geom_smooth(method=lm, se=FALSE, linetype="dashed", color="darkred")
gmp_vs_pop_Plot

#log GMP vs Pop
log_GMP_vs_pop_Plot = ggplot(msadata, aes(x=pop, y=log(gmp))) + 
  geom_point(shape=18, color="blue") +
  geom_smooth(method=lm, se=FALSE, linetype="dashed", color="darkred")
log_GMP_vs_pop_Plot

#log GMP vs log Pop
log_GMP_vs_log_pop_Plot = ggplot(msadata, aes(x=log(pop), y=log(gmp))) + 
  geom_point(shape=18, color="blue") +
  geom_smooth(method=lm, se=FALSE, linetype="dashed", color="darkred")
log_GMP_vs_log_pop_Plot

#Notes: the log of both variables (GMP and pop) seems to be best choice for visual representation
#of the data. The other two plots heavily clusters the data on the lefthand side of the plot.
#log provides a much more expansive view of the data, resulting in a cleaner visual image.

#log(GMP) vs. secondary variables

#gmp vs finance
log_GMP_vs_finance = ggplot(msadata, aes(x=finance, y=log(gmp))) + 
  geom_point(shape=18, color="blue") +
  geom_smooth(method=lm, se=FALSE, linetype="dashed", color="darkred")
log_GMP_vs_finance

#gmp vs prof.tech
log_GMP_vs_prof.tech = ggplot(msadata, aes(x=prof.tech, y=log(gmp))) + 
  geom_point(shape=18, color="blue") +
  geom_smooth(method=lm, se=FALSE, linetype="dashed", color="darkred")
log_GMP_vs_prof.tech

#gmp vs ict
log_GMP_vs_ict = ggplot(msadata, aes(x=ict, y=log(gmp))) + 
  geom_point(shape=18, color="blue") +
  geom_smooth(method=lm, se=FALSE, linetype="dashed", color="darkred")
log_GMP_vs_ict

#gmp vs management
log_GMP_vs_management = ggplot(msadata, aes(x=management, y=log(gmp))) + 
  geom_point(shape=18, color="blue") +
  geom_smooth(method=lm, se=FALSE, linetype="dashed", color="darkred")
log_GMP_vs_management


#Fitting The Power Law Model

#Using lm to linearly regress log(GMP) and log(pcgmp) on the log of the population size

lm_GMP_pop = lm(log(gmp)~log(pop), data=msadata)
summary(lm_GMP_pop)

lm_pcgmp_pop = lm(log(pcgmp)~log(pop), data=msadata)
summary(lm_pcgmp_pop)

#Generate residual plots to scrutinize the credibility of the normal, homoskedastic errors version of the regression model

plot(lm_GMP_pop)
plot(lm_pcgmp_pop)


#Squared error loss on the log scale

fit_loggmp_logpop = lm(log(gmp) ~ log(pop), data = msadata)
loss1 = mean(resid(fit_loggmp_logpop)^2)
loss1

fit_loggmp_ict= lm(log(gmp) ~ ict, data = msadata)
loss2 = mean(resid(fit_loggmp_ict)^2)
loss2

fit.loggmp_finance = lm(log(gmp) ~ finance, data = msadata)
loss3 = mean(resid(fit.loggmp_finance)^2)
loss3

#5-fold cross-validation
#First applying a generalized linear model to the dataset, 
#and see how the cross-validated error estimate changes 
#with each degree polynomial.

glm.fit = glm(pcgmp~pop, data=msadata)
degree=1:5
cv.error5=rep(0,5)
for(d in degree){
  glm.fit = glm(pcgmp~poly(pop, d), data=msadata)
  cv.error5[d] = cv.glm(msadata,glm.fit,K=5)$delta[1]
}

plot(cv.error5, data = msadata, main = "CV Generalization Error 5-fold",
     xlab = "degree", ylab = "cv.error5")

#Fitting and assessment of alternate models

#Fit the alternative models and eval using SEL and 5-fold CV

pcgmp_finance = merge(pcgmp, finance, by=0)
#pcgmp_finance
omit_pcgmp_finance = na.omit(pcgmp_finance)
#omit_pcgmp_finance

pcgmp1 = omit_pcgmp_finance$x
#pcgmpg1

finance1 = omit_pcgmp_finance$y
#finance1

altM_pcgmp_finance = glm(log(pcgmp1)~finance1, data=omit_pcgmp_finance)
degree=1:5
cv.error5a=rep(0,5)
for(d in degree){
  altM_pcgmp_finance = glm(pcgmp1~poly(finance1, d), data=omit_pcgmp_finance)
  cv.error5a[d] = cv.glm(omit_pcgmp_finance,altM_pcgmp_finance,K=5)$delta[1]
}
plot(cv.error5a, data = omit_pcgmp_finance, main = "CV Gen. Error (log_pcgmp and finance) 5-fold",
     xlab = "degree", ylab = "cv.error5")


pcgmp_ict = merge(pcgmp, ict, by=0)
#pcgmp_finance
omit_pcgmp_ict = na.omit(pcgmp_ict)
#omit_pcgmp_finance

pcgmp2 = omit_pcgmp_ict$x
#pcgmpg1

ict1 = omit_pcgmp_ict$y
#finance1

altM_pcgmp_ict = glm(log(pcgmp2)~ict1, data=omit_pcgmp_ict)
degree=1:5
cv.error5b=rep(0,5)
for(d in degree){
  altM_pcgmp_ict = glm(pcgmp2~poly(ict1, d), data=omit_pcgmp_ict)
  cv.error5b[d] = cv.glm(omit_pcgmp_ict,altM_pcgmp_ict,K=5)$delta[1]
}
plot(cv.error5b, data = omit_pcgmp_ict, main = "CV Gen. Error (log_pcgmp and ict) 5-fold",
     xlab = "degree", ylab = "cv.error5")


#Standard error loss of the above two models:

fit_pcgmp_finance = lm(log(pcgmp1) ~ finance1, data = omit_pcgmp_finance)
loss_pcg_finance = mean(resid(fit_loggmp_logpop)^2)
loss_pcg_finance

fit_pcgmp_ict = lm(log(pcgmp2) ~ ict1, data = omit_pcgmp_ict)
loss_pcg_ict = mean(resid(fit_pcgmp_ict)^2)
loss_pcg_ict


#Additional Hypothesis Test on Holdout data

holdout = read.csv("http://dept.stat.lsa.umich.edu/~bbh/s485/data/gmp-2006-holdout.csv", TRUE, ",")

#holdout objects
msaName = holdout$MSA #MSA name (metropolitan statistical areas)
pcgmp_h = holdout$pcgmp #per-capita GMP
pop_h = holdout$pop #population
finance_h = holdout$finance
prof.tech_h = holdout$prof.tech
ict_h = holdout$ict
management_h = holdout$management
gmp_h = pop_h * as.double(pcgmp_h)

anova1 = aov(log(gmp_h)~log(pop_h))
anova1$coefficients
summary(anova1)

anova2 = aov(log(gmp_h)~ict_h)
anova2$coefficients
summary(anova2)

anova3 = aov(log(gmp_h)~finance_h)
anova3$coefficients
summary(anova3)







