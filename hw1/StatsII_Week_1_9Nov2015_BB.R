# This is an example script to show some R basics
# Created for the Stats II "Analyzing in R" class by Bill Burke and Bernd Figner, Radboud U, fall 2014
# updates: Nov, 2015; Bernd Figner
# Acknowledgment: I used several of the examples by Stephen Ellner and Ben Bolker ("An introduction to R for ecological modeling (lab 1)")



# some explanations: the #-sign (pound sign; haakje in Dutch?) tells R that whatever follows right to it is not code, but just a comment; i.e., R will not try to execute it

# In the course, we are using R; there is also a nice GUI (graphical user interface) for R, called RStudio. All these commands work exactly the same way in R  and in RStudio (RStudio is really nothing more than a pretty surface/environment for R)

# When you start R, you first only see 1 window, the 'Console'
# in the console window the *output* from the commands you run is shown
# you basically always want to type your code *not* into the console window, but in a script
# you create a new 'Editor' document for typing you script into by choosing File --> New Document. This is analogous to creating a new word document in word; as in word, this script document can be saved, edited, emailed etc etc. In contrast, if you type your commands in the console only, they are gone once you shut down R.


# Thus: You could type commands directly in the console panel, but it is virtually always a better idea to type your commands in a script file in this here editor window. The reason is that what is typed here, can be saved in a .R file; so you can later open it again etc

# As an example, type 2+2 in the console window and then hit enter. The console shows you the output of that calculation.

# In contrast, you can run this command below here:
2+2

# On the Mac, you can select/highlight the relevant part of the code and then hit the command and enter keys and that part of the code will be run
# On the PC, you can hit Ctrl and R
# On both Mac and PC, there are other ways how to run commands (see book chapter 3 in Fields, Miles, & Fields)

# I like highlighting the whole section of the command, but you can also just place the cursor on that line, and it will then run the code that is on that line, when you hit Ctrl and R (PC) or command and enter (Mac)

# In most of the cases, you want to do something with the results of your calculations later on, therefore it makes sense to save the result in a variable. Actually, more generally speaking, they are put into an "object" (in this example, 'a' is an object).
# This works like this: (object names can be pretty much anything, with some exceptions)

a <- 2+2

# if you run that command, it seems like nothing happened (because the result, 4, is not shown in the console window)
# importantly, however, something *has* happened, namely, the result of 2+2 has been put into the object a. You can verify that by entering a

a

# as you see, the console window outputs 4

# objects that we create like this are usually vectors, i.e., an ordered list, which can have more than 1 element. Because the value 4 is a number (i.e., numeric), it's a numeric vector.

# Vectors can (and typically have) more than 1 entry. A longer vector can be created like this:

b <- c(1, 5, 3, 6, 8) 

# when we want to check what we just created, we can do simply run the next line of code:
b

# the command c() tells R to combine (the technical term is 'to concatenate') the elements.
# By the way, c() is a command (also called a function); so giving a vector the name c is probably not the best idea; it works, though, but it could perhaps lead to confusion; a and b are fine, because they are not functions.



# very useful is to use ? together with a function, for example

?c # you could also use ?c(), that doesn't matter
help(c)

# as you see, you get a 'help' window in one of the 4 panels, with some explanations of what c() does


# in R you can create plots that range from very simple and not so pretty, to very sophisticated and very pretty. We'll come across both of them in this course. Here's a very simple one:
plot(b)

# There are different ways to save a figure like this. A simple one is to choose 'File --> Save as...' from the R menu. You can then choose one of different formats (pdf or jpg for example) and save it on your hard drive. Then you could add this graph as a jpg file for example to a powerpoint presentation or a word document.


# OK, but back to vectors:

# vectors can also have non-numeric values, e.g.:

d <- c("class", 'stats', 'is', 'a', 'this') # for non-numeric entries, one has to put them in ' or " (i.e., this would work also: c("class", "stats", "is", "a", "this"))

# in all vectors (numeric and non-numeric), the entries have indices, for example:
d[1]
# this command tells R: take object d and pick out the first element: i.e., the [1] tells R to show the first entry in vector d; if you want more than one entry, you can do stuff like:

d[2:4] # i.e., show entries 2 to 4; or you can use the c() function we have seen before to put together several index numbers (one nice thing about c() is that you can put the elements together in any order that you want):

d[c(5, 3, 4, 2, 1)]


# while a vector is kind of a one-dimensional thing, there is also a 2-dimensional version of it, a matrix; this is important, because our data sets (in R typically called "data frames") ususally are in such a matrix form. However, data.frames are more flexible as matrices, because different variables (columns) in a data frame can be different types of variables (such as numerical or categorical etc).

# but before we look at data frames, we first look at matrices quickly, because they can sometimes be handy

# here, I create a 5 x 3 matrix called matrix1 that is filled with all NAs (NA is R's entry for a missing value! this is very important to know!! so remember: NA indicates a missing value in R (probably the NA stands for 'not available'))


matrix1 <- matrix(data = NA, nrow = 5, ncol = 3)

# have a look:
matrix1

# now let's turn this matrix into a data frame (as this is more flexible)

dataframe_1 <- as.data.frame(matrix1)

# In R, we can combine different functions (i.e., commands) into one more flexible command. For example, instead of first creating a matrix in a first command, and then turn it into a dataframe in a second command, we could do it all at once:
dataframe_1 <- as.data.frame(matrix(data = NA, nrow = 5, ncol = 3))

# the result is exactly the same


# so let's have a look what we created
dataframe_1

# it is an object called 'dataframe_1'
# more specifically, it is a data frame (vectors, matrices, data frames etc are all objects)


# as you can see, the data frame has now variable(=column) names (V1, V2, V3); and it shows also row numbers 1 to 5

# with the function names() we can ask R to give us the column names of a data frame
names(dataframe_1)


# if we want to change the column names, we can do that like this (ususally, we want data frames with variable names that make sense)

names(dataframe_1) <- c('pp_code', 'gender', 'age')

# let's check it again
dataframe_1

# ok, so now we have a data frame with nice column names


# if we want to look at only 1 of these columns, we could do this like this (i.e., using the $ sign)
dataframe_1$pp_code

# the $ tells R: take the object dataframe_1 and pick out the column called pp_code

# we can do the same like this:
dataframe_1[,1]

# how so? data frames have rows and columns. The indexing works like this: the first number in the brackets indicates the row number, the second number indicates the column number. If you want, for example, ALL row numbers, you just leave it empty. Thus: [,1] means "all row numbers, first column"
# if we want just the second row and all columns, we would write:
dataframe_1[2,]

# if we want the 3rd row and columns 1 and 3, we would write:
dataframe_1[3, c(1,3)]

# this indexing is really important, so make sure you understand it well!


# now, so far we have an empty data frame (well, full of NA entries), so let's fill it with some values

# first the column with the participant code:
dataframe_1$pp_code <- c('pp1', 'pp2', 'pp3', 'pp4', 'pp5')

# and, you guessed it, we could do the same like this:
dataframe_1[,1] <- c('pp1', 'pp2', 'pp3', 'pp4', 'pp5')

# to fill the rest of the data frame:
dataframe_1$gender <- c('f', 'm', 'f', 'f', 'm')

dataframe_1$age <- c(10, 25, 8, 43, 3)


# a useful command is the str() command; it tells you something about the structure
?str()

str(dataframe_1)

# the 'chr' stands for 'character' which means that this column contains entires that are characters (they are not treated as numbers, but as categorical entries)
# the 'num' indicates numeric values

# usually, for categorical variables such as participant code and gender, we want them to be "factors" (like a categorical variable in SPSS, for example); we can add a new variable to our data frame like this:

dataframe_1$f_pp_code <- as.factor(dataframe_1$pp_code)

# so let's check again the str() command
str(dataframe_1)

# ok, so this new variable is a Factor. This is important for many analysis, that R knows which variable is numerical and which is categorical (i.e., a factor)


# I like to use stuff like f_... in my variable names to remind myself and make it explicit that it is a factor

# chapter 3 in FMF handles factors a bit differently: they first use numeric values and then assign verbal labels to these numeric factor labels; that works very well as well, it's a matter of personal preference, which way you do it (the result is the same)

# now do the same for gender yourself, i.e., turn it into an explicit factor that has a new name...



# So far so good. But usually, we don't want to create our data frames "manually" like this, but we want to read/import them from an existing data file

# let's say we want to import Dan Goldstein's pedometer file

# to load it, I can either give the whole path to where the file is:

dan_data <- read.csv('~/GoogleDrive/Radboud/Teaching/Stats_II_IntroR/2015_2016/Week01/ExampleRScripts/pedometer.csv')
dan_data

#!! You have to adjust this path, obviously, to point to where YOU have that file on your computer!
# You can download that file from here: www.dangoldstein.com/flash/Rtutorial2/pedometer.csv
# then save it on your hard drive, and use a command like mine above, but with the path adjusted so that it corresponds with where on your hard drive you saved the pedometer file

# As alternative, you can first set your working directory to the folder where you have that data set; and then, you can just use the file name. This is handy if you have several data sets in the same folder or if you want to save the work space or other data files in that same folder etc

# The relevant command is setwd()

setwd('~/GoogleDrive/Radboud/Teaching/Stats_II_IntroR/2015_2016/Week01/ExampleRScripts/')
getwd()

dan_data <- read.csv('pedometer.csv')


# By the way, one thing that is cool in R is that you can also use the read.csv command and as path give an URL where the data file is. The command below should work as well (assuming you have an internet connection)
dan_data <- read.csv('http://www.dangoldstein.com/flash/Rtutorial2/pedometer.csv')



# IMPORTANT NOTE: I only encountered that so far in the Netherlands, but sometimes using read.csv doesn't work properly. E.g., when the numbers in the file don't use a decimal POINT (as in 1.5) but a decimal COMMA (as in 1,5). If you encounter that problem, try the command read.csv2 instead of read.csv!

# The reason is that Dutch computer operating systems typically use a decimal *comma*, not a decimal *point*.
# The command read.csv2() was created for these situations.
# If it still doesn't work right, you may have to specify which character separates the entries in the file.


# So, assuming you have set your working directory to the correct folder, you might have to try the following:

# 1. this first version is the standard command that would typically work fine (at least when not using a Dutch operating system...)
dan_data <- read.csv('pedometer.csv', sep = ';') 

#use the following command to check whether the file looks right:
head(dan_data)
tail(dan_data)

# It should look like this:
  Observation Day Steps
1           1 Thu  9178
2           2 Fri   694
3           3 Sat 12503
4           4 Mon  7802
5           5 Tue  7913
6           6 Wed  6135


# but perhaps it looks like this (or somewhat similar)
  Observation.Day.Steps
1            1;Thu;9178
2             2;Fri;694
3           3;Sat;12503
4            4;Mon;7802
5            5;Tue;7913
6            6;Wed;6135

# this means that something went wrong. As you can see, the entries are separated by a ; instead of a ;
# thus, we can try the following command:

dan_data <- read.csv('pedometer.csv', sep = ';') # this command tells R to use read.csv to open the pedometer.csv file and it also tells R that the entries in the file are separated by a semi-colon (;)

# use again head() to check whether it worked now


# if it didn't work, you can also try the read.csv2 command I mentioned earlier, perhaps that works...
dan_data <- read.csv2('pedometer.csv')

# perhaps you have to specify again the character that separates the entries
dan_data <- read.csv('pedometer.csv', sep = ',') # here I specify a comma as separator

dan_data <- read.csv('pedometer.csv', sep = ';') # here I specify a semi-colon as separator

# OK, I hope among all these variants there was something that worked for your case!


# Assuming that one way to read the data worked, let's have a look:

str(dan_data)

# the following are also extremely handy commands that I use A LOT: head(), tail(), nrow(), ncol()
?head()
?tail()
?nrow()
?ncol()

head(dan_data) # this shows the variable names and the first few (6 actually) rows of data

tail(dan_data) # this shows the last few (again 6) rows
# checking the *last few* rows is actually also very important because sometimes when loading data, especially when importing proprietary formats such as .sav (SPSS) or .xls (Excel), the last row might be an empty row of NAs that needs to be removed after importing.

# Thus, after importing, ALWAYS check your imported data VERY carefully. This will save you lots of trouble (if something went wrong during loading and then you try to compute things, it will be much more difficult and labor intensive to identify the problem)

# One of the things that is perhaps at first odd in R is that you don't have a window that shows you the data. In SPSS and Excel, you can see your data in spreadsheet form, in R you cannot. (RStudio has a data viewer window, R doesn't).

# What I do instead, is, I use commands such as head() and tail(), or just have R show me the whole data frame in the console window. Or I open the data frame in Excel or OpenOffice to look through it.


# if we want to look at the distribution of variable the Steps, we could create a histogram:
hist(dan_data$Steps) # the function hist() creates a histogram


# there are lots of options that can be adjusted, i.e., how many categories you want on the x axis, you can assign labels to the x and y axis etc. Have a look using the help command:
help(hist)

# you can also simply use a ? instead of the help() function
?hist


# Actually, I prefer 'densityplots' as I find them nicer than histograms:

densityplot(dan_data$Steps)
library(lattice)
# probably, you got the error message "Error: could not find function "densityplot"
# that's because densityplot is not in the 'base' package; i.e., we have to load the package (or 'library) that contains this function.
# actually, it's in the package 'lattice'
# to download and install that package, there are different options:
# (1) via the RStudio menu (in Mac: Tools --> Install Packages...)
# Install from Repository (CRAN)
# Enter the name of the package: lattice
# make sure to choose 'install dependencies'
# click 'Install'

# (2) Via a command (see also FMF book)
install.packages("lattice")

# Note: you need to have internet access, as packages are downloaded via the web
# you might be asked to choose a location from where to download (you might even be asked twice); you can choose any, it doesn't matter really (but I choose a Dutch location typically)



#Now that you have downloaded and installed it, you can now load that package with this command

library(lattice)

# NOTE: You need to download and install a package only once; but each time you start R, you need to load all the packages that you want to use. Therefore, my R scripts usually have at the very top a bunch of lines loading all the packages that I typically need when working with R.

# now, this should work:
densityplot(dan_data$Steps) # hmm, there seems to be one outlier data point...

# while you're at it:
# also install and load the packages psych
# it is quite handy for things that psychologists often need (e.g., the functions describe() and describeBy())

# for example, get some descriptive statistics for the variable Steps
describe(dan_data$Steps)

# the describe() function can also be used for a whole data frame; it then gives descriptive statistics for all the variables that are in the data frame
describe(dan_data)

# note that Day is shown with an asterisk, i.e., Day*
# This is related to the fact that Day is a categorical variable; i.e., Day doesn't have a mean. However, a mean is given in the output of describe. So let's have a look at the help file of describe
?describe

# Here's the relevant bit from the help:
#Although describe will work on data frames as well as matrices, it is important to realize that for data frames, descriptive statistics will be reported only for those variables where this makes sense (i.e., not for alphanumeric data). If the check option is TRUE, variables that are categorical or logical are converted to numeric and then described. These variables are marked with an * in the row name. This is somewhat slower.
# So: The categorical variable Day is converted to numeric and then described. Typically what R does in these cases is that it assigns numbers to the factor levels, either using the order in which they appear in the data frame, or alphabetical order. Note: Converting Days (Monday, Tuesday, ...) into numeric values this way does *not* make sense here!


# just for the fun of it, let's do a linear regression with these data; this is just to give you a brief outlook; we will cover linear regressions in more detail later in the course

# here, we try to predict the Number of steps as a function of the variable Observation, which is just ranging from 1 to 88 indicating each consecutive day when he observed himself. I.e., with this model, we are testing whether his number of steps significantly increased or decreased during the observation period

linreg_1 <- lm(Steps~Observation, data = dan_data)
summary(linreg_1) # this gives a more detailed output of the analysis: It's a significant positive effect

# if you want to plot it, we could do something simple like this
plot(dan_data$Steps, dan_data$Observation)

# or, with the y and x axis switched, like this:
plot(dan_data$Observation, dan_data$Steps)
# this plot is not very pretty, but it's good enough for now; we look at how to create prettier graphs later


# if you want to see the descriptive means per day in the week (i.e., Monday, Tuesday, ...), we can use the function describeBy (in the package psych)


describeBy(dan_data$Steps, dan_data$Day, mat=TRUE)

# as you can see, the table is ordered alphabetically, which is not really that handy; one way to change that is to create a version of the variable Day that is not a factor, but an "ordered factor":

dan_data$o_Day <- ordered(dan_data$Day, levels = c('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'))
dan_data$o_Day
# now if we use that variable...
describeBy(dan_data$Steps, dan_data$o_Day, mat=TRUE)

# Please note, in statistical analysis such as linear regressions (and mixed models), factors and "ordered factors" are not always treated in the same way, so beware of that! We'll look into these things later; for now, just keep in mind that this is the case.


# Ok, I think this is enough for now. Two last things, though:

# (1) Saving the new data frame (with the new variable o_Day that we created):
write.csv(dan_data, file = 'pedometer_version2.csv') # this will save the file in the working directory

#If we want to save it somewhere else, we can specify the whole path where it should be saved, for example:
  write.csv(dan_data, file = '~/GoogleDrive/Radboud/Teaching/Stats_II_IntroR/2015_2016/Week01/ExampleRScripts/pedometer_version2.csv') 


# (2) Often, it is very handy to save the "workspace," which contains all the variables etc. This is particularly important if you did a lot of preprocessing or computed a lot of models that took a long time to run (more on this in the mixed-models class...). The next time when you work on the same analyses/data again, you don't have to re-run all the things in the script, but you can just load the workspace.
# For results of analyses, however, make sure that you save the results in an object (otherwise, the stuff you're interested might not be saved).
# For example if you have just lm(Steps~Observation, data = dan_data) in your script, the result will not be saved.
# However, if you have linreg_1 <- lm(Steps~Observation, data = dan_data) in your script, the results will be saved (in the object linreg_1).

# Save your current work space (again, you will have to choose a path that works for you!)
save.image('~/GoogleDrive/Radboud/Teaching/Stats_II_IntroR/2015_2016/Week01/WorkSpace_Week1.RData')

#if you want to load that work space later then:
load('~/GoogleDrive/Radboud/Teaching/Stats_II_IntroR/2015_2016/Week01/WorkSpace_Week1.RData')

# Note, ususally, I put this saving/loading at the very top of my scripts, so that I see it right when I open such a script.


# Thus, my scripts usually start like this (this is a bit silly, since this is the end of a script, but imagine it's the start of a script)


#............................................................................................
# This script was written to do this and that (some explanations what this script is for)
# created: November 9, 2013
# updates:
# on November 10, 2013: added bits on write.csv [etc...]
# on November 7, 2014: adjusted for new iteration of the course; added more detail about different ways of using read.csv and read.csv2, added describe() [etc etc]
# on November 7, 2015: adjusted again for new iteration of the course

# 1. clear out old stuff
detach()

# 2. load packages that I ususally need (we don't need all of them here; this is just an example; if you're curious, you can find out what they are good for)
# library(foreign) # not needed here
# library(gdata) # not needed here
library(psych)
# library(ltm) # not needed here
# library(car) # not needed here
# library(lme4) # not needed here



# 3. Set contrasts to sum-to-zero [we'll get to that later...]
options(contrasts=c("contr.sum","contr.poly"))


# 4. save and/or load workspaces

save.image('xxxxxxx.RData') # well, obviously you want different paths than xxxx...

load('xxxxxx.RData')


# and then the rest of the script....

b <- 2+2
