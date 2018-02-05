/*creating variables*/
metallica
install.packages("DSUR")
library(DSUR)
metallicaNames<-c("Lars","James","Kirk","Rob")
metallicaAges<-c(47, 47, 48, 46)

/*creating data frames of variables*/
metallica<-data.frame(Name = metallicaNames, Age = metallicaAges)
metallica

/*looking at variables within data frames*/
metallica$Age
metallica$Name

/*creating variables within data frames*/
metallica$childAge<-c(12, 12, 4, 6)
metallica
names(metallica)

/*creating variables in a data frames with data frames data*/
metallica$fatherhoodAgetrial<- metallica$Age - metallica$childAge
metallica

name<-c("Ben", "Martin", "Andy", "Paul", "Graham", "Carina", "Karina", "Doug", "Mark", "Zoe")
name

/*creating date variables*/
husband<-c("1973-06-21", "1970-07-16", "1949-10-08", "1969-05-24")
wife<-c("1984-11-12", "1973-08-02", "1948-11-11", "1983-07-23")
agegap <- husband-wife
agepag
husband<-as.Date(c("1973-06-21", "1970-07-16", "1949-10-08", "1969-05-24"))
wife<-as.Date(c("1984-11-12", "1973-08-02", "1948-11-11", "1983-07-23"))
agegap <- husband-wife
agegap

/*coding variables*/
job<-c(1,1,1,1,1,2,2,2,2,2)
job<-c(rep(1, 5),rep(2, 5))
job<-factor(job, levels = c(1:2), labels = c("Lecturer", "Student"))
*/or*/
job<-gl(2, 5, labels = c("Lecturer", "Student"))
levels(job)

/*to rename and convert*/
levels(job)<-c("Medical Lecturer", "Medical Student")
job
levels(job)
levels(job)<-c(1, 2)

/*self test*/
birth_date<-as.Date(c("1977-07-03", "1969-05-24", "1973-06-21", "1970-07-16", "1949-10-10", "1983-11-05", "1987-10-08", "1989-09-16", "1973-05-20", "1984-11-12"))
friends<-c(5,2,0,4,1,10,12,15,12,17)
alcohol<-c(10,15,20,5,30,25,20,16,17,18)
income<-c(20000,40000,35000,22000,50000,5000,100,3000,10000,10)
neurotic<-c(10,17,14,13,21,7,13,9,14,13)
lecturerData<-data.frame(name,birth_date,job,friends,alcohol,income, neurotic)
lecturerData

/*ignore missing values*/
neurotic<-c(10,17,NA,13,21,7,13,9,14,NA)
mean(neurotic, na.rm = TRUE)

/*to import from spss .sav files*/
install.packages("foreign")
library(foreign)
lecturerData<-read.spss("Lecturer Data.sav",use.value.labels=TRUE, to.data. frame=TRUE)

/*to convert numbers in data from spss to dates*/
lecturerData$birth_date<-as.Date(as.POSIXct(lecturerData$birth_date, origin="1582-10-14"))

/*order levels in variable job*/
job<-factor(job, levels = levels(job)[c(2, 1, 3)])

/*to save on.txt*/
write.table(metallica, "capitulo3.txt", sep="\t", row.names = FALSE)

/*to generate data frames form other data frames... reduced data*/
lecturerPersonality <- lecturerData[, c("friends", "alcohol", "neurotic")]
lecturerPersonality
lecturerOnly <- lecturerData[job=="Lecturer",]

/*condiciones de variables*/
alcoholPersonality <- lecturerData[alcohol > 10, c("friends", "alcohol", "neurotic")]
/*or*/
alcoholPersonality <- subset(lecturerData, alcohol > 10, select = c("friends", "alcohol","neurotic"))

/*los data frames se conviertene em matrixes para usarlos mejor*/
newMatrix <- as.matrix(dataframe)
alcoholPersonalityMatrix <- as.matrix(alcoholPersonality)
alcoholPersonalityMatrix <- as.matrix(lecturerData[alcohol > 10, c("friends", "alcohol", "neurotic")])

