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
