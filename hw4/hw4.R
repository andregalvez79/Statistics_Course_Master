anova_1<-read.csv("C:\\Users\\s4600479\\Desktop\\ANOVA_R(2).csv", sep = ',')
anova_1<-read.csv("C:/Users/André/Google Drive/Master/period 2/R/hw4/ANOVA_R(2).csv", sep = ',')
#creating levels for the variable
anova_1$parstyle <- anova_1$RESPONSE*10 + anova_1$DEMAND
#rearranging the variablies for reference
anova_1$parstyle[which(anova_1$parstyle == 11)] <- 2
anova_1$parstyle[which(anova_1$parstyle == 10)] <- 3
anova_1$parstyle[which(anova_1$parstyle == 1)] <- 4
anova_1$parstyle[which(anova_1$parstyle == 0)] <- 5
#recoding variable
anova_1$parstyle  <-  factor(anova_1$parstyle,levels=c(2, 3, 4, 5), labels=c("authoritative", "permissive", "authoritarian", "indifferent"))

#question 2 anova assumptions

install.packages("car")# for Levene's and D-W tests
install.packages("pastecs")#for descriptives
install.packages("multcomp") #for Tukey comparisons
install.packages("compute.es") #for effect sizes


#Initiate packages
library(car)
library(pastecs)
library(multcomp)
library(compute.es)
library(lattice)

#Levene's test first Y then groups
leveneTest(anova_1$INTEXT, anova_1$parstyle)

#Examine distributions of DV within groups
by(anova_1$INTEXT, anova_1$parstyle, densityplot)
by(anova_1$INTEXT, anova_1$parstyle, hist)

#5 contrast for hypothesis a
contrasts(anova_1$parstyle)
#dummycoded by default... the zero sum for other contrast
contrasts(anova_1$parstyle)<- contr.sum(3)

#performing ANOVA(or regression)
modelstyle_anova<-aov(INTEXT ~ parstyle, data = anova_1)
modelstyle_lm<-lm(INTEXT ~ parstyle, data = anova_1)

#add diagnostic variables to dataframe
anova_1$residuals<-rstandard(modelstyle_lm)
anova_1$ZINTEXT <- scale(anova_1$INTEXT, center = TRUE, scale = TRUE)
describe(anova_1$ZINTEXT)
anova_1$dfbeta<-dfbeta(modelstyle_lm)
anova_1$leverage<-hatvalues(modelstyle_lm)

#examine diagnostic plots separately for each group
by(anova_1$residuals, anova_1$parstyle, densityplot)
by(anova_1$dfbeta, anova_1$parstyle, hist) #cant plot this
by(anova_1$leverage, anova_1$parstyle, densityplot)

plot(modelstyle_lm)

#examine results of analyses (ANOVA output)
summary(modelstyle_lm)
by(anova_1$INTEXT, anova_1$parstyle, stat.desc, norm=TRUE)  
summary.aov(modelstyle_lm)
#examine results of analyses (regression output)
summary(modelstyle_anova)
summary.lm(modelstyle_anova)

#6 type 2 sums of squares
modelstyle_type2 <- Anova(modelstyle_lm, type="II")
#or
modelstyle_type2 <- Anova(lm(INTEXT ~ parstyle, data = anova_1), type="II")
modelstyle_type2

#6 type 3 sums of squares
modelstyle_type3 <- Anova(modelstyle_lm, type="III")
#or
modelstyle_type3 <- Anova(lm(INTEXT ~ parstyle, data = anova_1), type="III")
modelstyle_type3

#note: we cannot tell how much they differ from each other and how, that-s why we need a post-hoc analysis like Tukey or bonferroni.

#Tukey post hoc
Tukey<-glht(modelstyle_lm, linfct = mcp(parstyle = "Tukey"))
summary(Tukey)
confint(Tukey)
#to get the means and sd's.
by(anova_1$INTEXT, anova_1$parstyle, stat.desc, norm=TRUE) 

#Bonferroni post hoc
pairwise.t.test(anova_1$INTEXT, anova_1$parstyle, p.adjust.method = "bonferroni")

#ANCOVA

install.packages("effects")
install.packages("ggplot2")
install.packages("reshape")


#Initiate packages
library(effects)
library(ggplot2)
library(reshape)


scatter <- ggplot(anova_1, aes(ATTROLE, parstyle))
scatter + geom_point(size = 3) + geom_smooth(method = "lm", alpha = 0.1) + labs(x = "attitude", y = "Parenting style")

#Levene's Test
leveneTest(anova_1$INTEXT, anova_1$parstyle)
leveneTest(anova_1$ATTROLE, anova_1$parstyle)

#Test whether the IV and covariate are independent
checkIndependenceModel<-aov(ATTROLE ~ parstyle, data = anova_1)
summary(checkIndependenceModel)
summary.lm(checkIndependenceModel)
#there is dependence, the covariate explains variance that the independent variable does, so we should drop the covariate.


#the relationship between the outcome (dependent variable) and covariate
#differs across the groups then the overall regression model is inaccurate
#model to test homogeneity of regression it does not violate because interaction terms are all positive and non significant (dont know if significance matters)<- this is wrong it violates
model_2<-lm(INTEXT~ATTROLE*parstyle,data=anova_1)
summary(model_2)

#visualize VIOLATION of homogeneity of regression 
scatter <- ggplot(anova_1, aes(ATTROLE, INTEXT, colour = parstyle))
scatter + geom_point(aes(shape = parstyle), size = 3) + geom_smooth(method = "lm", aes(fill = parstyle), alpha = 0.1) + labs(x = "attention", y = "internalizing")

#9 ancova model

model_3<-aov(INTEXT~ ATTROLE + parstyle, data = anova_1)
summary(model_3)

model_4<-aov(INTEXT~ parstyle + ATTROLE, data = anova_1)
summary(model_4)
#notice that the SS attributed to each effect differs in models 2a and 2b 

Anova(model_3, type = "2")

Anova(model_3, type = "3")
