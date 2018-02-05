anova_1<-read.csv("C:\\Users\\s4600479\\Desktop\\ANOVA2.csv", sep = ',')
anova_1
options (scipen = 12)
#1 skewe/kurtosed
install.packages("psych")
install.packages("pastecs")
library(psych)
library(pastecs)

by(anova_1$INTEXT, list(anova_1$PSTYLE,anova_1$GENDER), stat.desc, norm = TRUE)

#outliers
anova_1$ZGENDER <- scale(anova_1$GENDER, center = TRUE, scale = TRUE)
describe(anova_1$ZGENDER)
anova_1$ZPSTYLE <- scale(anova_1$PSTYLE, center = TRUE, scale = TRUE)
describe(anova_1$ZPSTYLE)

#2 box plots
install.packages("ggplot2")
install.packages("Hmisc")
library(ggplot2)
library(Hmisc)
anova_1$PSTYLE <- as.factor(anova_1$PSTYLE)
anova_1$GENDER <- as.factor(anova_1$GENDER)
bar1 <- ggplot(anova_1, aes(PSTYLE, INTEXT, fill = GENDER))
bar1 + stat_summary(fun.y = mean, geom = "bar", position="dodge") + stat_summary(fun.data = mean_cl_normal, geom = "errorbar", position=position_dodge(width=0.90), width = 0.2) + facet_wrap(~GENDER) + labs(x = "Parenting Style", y = "Problem Behaviors", fill = "Gender")

#3 statistical assumptions
#heterogeneity of variances
install.packages("car")
library(car)
leveneTest(anova_1$INTEXT, anova_1$PSTYLE)
leveneTest(anova_1$INTEXT, anova_1$GENDER)
leveneTest(anova_1$INTEXT, anova_1$GENDER:anova_1$PSTYLE)

#anova model in lm
anova1<-lm(INTEXT ~ PSTYLE*GENDER, data = anova_1)

#independence of errors
dwt(anova1)
#DW statistic near 2 is ok, p-value of .674 confirms there is independence of errors

#nonnormality
plot(anova1)
anova1$resid <- rstandard(anova1)
stat.desc(anova1$resid, basic=TRUE, desc=TRUE, norm=TRUE, p=0.95)
densityplot(anova1$resid)

#4dummy coding where authoritative is reference, and females for gender
contrasts(anova_1$PSTYLE)

anova_1$PSTYLE <- recode(anova_1$PSTYLE, '11=1;10=3;1=2;0=4')
#recoding variable
anova_1$PSTYLE  <-  factor(anova_1$PSTYLE,levels=c(1, 2, 3, 4), labels=c("authoritative", "authoritarian", "permissive", "indifferent"))

contrasts(anova_1$PSTYLE)

anova_1$GENDER  <-  factor(anova_1$GENDER,levels=c(0, 1), labels=c("Female", "Male"))
contrasts(anova_1$GENDER)

#5 recoding dummy for zero sum.4 is the number of groups
contrasts(anova_1$PSTYLE) <- contr.sum(4)
contrasts(anova_1$PSTYLE)
contrasts(anova_1$GENDER) <- contr.sum(2)
contrasts(anova_1$GENDER)

#6 anova for dummy code
anovadumm<-lm(INTEXT ~ PSTYLE*GENDER, data = anova_1)
summary.lm(anovadumm)
anovasum<- lm(INTEXT ~ PSTYLE*GENDER, data = anova_1)
summary.lm(anovasum)

#7 and 8 are interpretation
#for cross effects example indifferent*male primero agarras el intercept female authoritative, 
#restas authoritative male 1.544, sumas el efecto que quieres saber 3.27 y restas el effecto opuesto .69.

#9 single variable with eight groups for bonferroni
anova_1$groups <- as.factor(paste(anova_1$GENDER, anova_1$PSTYLE, sep = ""))
anova_1$groups
#bonferroni
pairwise.t.test(anova_1$INTEXT, anova_1$groups, p.adjust.method = "bonferroni")
