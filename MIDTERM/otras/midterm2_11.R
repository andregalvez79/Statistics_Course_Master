regress_1<-read.csv("C:/Users/André/Google Drive/Master/period 2/R/MIDTERM/EAS.csv", sep = ',')
regress_1<-read.csv("C:\\Users\\s4600479\\Desktop\\EAS.csv", sep = ',')
setwd("C:\\Users\\s4600479\\Desktop")
install.packages("psych")
library(psych)
describe(regress_1$SOCIAL, skew = TRUE, ranges = TRUE)
describe(regress_1$ANXIETY, skew = TRUE, ranges = TRUE)
describe(regress_1$DISTRESS, skew = TRUE, ranges = TRUE)
describe(regress_1$FEAR, skew = TRUE, ranges = TRUE)

#NORMAL DISTRIBUTION QUESTION 1 plots and descriptive statistics packages
options (scipen = 12)
install.packages("lattice")
library(lattice)
install.packages("pastecs")
library(pastecs)

#for variable social a density plot and test.
densityplot(regress_1$SOCIAL)
stat.desc(regress_1$SOCIAL, basic=TRUE, desc=TRUE, norm=TRUE, p=0.95)

#for variable anxiety a density plot and test.
densityplot(regress_1$ANXIETY)
stat.desc(regress_1$ANXIETY, basic=TRUE, desc=TRUE, norm=TRUE, p=0.95)

#for variable distress a density plot and test.
densityplot(regress_1$DISTRESS)
stat.desc(regress_1$DISTRESS, basic=TRUE, desc=TRUE, norm=TRUE, p=0.95)

#for variable fear a density plot and test.
densityplot(regress_1$FEAR)
stat.desc(regress_1$FEAR, basic=TRUE, desc=TRUE, norm=TRUE, p=0.95)

#transforming social variable
regress_1$sqr_SOCIAL<-(regress_1$SOCIAL^2)
densityplot(regress_1$sqr_SOCIAL)
stat.desc(regress_1$sqr_SOCIAL, basic=TRUE, desc=TRUE, norm=TRUE, p=0.95)

regress_1$cube_SOCIAL<-(regress_1$SOCIAL^3)
densityplot(regress_1$cube_SOCIAL)
stat.desc(regress_1$cube_SOCIAL, basic=TRUE, desc=TRUE, norm=TRUE, p=0.95)

regress_1$anti_SOCIAL<- exp(regress_1$SOCIAL)
densityplot(regress_1$anti_SOCIAL)
stat.desc(regress_1$anti_SOCIAL, basic=TRUE, desc=TRUE, norm=TRUE, p=0.95)

#QUESTION 2 OUTLIERS
regress_1$ZSOCIAL <- scale(regress_1$SOCIAL, center = TRUE, scale = TRUE)
describe(regress_1$ZSOCIAL)

regress_1$ZSOCIAL2 <- scale(regress_1$sqr_SOCIAL, center = TRUE, scale = TRUE)
describe(regress_1$ZSOCIAL2)

regress_1$ZANXIETY <- scale(regress_1$ANXIETY, center = TRUE, scale = TRUE)
describe(regress_1$ZANXIETY)

regress_1$ZDISTRESS <- scale(regress_1$DISTRESS, center = TRUE, scale = TRUE)
describe(regress_1$ZDISTRESS)

regress_1$ZFEAR <- scale(regress_1$FEAR, center = TRUE, scale = TRUE)
describe(regress_1$ZFEAR)

#question 3-6 correlations.
install.packages("ltm")
library(ltm)
rcor.test(regress_1[,3:6])

#question 7-10
install.packages("lawstat")
library(lawstat)
#first levenes test, the t test, then to report we need to know the sd.
levene.test(regress_1$SOCIAL, regress_1$gender)
ttest_1<-t.test(regress_1$SOCIAL ~ regress_1$gender, paired = FALSE, var.equal = TRUE)
ttest_1
by(regress_1$SOCIAL, regress_1$gender, sd)
by(regress_1$SOCIAL, regress_1$gender, mean)

levene.test(regress_1$ANXIETY, regress_1$gender)
ttest_2<-t.test(regress_1$ANXIETY ~ regress_1$gender, paired = FALSE, var.equal = TRUE )
ttest_2
by(regress_1$ANXIETY, regress_1$gender, sd)
by(regress_1$ANXIETY, regress_1$gender, mean)

levene.test(regress_1$DISTRESS, regress_1$gender)
ttest_3<-t.test(regress_1$DISTRESS ~ regress_1$gender, paired = FALSE, var.equal = TRUE )
ttest_3
by(regress_1$DISTRESS, regress_1$gender, sd)
by(regress_1$DISTRESS, regress_1$gender, mean)

levene.test(regress_1$FEAR, regress_1$gender)
ttest_4<-t.test(regress_1$FEAR ~ regress_1$gender, paired = FALSE, var.equal = TRUE )
ttest_4
by(regress_1$FEAR, regress_1$gender, sd)
by(regress_1$FEAR, regress_1$gender, mean)

#18 scatterplots of all correlations that includes a "fitted" line (e.g., Loess)
plot_1 <- qplot(SOCIAL,  ANXIETY,  data  =	regress_1,	geom=c("point",  "smooth"),	method="loess",  se	=	FALSE, size=I(1.3))
plot_1

plot_2 <- qplot(SOCIAL,  DISTRESS,  data  =  regress_1,	geom=c("point",  "smooth"),	method="loess",  se	=	FALSE, size=I(1.3))
plot_2

plot_3 <- qplot(SOCIAL,  FEAR,  data  =  regress_1,	geom=c("point",  "smooth"),	method="loess",  se	=	FALSE, size=I(1.3))
plot_3

plot_4 <- qplot(ANXIETY,  DISTRESS,  data  =  regress_1,	geom=c("point",  "smooth"),	method="loess",  se	=	FALSE, size=I(1.3))
plot_4

plot_5 <- qplot(ANXIETY,  FEAR,  data  =  regress_1,  geom=c("point",  "smooth"),	method="loess",  se	=	FALSE, size=I(1.3))
plot_5

plot_6 <- qplot(DISTRESS,  FEAR,  data  =  regress_1,  geom=c("point",  "smooth"),  method="loess",  se	=	FALSE, size=I(1.3))
plot_6

#22-25 
#ggplot package for plots
install.packages("ggthemes")
library(ggthemes)
#add id number for reshpae
regress_1$id <-  row.names(regress_1)
#transformation of data to make a variable that categorizes by type of level
regress_long <- reshape(regress_1, idvar="id", varying=c("DISTRESS", "FEAR", "SOCIAL", "ANXIETY"), v.names="levels", timevar='typeslevels', direction="long")
#recode the types of levels by their original names as variables.
regress_long$typeslevels  <-  factor(regress_long$typeslevels,levels=c(1, 2, 3, 4), labels=c("DISTRESS", "FEAR", "SOCIAL", "ANXIETY"))
#do a bar plot that says the level and the type of level by gender in greyscale.
bar_1	<-ggplot(regress_long, aes(typeslevels, levels,	fill=gender))	+	stat_summary(fun.y=mean,	geom="bar",	position='dodge')
bar_1 
bar_1	<-	bar_1 + scale_fill_manual(values = c("grey80", "grey20"))	+ stat_summary(fun.data=mean_cl_normal,	geom="errorbar",	position=position_dodge(width=0.9),	width=.1)	
bar_1

#hierarchichal regression 3 steps fearfulness explained by anxiety and distress by gender.
#centering variables anxiety and distress
regress_1$canxiety <- scale(regress_1$ANXIETY, center = TRUE, scale = FALSE)
regress_1$cdistress <- scale(regress_1$DISTRESS, center = TRUE, scale = FALSE)
step1<-lm(FEAR ~ gender + canxiety + cdistress, data=regress_1)
summary(step1)
step2<-lm(FEAR ~ gender + canxiety + cdistress + gender:canxiety + gender:cdistress + canxiety:cdistress, data=regress_1)
summary(step2)
step3<-lm(FEAR ~ gender + canxiety + cdistress + gender:canxiety + gender:cdistress + canxiety:cdistress + canxiety:cdistress:gender, data=regress_1)
summary(step3)

#WHICH MODEL IS THE BEST?
install.packages("lmSupport", dependencies=TRUE)
install.packages("unmarked", dependencies=TRUE)
library(lmSupport)
anova(step1, step2)
lm.deltaR2(step1, step2)
anova(step2,step3)
modelCompare(step2, step3)
anova(step1, step2, step3)


#STANDARDIZE BETAS
install.packages("QuantPsyc")
library(QuantPsyc)
lm.beta(step3)

#26-29 analytic assumptions.

#residuals normality/outliers
regress_1$resid <- rstandard(step3)
stat.desc(regress_1$resid, basic=TRUE, desc=TRUE, norm=TRUE, p=0.95)
densityplot(regress_1$resid)
#no outliers, not kurtosed and not skewed.
qqline(regress_1$resid)

#independent errors
install.packages("car", dependencies=TRUE)
library(car)
dwt(step3)
#DW statistic near 2 is ok, p-value of .216 confirms there is independence of errors

#multicollinearity
vif(step3)
#there is multicollinearity, VIF higher than 10 for every variable.
1/vif(step3)
#there is multicollinearity, VIF tolerance says that below.1 there is a serious problem.

#linearity
regress_1$fitted <- step3$fitted.values
scatter <- ggplot(regress_1, aes(fitted, resid))
scatter + geom_point() + geom_smooth(method = "lm", colour = "Blue")+ labs(x = "Fitted Values", y = "Standardize Residual")
#the linearity assumption is not violated

#heteroscedasticity
install.packages("gvlma")
library(gvlma)
gvmodel <- gvlma(step3) 
summary(gvmodel)
#it is homoscedastic.

#30 unstandardize formula
summary(step3)

#32-33 falta toda la formula
stat.desc(regress_1$canxiety)
stat.desc(regress_1$cdistress)
cov(regress_1$canxiety, regress_1$cdistress)

#45-48 graph
##effects display
install.packages("ggplot2")
library(ggplot2)
effect1 <- qplot(ANXIETY, FEAR, data = regress_1, geom = c("point","smooth"),	se	=	FALSE,	color	=	gender)
effect1
install.packages("effects")
library(effects)
plot(effect("gender:canxiety", step3, xlevels=2)
plot(effect("cdistress:canxiety", step3, xlevels=4)
