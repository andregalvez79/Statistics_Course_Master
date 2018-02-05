regress_1<-read.csv("C:/Users/André/Google Drive/Master/period 2/R/MIDTERM/EAS.csv", sep = ',')
setwd("C:\\Users\\s4600479\\Desktop")
install.packages("psych")
library(psych)
describe(regress_1$SOCIAL, skew = TRUE, ranges = TRUE)
describe(regress_1$ANXIETY, skew = TRUE, ranges = TRUE)
describe(regress_1$DISTRESS, skew = TRUE, ranges = TRUE)
describe(regress_1$FEAR, skew = TRUE, ranges = TRUE)

#NORMAL DISTRIBUTION QUESTION 1 plots and descriptive statistics packages
options (scipen = 10)
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