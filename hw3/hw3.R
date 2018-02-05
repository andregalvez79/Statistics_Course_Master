install.packages('ggplot2')
library(ggplot2)
install.packages("psych")
library(psych)
summary(mpg)
str(mpg)

#plots
# boxplot 1: city mileage for each car manufacturer 
qplot(manufacturer, cty,	data=mpg,	geom="boxplot")
# boxplot 2: hway milage for each car manufacturer
qplot(manufacturer, hwy,  data=mpg,	geom="boxplot")

#Describe what you see in the boxplots.
#there are some outliers for some of the manufacturers,and some manufacturers have 
#small sample that is not very well distributed. 


# 2 sample
mpgsmall <- droplevels(subset(mpg, manufacturer == "volkswagen" | manufacturer == "ford" | manufacturer == "honda" | manufacturer == "toyota"))


# 3 distribution plots
#distributions for city mileage for each of the manufacturer in mpgsmall with differently colored density plots.
qplot(cty,  data=mpgsmall,	geom="density",	color=manufacturer)
qplot(cty,  data=mpgsmall,	facets=.~manufacturer,	geom="histogram",	binwidth=1.5,	xlim=c(11,35))

#Discuss which plot is clearer and allows you to draw conclusions more easily.!
#this plot is clearer because you can see how the manufacturer cars are grouped around the city mileage, you could look at the efficiency in this plot.

#4 scatter plot 
#relation between city and highway mileage in the mpgsmall dataset...different symbol for each class of car.

qplot(cty,  hwy,	data	=	mpgsmall,	shape	=	manufacturer)

#Discuss what you see.
#in this plot you can see that there is a positive correlation between the highway and the city mileage by manufacturer.
#you can also see the distribution of efficieny by manufacturer and how they are distributed in mileagee.

#5 better plot
plot_1 <- qplot(cty,  hwy,  data	=	mpgsmall, color=manufacturer,	geom=c("point",  "smooth"),	method="lm",  se	=	FALSE, size=I(1.3))

#6 bar chart showing the mean highway mileage for each class, different colors for the various classes.
install.packages("Hmisc")
bar_1	<-	ggplot(mpgsmall,	aes(class, hwy,	fill=class))	+	stat_summary(fun.y=mean,	geom="bar",	position='dodge')
bar_1
#7 error bars 
bar_1	<-	bar_1	+	stat_summary(fun.data=mean_cl_normal,	geom="errorbar",	position=position_dodge(width=0.9),	width=.1)	
bar_1

#8 color theme from ggthemes
install.packages("ggthemes")
library(ggthemes)
bar_1 <- bar_1 + ggtitle("Mean Highway Mileage by Car Class") + theme_economist() + scale_colour_stata()
bar_1 <- bar_1 + theme_stata() + scale_color_stata() + scale_fill_stata() + ggtitle("Mean Highway Mileage by Car Class") + theme(text = element_text(size=20),axis.text.x = element_text(angle=360, vjust=1)) 
bar_1

#9 city mileage bar next to each highway mileage bar
#recoding
mpgsmall$id <-  row.names(mpgsmall)
mpgsmall_long <- reshape(mpgsmall, idvar="id", varying=c("hwy", "cty"), v.names="mileage", timevar='mileagetype', direction="long")
#plot	
bar_2 <- 0
mpgsmall_long$mileagetype  <-	factor(mpgsmall_long$mileagetype,	levels=c(1, 2), labels=c("Highway","City"))
bar_2	<- ggplot(mpgsmall_long,	aes(class,	mileage,	fill=mileagetype)) +	stat_summary(fun.y=mean,	geom="bar",	position='dodge')
bar_2	<-	bar_2	+	stat_summary(fun.data=mean_cl_normal,	geom="errorbar",	position=position_dodge(width=0.9),	width=.1)	
bar_2

#10 really cool visualization from the mpg dataset.
install.packages("lubridate")
library(lubridate)	#	for	function	year()
nuts_1	<-	ggplot(mpgsmall_long,	aes(cyl,	mileage, color=class))	+	stat_summary(fun.y	=	mean,	geom	=	"path", size=I(1.3))
nuts_1
