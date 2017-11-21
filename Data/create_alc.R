# Lotta Immeli 
# 16.11.2017  Rstudio exercise 3
#https://archive.ics.uci.edu/ml/datasets/Student+Performance
#This data approach student achievement in secondary education of two Portuguese schools. The data attributes include student grades, demographic, social and school related features) and it was collected by using school reports and questionnaires. 
#Two datasets are provided regarding the performance in two distinct subjects: Mathematics (mat) and Portuguese language (por). 

#Reading the two datasets and exploring the dimensions and structure. 
#Student mat has 395 observations and 33 variables, student por has 649 observations and 33 variables

student_por <- read.csv("~lottaimmeli/Documents/GitHub/IODS-project/Data/student-por.csv", header=TRUE, sep = ";")
View(student_por)
dim(student_por)
str(student_por)

student_mat <- read.csv("~lottaimmeli/Documents/GitHub/IODS-project/Data/student-mat.csv", header=TRUE, sep = ";")
View(student_mat)
dim(student_mat)
str(student_mat)

# Join the two data sets using the given variables as (student) identifiers. 
# Keep only the students present in both data sets. Explore the structure and dimensions of the joined data.

join <- c("school", "sex", "age","address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")
join
matpor<- inner_join(student_mat, student_por, by = join, suffix=c(".mat", ".por"))
colnames(matpor)
dim(matpor)

#Now I have a data with 382 observations and 53 variables. So I have 382 students who have answered both data sets.  
  
#Combine the dublicated answers..  first I have to make a data frame with only the joined columns
 alc<- select(matpor, one_of(join))

#the columns in the data set which were not used for joining
not_joined_columns <- colnames(student_mat)[!colnames(student_mat) %in% join]
not_joined_columns

#Next I make the loop. The lopp is very clever one, I tried to undestand it, the copy was taken from the datacamp since I could not figure out this by my self

# for every column name not used for joining...
for(column_name in not_joined_columns) {
  # select two columns from 'matpor' with the same original name
  two_columns <- select(matpor, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

glimpse(alc)  

# Now I have combined the dublicated answers.
#I have a data set 'alc' with 382 observations and 33 variables. Nice.

#Then I need to make two new columns, 'alc_use' (avarage alc use when combined weekday 
#and weekend alcohol comsumption) and 'high_use' if 'alc_use' > 2. 


alc <- mutate(alc, alc_use = (Dalc + Walc) /2)
glimpse(alc)

alc <- mutate(alc, high_use = alc_use > 2)
glimpse(alc)  

#I get a data with 382 observations and 35 variables. That is correct. 

# Then I have to write and save a csv file. I also check that I did the right things and that it looks ok.

write.csv(alc, file = "alc.csv", eol= "\r", na = "NA", row.names = FALSE)
test <- read.csv("alc.csv", header = TRUE, sep = ",")
View(test)





