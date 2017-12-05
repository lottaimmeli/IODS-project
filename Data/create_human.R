#25.11.2017
#Lotta Immeli

#Read the “Human development” and “Gender inequality” datas into R. 

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")


#studying the dimensions and structure of the datasets. Also looking the summaries.

dim(hd)
str(hd)

dim(gii)
str(gii)


summary(hd)
summary(gii)


# Look at the meta files and rename the variables with (shorter) descriptive names. (1 point)

colnames(hd)
colnames(gii)
library(stringr)
library(dplyr)


#Renaming the long names into shorter descriptive names

hd <- hd %>% as_data_frame %>% rename(Edu.Exp= Expected.Years.of.Education, HDI =  Human.Development.Index..HDI., Life.Exp = Life.Expectancy.at.Birth, Edu.Years=Mean.Years.of.Education, GNI=Gross.National.Income..GNI..per.Capita, GNI_HDI = GNI.per.Capita.Rank.Minus.HDI.Rank)

gii <- gii %>% as_data_frame %>% rename(GII = Gender.Inequality.Index..GII., Ado.Birth = Adolescent.Birth.Rate, Edu2F= Population.with.Secondary.Education..Female., Edu2M = Population.with.Secondary.Education..Male., LaboF= Labour.Force.Participation.Rate..Female., LaboM= Labour.Force.Participation.Rate..Male., Mat.Mor = Maternal.Mortality.Ratio, Rep.Per = Percent.Representation.in.Parliament)


#Mutate the “Gender inequality” data and create two new variables. 
#The first one should be the ratio of Female and Male populations with secondary education 
#in each country. (i.e. edu2F / edu2M). 
#The second new variable should be the ratio of labour force participation of
#females and males in each country (i.e. labF / labM). 


gii <- mutate(gii, Edu.Ratio = Edu2F/Edu2M, Labo.Ratio = LaboF/LaboM)
gii

#Join together the two datasets using the variable Country as the identifier.

human <- inner_join(gii, hd, by="Country")
dim(human)

#The joined data has 195 observations and 19 variables as it should

#saving the data in my folder and testing that I did it correctly

write.csv(human, file = "human.csv", eol= "\r", na = "NA", row.names = FALSE)

test10 <- read.csv("human.csv", header = TRUE, sep = ",")
dim(test10)
str(test10)
View(test10)

#Continuing with the data wrangling in next week 30.11.2017

#Mutate the data: transform the Gross National Income (GNI) variable to numeric 

str(human)
GNI_new <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric
GNI_new

human <- mutate(human, GNI=GNI_new)
human
str(human)

#Exclude unneeded variables: 
#keep only the columns matching the following variable names. I have renamed some of the variables
#little bit differently so here are the explanations.
#(described in the meta file above):  
#"Country", "Edu2.FM" = "Edu.Ratio", "Labo.FM"="Labo.Ratio", "Edu.Exp", "Life.Exp", "GNI", 
#"Mat.Mor", "Ado.Birth", "Parli.F"="Rep.per"

keep <- c("Country", "Edu.Ratio", "Labo.Ratio", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Rep.Per")

human <- select(human, one_of(keep))
str(human)

complete.cases(human)

#Remove all rows with missing values

# print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = complete.cases(human))

# filter out all rows with NA values
human_ <- filter(human, complete.cases(human))
human_



#Remove the observations which relate to regions instead of countries.

head(human_)
tail(human_, 10)

# I can see that the last 7 observations relate to regions..

# define the last indice we want to keep
last <- nrow(human_) - 7
human2 <- human_[1:last, ]

human2
tail(human2)

#Define the row names of the data by the country names and 
#remove the country name column from the data. 

# add countries as rownames. There were some problems but when setting the data as data frame it
#started to work out
library(tibble)

rownames(human2) <- human2$Country
human2
human2<- as.data.frame(human2)
human2

human3 <- select(human2, -Country)
human3


#The data should now have 155 observations and 8 variables. 
dim(human3)

#That is correct.

#Save the human data in your data folder including the row names. I overwrited the 
#old ‘human’ data.


human<- human3
human

write.csv(human, file = "human.csv", eol= "\r", na = "NA", row.names = TRUE)

testi <- read.table(file="human.csv", header = TRUE, row.names=1, sep = ",")
dim(testi)
str(testi)
View(testi)










