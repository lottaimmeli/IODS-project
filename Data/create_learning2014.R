#Lotta Immeli, 13.11.2017, Rstudio exercise 2, Data wrangling


#read the data learning2014, containing header and separator is a tab (huomaa kauttaviivan suunta!) 

data_url <- "http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt"

learning2014 <- read.table(data_url, header = TRUE, sep ="\t")

# different ways to quickly browse through the data. Contains 183 observations of 60 variables

View(learning2014)
colnames(learning2014)
str(learning2014)
dim(learning2014)
head(learning2014)

install.packages('tidyverse')
installed.packages('dplyr')

library(tidyverse)
library(dplyr)

# Create an analysis dataset, but how to make the Deep, Stra and Surf didn??t manage!

#First combining questions defining deep, strategic and surface learning

deep_questions <- c("D03","D11","D19","D27","D07","D14","D22","D30","D06","D15","D23","D31")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
surface_questions <- c("SU02","SU10","SU18","SU26","SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")

#Then selecting the deep, stra and surf columns, calculating the mean value of the points and making a new column to the learning dataset

deep_columns <- select(learning2014, one_of(deep_questions))
learning2014$deep <- rowMeans(deep_columns)

strategic_columns <- select(learning2014, one_of(strategic_questions))
learning2014$stra <- rowMeans(strategic_columns)

surface_columns <- select(learning2014, one_of(surface_questions))
learning2014$surf <- rowMeans(surface_columns)

#Selecting the columns

keep_columns <- c("gender", "Age", "Attitude", "Points", "deep", "stra", "surf")

lrn2014 <- select(learning2014, one_of(keep_columns))

#Filtering to exclude the points = 0
learning <- filter(lrn2014, Points>0)

#checking that I got the data asked(166 observations and 7 variables). Correct.
dim(learning)
colnames(learning)


install.packages('readr')
library(readr)

# Write csv and test that it will work

write.csv(learning, file="learning2014.csv", eol= "\r", na = "NA", row.names = FALSE)

testing <- read.csv("learning2014.csv", header = TRUE, sep= ",")
str(testing)
head(testing)
View(testing)
