The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.


The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'


## run_analysis.R:

#1. Merges the training and the test sets to create one data set.

#set work directory
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

#set work directory
setwd("d:/docs/coursera/Getting and Cleaning Data")

# write dataset
write.table(db.all.average, file="tidy.txt",  row.names=FALSE)


