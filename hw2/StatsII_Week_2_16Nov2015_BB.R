# Example R Script for the course "Analyzing in R" (aka Stats II), version 2015
# Week 2
# Bernd Figner

# the FMF book (only in chapter 5, but it's already handy for us now) introduces the package pastecs, in particular the handy command stat.desc() that gives descriptive statistics; so let's try this out. 

# perhaps you first need to install some of the packages that I'm loading below (if you don't have them already)
install.packages("pastecs")
install.packages("reshape")
install.packages("ltm")

# load that library
library(pastecs) # for stat.desc()
library(psych) # for describe() and describeBy()
library(lattice) # for densityplot()
library(ltm) # for rcor.test()
library(reshape) # for melt/cast

# BTW, the developer of the package reshape created a newer package reshape2, with very similar functionality:
# As the developer himself writes, "This version [reshape2] improves speed at the cost of functionality, so I have renamed it to reshape2 to avoid causing problems for existing users."
# see also here: http://stackoverflow.com/questions/12377334/reshape-vs-reshape2-in-r

# Since we are not concerned about speed when reshaping data, we are going to focus on reshape (not reshape2), as it seems a bit easier and user-friendly; and it's also the package that is used in the book.



# set working directory
setwd('~/GoogleDrive/Radboud/Teaching/Stats_II_IntroR/2015_2016/Week02/RScripts')




######################################################################################
# reshaping data frames: wide and long format data

# for the example here, we need some data

# such as: 20 participants, each rates their moood 3 times: baseline measure, then after watching a funny movie clip, and then again after watching a sad movie clip. the mood ratings are done on a continuous visual analogue scale ranging from 0 to 100

# we could either load a file I made or generate some data ourselves, either is fine

# option 1: load a data file that I have created previously
r_0 <- read.csv("Rating_ExampleData.csv") 
head(r_0)
tail(r_0)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# option 2: generate our own example data using a bunch of R commands: this is only for the interested, you can skip this part if you want

# The following lines of code create some 'fake' data; you can ignore that bit, if you prefer
r_1 <- as.data.frame(matrix(data = NA, nrow = 20, ncol = 5)) # you already know that from week 1: we create a matrix filled with NA values and turn that matrix into a data frame

names(r_1) <- c('pp_code', 'f_gender', 'rating_1', 'rating_2', 'rating_3') # now we give the variables some meaningful names

r_1$pp_code <- paste('pp', c(1:20), sep = '_') # I like to use participant codes that are NOT numbers (to make sure I never accidentally treat it as continuous variable)


# for gender, I use the sample() command; it randomly samples elements from a vector that I define
r_1$f_gender <- as.factor(sample(c('male', 'female'), 20, replace = TRUE)) # what this does is that it randomly assigns the gender male to half the participants and the gender female to the other half of the participants

# if you're curious, have a look at:
?sample


# creating some fake data; I assume the rating scale goes from 0 to 100 and I generate some normally distributed data with a mean of 50 and a SD on 20 and round it to integers (i.e., no decimals)
r_1$rating_1 <- round(rnorm(20, mean = 50, sd = 20), digits = 0)

densityplot(r_1$rating_1) # just to check the distribution (since I said the ratings go from 0 to 100, I should make sure that there are no values smaller than 0 or larger than 100)

# I next create a second rating that should be on average higher than the first one (that's what the +20 does in the command below) and is correlated (but not perfectly correlated) with the first measure: that's what the + round(rnorm(20, mean = 0, sd = 3), digits = 0) does; it adds a random number to the previous rating (the random number is drawn from a normal distribution with a mean of 0 and an SD of 3; thus, sometimes the random number will be smaller, sometimes larger than 0)
r_1$rating_2 <- r_1$rating_1 + 20 + round(rnorm(20, mean = 0, sd = 3), digits = 0)

densityplot(r_1$rating_2) # let's check again

# ok, there are some that are above 100, so let's fix that

r_1$rating_2[which(r_1$rating_2 > 100)] <- 100

# and for the third rating, we create a average lower rating (thus, I subtract 30 from the first rating and again do the adding of a random number)
r_1$rating_3 <- r_1$rating_1 - 30 + round(rnorm(20, mean = 0, sd = 3), digits = 0)

densityplot(r_1$rating_3) # let's check

# that generated a few values below 0, so I change these to 0: I identify the entries below 0 using which() and assign the value 0 to these entries
r_1$rating_3[which(r_1$rating_3 < 0)] <- 0

densityplot(r_1$rating_3) # ok, no more values below 0


# save this fake data file
write.csv(r_1, file = 'Rating_ExampleData.csv', row.names = FALSE)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# OK, we have created the fake data, the rest below you are not allowed to ignore anymore





###############################################################################################################################################

# OK, so let's do some things with this data frame (we'll do the change from wide to long format afterwards)
r_1 <- r_0

r_1

# check the correlations among the 3 ratings
# there are many different functions computing correlations
#for example:
?cor()

cor(r_1$rating_1, r_1$rating_2) # that gives us just the correlation coefficient (which is very high), but for example no p values; and it's also not the most convenient command for other reasons. But luckily, there are other commands

# I like the function rcor.test() from the package ltm (but there are other options)

# rcor.test wants as input several columns of data that it will then correlate with each other (e.g., columns with numerical variables such as rating_1, rating_2 etc). What is nice that it accepts more than 2 columns at a time; it will then compute all pairwise correlations and show a correlation matrix as output

# thus, if we want to check the correlation between the columns rating_1 and rating_2, we can do this like this
rcor.test(cbind(r_1$rating_1, r_1$rating_2)) # cbind stands for column-bind. It takes two columns of data (here rating_1 and rating_2) and binds them together

# however, there are more elegant ways to do the same

# like this:
rcor.test(r_1[,c('rating_1', 'rating_2')])

# or like this (this is my preferred way in this case, but to each their own...)
rcor.test(r_1[,3:4])

# if we want to have all pairwise correlations among the 3 rating variables, we again have these different ways how to do it; but I'm using this one here now (least typing...)
rcor.test(r_1[,2:5])

# as you can see, it also computes correlations for the variable gender (which is a factor). As gender has only 2 different values (males/females), this actually makes sense


# there are also ways how to plot scatterplots of pairwise correlations (some simpler, some more sophisticated); a very simple one is pairs():
  pairs(~rating_1 + rating_2 + rating_3, data = r_1) # the ~ often means "as a function of." here, it means make all pairwise scatterplots for rating_1, rating_2, and rating_3
?pairs
# if you are curious, here is an overview stating this plus some fancier ways how to do these kinds of plots:
# http://www.statmethods.net/graphs/scatterplot.html


# some more simple stats: t tests
# we could also do pairwise t tests to check whether the mood manipulations via the video clips were significant; in the case of our example, these would be paired t tests

# testing rating_1 versus rating_2
my1sttest <- t.test(r_1$rating_1, r_1$rating_2, paired = TRUE) # yep, it's significant (not that surprising, given the way I generated these data...)
my1sttest

# the same for rating_1 versus rating_3; this time using the with() command

with(r_1, t.test(rating_1, rating_3, paired = TRUE)) # also significant

# ok, you can compute the t test comparing rating 2 vs. 3 yourself!






# ......................................................................
# OK, that was fun, now back to the serious things: Let's do the change from wide to long format (and afterwards back again)

# RESHAPING THE DATA FRAME: wide versus long format
# our data frame r_1 is in so-called wide format; repeated measures (rating_1, rating_2, rating_3) are separate columns. This is the format you are familiar with also from SPSS

# For many types of analyses in R (and for some analyses even in SPSS, actually), we need the data to be in LONG format; this is also sometimes called "stacked" format, because the repeated measures are 'stacked' on top of each other
# The FMF book covers this in Chapter 3.9.4

# there are different ways how to get from wide to long format and back, ranging from simple (but not very flexible) to complex (but very flexible):
# stack() and unstack() [these commands are in the base package, i.e., available without loading any additional packages, if I am not mistaken]
# cast() and melt() [from the package reshape]
# reshape() [also from the package reshape]
# I typically use reshape(), but the other commands are a bit easier (but not always flexible enough)

# so, let's try the most simple, i.e., stack/unstack first
?stack

r_1_stack <- stack(r_1, select = c('rating_1', 'rating_2', 'rating_3'))

#let's check what we created:
r_1_stack

# the problem here is that we lose the information about which data are from which participant... so that's not handy for our case of repeated measures. It is a fine and simple command, if all one wants to do is indeed to put the variables on top of each other; and vice versa:
r_1_unstack <- unstack(r_1_stack)
r_1_unstack # yep, it's back in wide format, but as one could expect, the information about participants (and gender) is gone forever...





# on to cast/melt then: these commands are in the package reshape, so we need to install and load it first (I do this at the very top of this script!)

?melt # this is an extremely short and not very helpful help file... But, book chapter 3 has good information about this command.
?melt.data.frame # this is a bit longer, but the book does a better job at explaining

r_1_melt <- melt(r_1, id = c('pp_code', 'f_gender'), measured = c('rating_1', 'rating_2', 'rating_3'))

r_1_melt
# that worked very nicely!

# if we wanted, we could change the names of the columns "variable" and "value" but I'm not going to do this here
# so here's the basic syntax for melt:
# under measured =, we tell the function melt which variables form the repeated measures and need to be stacked on top of each other
# under id =, we specify the variables that are not the repeated measures and thus need to be copied several times: i.e., pp_1 and their gender need to be put into the long-format data frame 3 times, once for each of the 3 rating variables


# now let's try to undo that again:
r_1_cast <- cast(r_1_melt)
r_1_cast
# that worked fine as well!

# well, it doesn't always work that easily. for more complicated cases, the syntax can require some more details and specifications of variables
?cast

r_1_cast2 <- cast(r_1_melt, pp_code ~  variable) # left of the ~ is the variable that identified in the molten (=stacked) data frame which observations belong to the same participant; right of the ~ is the variable that identifies the new columns that will be created

r_1_cast2 # yep, looks good, but now we lost the gender information!

# so, if we want to keep the gender information, we do this:
r_1_cast3 <- cast(r_1_melt, pp_code + f_gender ~ variable)

r_1_cast3
# Looks good. So we tell cast() that the variables pp_code and gender are id variables (not repeated measurements) and, after the tilde (~), we specify which variable is the repeated-measures column



r_1_cast
r_1
# just to compare: the only difference between r_1_cast and r_1 seems to be how the rows are ordered:
# in r_1 it's pp_1, pp_2 etc
# in r_1_cast, the data have been sorted alphabetically, i.e., pp_1, pp_10, pp_11 etc
# but the sorting doesn't matter here (BTW: if you need to sort a data frame, you must NOT use the sort() command, as this can have the effect that only one column is sorted in your data frame and the others not, turning your data frame into a mess...)

# see for example here how to order the rows in a data frame: http://stackoverflow.com/questions/1296646/how-to-sort-a-dataframe-by-columns-in-r

# here I sort the rows according to the values in rating_1
r_1_ordered <- r_1[order(r_1[,3]),]

# this command looks more complicated than it is, as it combines several things
# in the middle is this: order(r_1[,3]) --> this says order r_1 according to the 3rd column in r_1
# this is then put into r_1[,] where the row index goes, resulting in the full command:
# r_1[order(r_1[,3]),]

# how should the command look like if you wanted to order the data frame according to the variable rating_3, but in descending order (i.e., highest values first)? HINT: have a look at ?order
# I paste the correct command at the very end of this script






# Ok, but back to reshaping
# now let's use the most complicated (and most flexible) command, reshape()
?reshape # ok, this help file is a bit longer...


r_1_long <- reshape(r_1, idvar = 'pp_code', varying = c('rating_1', 'rating_2', 'rating_3'), timevar = 'rating_1or2or3', v.names = 'rating', direction = 'long')

r_1_long # check: looks good!

# so, how does this function work?
# similar to before, with idvar = , we specify the ID variable. Note that we did not have to specify f_gender here, but it was still included in the new long format data frame
# with varying =, we specify the repeated-measures variables
# with timevar =, we give the name to a new variable that will be created, which tells us from which variable this row of data comes (rating 1, 2, or 3 in our case)
# with v.names =, we can specify the name that our new stacked rating variable should have
# with direction =, we tell the function whether we want to go from wide to LONG format (as we did here); or the other way around from long to WIDE

# If we want to go back from the long to the wide format:
r_1_wide <- reshape(r_1_long, direction = 'wide')

r_1_wide # looks good





# Can we also do a t test in that format?
# Well, first, a t test compares only 2 groups, so we could first get rid of rating_3 entries
head(r_1_long)

# here we create a new data frame that contains only the data from rating 1 and rating 3
r_1_r1r2 <- r_1_long[which(r_1_long$rating_1or2or3 < 3),] # the command which() can be used to select entries that fit a specific criterion. here we use it to select the entries in the variable rating_1or2or3 that are smaller than 3

# let's take one step back:
a <- c(2, 5, 6, 1)
which(a < 3) # gives as answer 1 and 4, i.e., the first and fourth element in a
which(a == 6) # gives as answer 3, i.e., the 3rd element in a
which(a != 6) # gives as answer 1, 2, 4, i.e., everything except the 3rd element
which(a >= 2) # >= means 'larger than or equal to'; gives as answer 1, 2, 3, i.e., the first, second and third element in a
which(a <= 5) # <= means 'smaller than or equal to'; gives as answer 1, 2, 4, i.e., the first, second and foruth element in a

# In the command above: r_1_long[which(r_1_long$rating_1or2or3 < 3),]
# we use which() to pick out only those rows in the data frame r_1_long, for which the value in rating_1or2or3 is 1 or 2 



# let's check whether this did what we wanted:
r_1_r1r2 # looks good

# some more ways to check: the number of columns should be the same as before, but the number of rows should be now 40 instead of 60

ncol(r_1_long) #4
ncol(r_1_r1r2) #4 --> good!

nrow(r_1_long) #60
nrow(r_1_r1r2) #40 --> good!


# ok, so let's do a t test
# if you want to have some short and nice explanations, have a look here:
# http://www.statmethods.net/stats/ttest.html
t.test(r_1_r1r2$rating ~ r_1_r1r2$rating_1or2or3, paired = TRUE)


# so, besides learning more about t tests, we also learned how to select only parts of a data frame. there are many ways how to do this, for example which(), which we already learned about
?which()

# we could also use the original data frame, but use which() to pick out only the data points we want: this is going to look a bit complicated, but I simply use which to specify that only ratings 1 and 2 should be used: which(r_1_long$rating_1or2or3 <= 2)
t.test(r_1_long$rating[which(r_1_long$rating_1or2or3 <= 2)] ~ r_1_long$rating_1or2or3[which(r_1_long$rating_1or2or3 <= 2)], paired = TRUE)


# another command that is very handy to select parts of a data frame is subset()
# so let's try to do the same as we did, but using subset()
?subset

OnlyRatings1_2 <- subset(r_1_long, rating_1or2or3 < 3)
       
# or we could only select rows of data in which the actual rating was exactly or above 80 (i.e., only very hapy-mood data)
Happy <- subset(r_1_long, rating >= 80) # note: >= means "greater or equal"

Unhappy <- subset(r_1_long, rating <= 30) # note: <= means "smaller or equal"


# we can use subset also to select only specific *columns*, we do that with the argument select =
NoRatings <- subset(r_1_long, select = 1:2) # the last bit means select only columns 1 and 2

# we can do the same by using the - before the column number (the -3 means "all except column 3")
NoRatings <- subset(r_1_long, select = -3) # the last bit means select only columns 1 and 2

# and here's yet another way to do the same thing, by explictly naming the variable names
NoRatings <- subset(r_1_long, select = c('pp_code', 'rating_1or2or3')) 


# and we can combine both the row-subsetting and the column-subsetting
OnlyRatings1_2_NoPPCode <- subset(r_1_long, rating_1or2or3 < 3, select = -1) # removing the variable with the participant code is hardly ever a good idea, though...

OnlyRatings1_2_NoPPCode <- subset(r_1_long, select = -1, rating_1or2or3 < 3) # removing the variable with the participant code is hardly ever a good idea, though...






#................................................

# solution sorting of data frame according to values in rating_3 in descending order:
r_1[order(r_1[,5], decreasing = TRUE),]

