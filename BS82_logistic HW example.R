

install.packages("foreign") #to import spss file
install.packages("lattice") #for density plots
install.packages("car") #for dwt()

library(foreign)
library(lattice)
library(car)


setwd("C:/Users/U148154/Desktop/RU courses/Analyzing in R 2015")

logex <- read.spss("logreg.sav", to.data.frame = T, use.value.labels = T)
head(logex)

#alternative to use.value.labels
#logex$sex <- factor(logex$sex, levels = c(0:1), labels = c("male", "female"))
#logex$satjob <- factor(logex$satjob, levels = c(0:1), labels = c("satisfied", "not satisfied"))
#logex$life <- factor(logex$life, levels = c(1:3), labels = c("dull", "routine", "exciting"))


#create subset that omits cases with missing values
logex1sub<-subset(logex, satjob != FALSE & life != FALSE, select=c("id", "sex", "satjob", "life"))
head(logex1sub)
nrow(logex1sub)

#inspect contrast settings (default is dummy coding)
contrasts(logex$sex)
contrasts(logex$satjob)
contrasts(logex$life)

#specify effect coding (included as a primer for next week when different coding schemes are described)
#...does not change any values compared to dummy codes (FOR MODEL WITH MAIN EFFECTS ONLY)
#contrasts(logex$sex)<- contr.sum(2)
#contrasts(logex$satjob)<- contr.sum(2)
#contrasts(logex$life)<- contr.sum(3)

#perform binary logistic regression on entire data frame (only to show listwise deletion)
#logmodel <- glm(satjob ~ sex + life, data = logex, family = binomial())
#summary(logmodel)

#perform binary logistic regression on subset
logmodel1 <- glm(satjob ~ sex * life, data = logex1sub, family = binomial())

#test independence of errors
dwt(logmodel1)

#import and examine standardized residuals
logex1sub$standardized.residuals <- rstandard(logmodel1)
densityplot(logex1sub$residuals)

#import and examine DFBetas (influence)
logex1sub$dfbeta <- dfbeta(logmodel1)
densityplot(logex1sub$dfbeta) #does not work for DF betas
hist(logex1sub$dfbeta)

#import and examine hat values (leverage)
logex1sub$leverage <- hatvalues(logmodel1)
densityplot(logex1sub$leverage)

#default plots not very helpful
plot(logmodel1)

#Assess model fit...statistically significant chi-square indicates predictors improve null model
modelChi <- logmodel1$null.deviance - logmodel1$deviance
chidf <- logmodel1$df.null - logmodel1$df.residual
chisq.prob <- 1 - pchisq(modelChi, chidf)
modelChi; chidf; chisq.prob

#Compute R-square...three different pseudo R-squares (Nagelkirke)
R2.hl<-modelChi/logmodel1$null.deviance
R.cs <- 1 - exp ((logmodel1$deviance - logmodel1$null.deviance)/754)
R.n <- R.cs /( 1- ( exp (-(logmodel1$null.deviance/ 754))))
R2.hl; R.cs; R.n


###examine results...finally
summary(logmodel1)

#Compute odds ratio and CIs
exp(logmodel1$coefficients)
exp(confint(logmodel1))

#change reference group of lifestyle
logex1sub$life <- relevel(logex1sub$life, ref = 2)
contrasts(logex1sub$life)
###so routine is now reference group

#perform alternative logistic regression model
logmodel1alt <- glm(satjob ~ sex + life, data = logex1sub, family = binomial())
summary(logmodel1alt)

#change reference group back to dull (this was not done in the lecture slides)
logex1sub$life <- relevel(logex1sub$life, ref = 2)
contrasts(logex1sub$life)

# perform interactive logistic regression model
logmodel2 <- glm(satjob ~ sex * life, data = logex, family = binomial())

###while I do not do it here, the model diagnostics should also be checked for this model
summary(logmodel2)

#Compare two models
anova(logmodel1,logmodel2)


##################################

## Multinomial logistic regression


install.packages("mlogit")
install.packages("car")
library(car)
library(mlogit)

#re-load dataframe (mlogit doesn't like the extra variables added, e.g., residuals)

logex1sub<-subset(logex, satjob != FALSE & life != FALSE, select=c("id", "sex", "satjob", "life"))
head(logex1sub)


mlog1 <-mlogit.data(logex1sub, choice ="life", shape ="wide")
mlog1

str(mlog1)

mlogmodel1<-mlogit(life ~ 1|sex * satjob, data = mlog1, reflevel = 1)
mlogmodel2<-mlogit(life ~ 1|sex * satjob, data = mlog1, reflevel = 2)

#hmm...cannot obtain diagnostics due to long format:(
plot(mlogmodel1)

mlog1$residuals<-rstandard(mlogmodel1)
mlog1$dfbeta<-dfbeta(mlogmodel1)
mlog1$leverage<-hatvalues(mlogmodel1)

densityplot(mlog1$residuals)
hist(mlog1$dfbeta)
densityplot(mlog1$leverage)

#examine results
summary(mlogmodel1)
summary(mlogmodel2)


##################################################

# Chi-square and loglinear models

install.packages("gmodels")
install.packages("MASS")

library(gmodels)
library(MASS)

#demonstrate default settings of CrossTable
CrossTable(logex1sub$satjob, logex1sub$life, chisq = TRUE)

#suppress and add standardized residuals
CrossTable(logex1sub$satjob, logex1sub$life, fisher = TRUE, chisq = TRUE, expected = TRUE, prop.c = FALSE, prop.r = FALSE, prop.t = FALSE, prop.chisq = FALSE,  sresid = TRUE, format = "SPSS")
CrossTable(logex1sub$satjob, logex1sub$life, fisher = TRUE, chisq = TRUE, expected = TRUE, prop.c = FALSE, prop.r = FALSE, prop.t = FALSE, prop.chisq = FALSE,  asresid = TRUE, format = "SPSS")


#relations between 3 categorical variables
table(logex1sub$satjob, logex1sub$life, logex1sub$sex)
xtabs(~sex + satjob + life, data = logex1sub)

#create two subsets based on sex...to examine satjob and life for males and females separately
justmales <- subset(logex1sub, sex == "Male")
justfemales <- subset(logex1sub, sex == "Female")

CrossTable(justmales$satjob, justmales$life, expected=TRUE,asresid = TRUE, prop.t=FALSE, prop.c=FALSE, prop.r = FALSE,prop.chisq=FALSE, format = "SPSS")
CrossTable(justfemales$satjob, justfemales$life, expected=TRUE,asresid = TRUE, prop.t=FALSE, prop.c=FALSE, prop.r = FALSE,prop.chisq=FALSE, format = "SPSS")

#you could also create subsets based on the other measures e.g....
#justdull = subset(logex, life =="dull")
#justroutine = subset(logex, life =="routine")
#justexciting = subset(logex, life =="exciting")

###################

#loglinear analyses

#create contingency tables for analysis
llinx<-xtabs(~ satjob + life + sex, data = logex1sub)
llinx
summary(llinx)

#perform analyses for all combinations of main effects ad interactions
mainonly<-loglm(~ satjob + life + sex, data = llinx, fit = TRUE)

nolifeint<-loglm(~ satjob + life + sex + satjob:sex, data = llinx, fit = TRUE)
nojobint<-loglm(~ satjob + life + sex + life:sex, data = llinx, fit = TRUE)
nosexint<-loglm(~ satjob + life + sex + satjob:life, data = llinx, fit = TRUE)

nosexlife<-loglm(~ satjob + life + sex + satjob:life + satjob:sex, data = llinx, fit = TRUE)
nojobsex<-loglm(~ satjob + life + sex + satjob:life + life:sex, data = llinx, fit = TRUE)
nojoblife<-loglm(~ satjob + life + sex + satjob:sex + life:sex, data = llinx, fit = TRUE)

no3way<-loglm(~ satjob + life + sex + satjob:life + satjob:sex + life:sex, data = llinx, fit = TRUE)

loglin1_sat<-loglm(~ satjob * life * sex, data = llinx, fit = TRUE)

#test models to determine most parsimonious solution...lots to test, just make sure the models are nested

anova (loglin1_sat,no3way)
#ns, so saturated model not better than model without 3-way interaction

anova (no3way, nosexlife)
anova (no3way, nojobsex)
anova (no3way, nojoblife)
#sign. satjob:life improves fit

anova (nosexlife,nosexint)
#ns, satjob:sex does not improve

anova (nojobsex,nosexint)
#ns, life:sex does not improve

anova (nosexlife, nolifeint)
#sign. satjob:life improves fit

anova (nojobsex, nojobint)
#sign. satjob:life improves fit

anova (nojoblife, nolifeint)
anova (nojoblife, nojobint)

#most parsimonious solution...satjob:life + all three main effects


#post-hoc contingency tables (same as above)
table(logex1sub$satjob, logex1sub$life, logex1sub$sex)
xtabs(~sex + satjob + life, data = logex1sub)

#create two subsets based on sex...to examine satjob and life for males and females separately
justmales <- subset(logex1sub, sex == "Male")
justfemales <- subset(logex1sub, sex == "Female")

CrossTable(justmales$satjob, justmales$life, expected=TRUE,asresid = TRUE, prop.t=FALSE, prop.c=FALSE, prop.r = FALSE,prop.chisq=FALSE, format = "SPSS")
CrossTable(justfemales$satjob, justfemales$life, expected=TRUE,asresid = TRUE, prop.t=FALSE, prop.c=FALSE, prop.r = FALSE,prop.chisq=FALSE, format = "SPSS")


#visualize
mosaicplot(loglin1_sat$fit, shade = TRUE, main = "Saturated Model")
mosaicplot(nosexint$fit, shade = TRUE, main = "Expected Values")







