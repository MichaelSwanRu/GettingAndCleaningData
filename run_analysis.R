#1. Merges the training and the test sets to create one data set.

#set work directory (windows)
setwd("d:/docs/coursera/Getting and Cleaning Data/UCI HAR Dataset")

# load 3 files with row data from train directory
db1.train <- read.table("./train/y_train.txt", header=FALSE)
db2.train <- read.table("./train/subject_train.txt", header=FALSE)
db3.train <- read.table("./train/X_train.txt", header=FALSE)

# combine columns of train data into one dataset: activity labels + subject labels + row data
db.train <- cbind(db1.train, db2.train, db3.train)

# load 3 files with test data from test directory
db1.test <- read.table("./test/y_test.txt", header=FALSE)
db2.test <- read.table("./test/subject_test.txt", header=FALSE)
db3.test <- read.table("./test/X_test.txt", header=FALSE)

# combine columns of test data into one dataset: activity labels + subject labels + row data
db.test <- cbind(db1.test, db2.test, db3.test)

# Finally combine rows of both datasets
db.all <- rbind(db.train, db.test)

#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# load data from features.txt file
db.features <- read.table("./features.txt", header=FALSE)

# list will have numbers of columns of variables which have “mean” & “std” in their names
list.mean_std <-grep("mean\\(|std\\(", db.features[,2])

# need to shift numbers of  variables because we add activities & subject columns before
list.mean_std <- list.mean_std +2

# need to add 2 first and second variables - activities & subject 
list.mean_std<-c(1,2,list.mean_std)

# select only variables which have “mean” & “std”
db.all <- subset(db.all, select= list.mean_std)

#3. Uses descriptive activity names to name the activities in the data set

# load data from activity_labels.txt file
activity_labels <- read.table("activity_labels.txt", header=FALSE)

#create new function: return variable from second column for each from first columns 
f.add.label <- function (x) { activity_labels[x,2]}

#replace code of activity by lable
db.all[,1]<-sapply(db.all[,1],f.add.label)

#4. Appropriately labels the data set with descriptive variable names. 

# list will have variables which have “mean” & “std” in their names
list.mean_std_text<-grep("mean\\(|std\\(", db.features[,2], value=TRUE)

# add 2 variables - activities & subject 
list.mean_std_text<-c("activity", "subject", list.mean_std_text)

#replace names of clumns of mane dataset
colnames(db.all) <- list.mean_std_text




#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

list.mean_std_small<-grep("mean\\(|std\\(", db.features[,2], value=TRUE)

#load library
library(reshape2)
# each row is a unique id-variable combination of activity & subject
db.all.melt <- melt(db.all, id= c("activity", "subject"), measure.vars = list.mean_std_small)

# create average effect of activity & subject
db.all.average <- dcast(db.all.melt, activity + subject ~ variable, mean)

# write dataset
write.table(db.all.average, file="tidy.txt",  row.names=FALSE) 
