regress_hw2<-read.csv("U:\\Documents\\R\\REGRESS.csv", sep = ';')
regress_hw2a<-regress_hw2 [1:465,]
install.packages("psych")
install.packages("ltm")
#to run correlations an plot them
library(ltm)
rcor.test(regress_hw2a[,2:5])
pairs(~ regress_hw2a$timedrs + regress_hw2a$phyheal + regress_hw2a$menheal + regress_hw2a$stress)
#creating database
pcode<-c(1,2,3,4,5,6,7,8,9,10)
names(pcode)<-c('p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 'p8', 'p9', 'p10')
gender<-c(1,0,1,1,0,0,0,1,1,1)
score1<-c(60,65,80,72,74,69,62,63,64,71)
score2<-c(time1+1*code/2)
score3<-c(time2**2)
id <- c('1':'10')
gender<-factor(gender, levels = c(0,1), labels = c("male", "female"))
wide_1<-data.frame(id, gender, score1, score2, score3)
rcor.test(wide_1[,2:5])
#t test
#como es dummy, no es la misma distribucion, por eso false, aparte el~ dice que score 1 es una funcion de gender.
#para el otro las dos son continuas so, true... solo checas como score 1 es diferente de socre 2.
options (scipen = 10) #option to show the scienytific notation.

ttest_1<-t.test(wide_1$score1 ~ wide_1$gender, paired = FALSE)
ttest_2<-t.test(wide_1$score2 ~ wide_1$gender, paired = FALSE)
ttest_3<-t.test(wide_1$score3 ~ wide_1$gender, paired = FALSE)
ttest_4<-t.test(wide_1$score1, wide_1$score2, paired = TRUE)
ttest_5<-t.test(wide_1$score1, wide_1$score3, paired = TRUE)
ttest_6<-t.test(wide_1$score3, wide_1$score2, paired = TRUE)

install.packages("reshape")
library(reshape)
wide_1$part<-c('p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 'p8', 'p9', 'p10')
?melt
long_1 <- melt(wide_1, id = C('gender', 'id'), measured=c('score1','score2','score3'))
str(wide_1)

long_2<-reshape(wide_1, idvar='id', varying = c('score1', 'score2', 'score3'), timevar = 'score#', direction = 'long')
write.csv(regress_2, file = "C:\\Users\\s4600479\\Desktop\\hw2.csv")
