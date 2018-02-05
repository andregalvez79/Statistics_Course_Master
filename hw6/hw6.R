manova_1<-read.csv("C:\\Users\\s4600479\\Desktop\\MANOVA_R(2).csv", sep = ',')
install.packages("pastecs")
library(pastecs)
install.packages("lattice")
library(lattice)
options (scipen = 12)

#1 skeweness
stat.desc(manova_1$ESTEEM, basic=TRUE, desc=TRUE, norm=TRUE)
densityplot(manova_1$ESTEEM)
stat.desc(manova_1$CONTROL, basic=TRUE, desc=TRUE, norm=TRUE)
densityplot(manova_1$CONTROL)
stat.desc(manova_1$NEUROTIC, basic=TRUE, desc=TRUE, norm=TRUE)
densityplot(manova_1$NEUROTIC)

# note stargaze for citations

#transformations
manova_1$log_ESTEEM<-log(manova_1$ESTEEM+1)
manova_1$sqrt_ESTEEM<-sqrt(manova_1$ESTEEM+1)
manova_1$ovr_ESTEEM<-(1/(manova_1$ESTEEM+1))

manova_1$log_CONTROL<-log(manova_1$CONTROL+1)
manova_1$sqrt_CONTROL<-sqrt(manova_1$CONTROL+1)
manova_1$ovr_CONTROL<-(1/(manova_1$CONTROL+1))

manova_1$log_NEUROTIC<-log(manova_1$NEUROTIC+1)
manova_1$sqrt_NEUROTIC<-sqrt(manova_1$NEUROTIC+1)
manova_1$ovr_NEUROTIC<-(1/(manova_1$NEUROTIC+1))

stat.desc(manova_1, basic=FALSE, desc=FALSE, norm=TRUE)


#2. outliers
install.packages("psych")
library(psych)
manova_1$ZESTEEM <- scale(manova_1$ESTEEM, center = TRUE, scale = TRUE)
describe(manova_1$ZESTEEM)
manova_1$ZCONTROL <- scale(manova_1$CONTROL, center = TRUE, scale = TRUE)
describe(manova_1$ZCONTROL)
manova_1$ZNEUROTIC <- scale(manova_1$NEUROTIC, center = TRUE, scale = TRUE)
describe(manova_1$ZNEUROTIC)

#outlier in ESTEEM, how many?2
#which rows?32, 208
nrow(subset(manova_1, abs(scale(ESTEEM)) >3))
subset(manova_1, abs(scale(ESTEEM)) >3)


#3. correlations

install.packages("ltm")
library(ltm)
rcor.test(manova_1[,5:7])

#perform manova... for type 3 ss and plots
install.packages("car")
library(car)
install.packages("ggplot2")
library(ggplot2)
#note for multivariate outliers and normality
install.packages("mvoutlier")
install.packages("mvnormtest")
library(mvnormtest)
library(mvoutlier)
#note for descri[tives and DFA]
install.packages("pastecs")
install.packages("MASS")
library(pastecs)
library(MASS)

#4 homogeneity of variance
manova_1$PSTYLEF <- factor(manova_1$PSTYLE, levels=c(1, 2, 3, 4), labels=c("authoritative", "authoritarian", "permissive", "indifferent"))
leveneTest(manova_1$ESTEEM ~ manova_1$PSTYLEF)
leveneTest(manova_1$CONTROL ~ manova_1$PSTYLEF)
leveneTest(manova_1$NEUROTIC ~ manova_1$PSTYLEF)

#5 homogeneity of variance-covariance matrices
#first transpose matrix for the IV... for each level 
pstylet1<-t(subset(manova_1[,5:7], manova_1$PSTYLEF == 1))
pstylet2<-t(subset(manova_1[,5:7], manova_1$PSTYLEF == 2))
pstylet3<-t(subset(manova_1[,5:7], manova_1$PSTYLEF == 3))
pstylet4<-t(subset(manova_1[,5:7], manova_1$PSTYLEF == 4))
#then perfrom a test... mshapiro
mshapiro.test(pstylet1)
mshapiro.test(pstylet2)
mshapiro.test(pstylet3)
mshapiro.test(pstylet4)
#also look at the matrix
by(manova_1[, 5:7], manova_1$PSTYLEF, cov)
#.6 do a manova
#first cbind
manova_1$outcome <- cbind(manova_1$ESTEEM, manova_1$CONTROL, manova_1$NEUROTIC)
model<- manova(outcome ~ PSTYLEF, data= manova_1)
summary(model, intercept=TRUE, test="Wilks")

#7. pairwise t tests.

pairwise.t.test(manova_1$ESTEEM, manova_1$PSTYLEF, p.adjust.method = "bonferroni")
by(manova_1$ESTEEM, manova_1$PSTYLEF, mean)
pairwise.t.test(manova_1$CONTROL, manova_1$PSTYLEF, p.adjust.method = "bonferroni")
pairwise.t.test(manova_1$NEUROTIC, manova_1$PSTYLEF, p.adjust.method = "bonferroni")

#8 visula diagnsotics of multivariate outliers.
aq.plot(manova_1[, 5:7])

#9 DFA
model2<-lda(PSTYLE ~ ESTEEM + CONTROL + NEUROTIC, data = manova_1)
model2
#10 plot dfa
plot(model2)
