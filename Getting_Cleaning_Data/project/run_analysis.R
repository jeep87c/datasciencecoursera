## 0 Install missing packages and load
install.packages("data.table")
library(data.table)

## 1 Get & merge data

## 1.1 Unzip data
unzip("getdata-projectfiles-UCI HAR Dataset.zip")

## 1.2 Load raw data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")

## 1.3 Merge test & train data sets into one data set
dataset <- rbind(x_test, x_train)

## 2 Extracts only the measurements on the mean and standard deviation for each measurement.

## 2.1 Find the variable ids for mean and standard deviation (std)
all_features <- read.table("UCI HAR Dataset/features.txt")
features <- all_features[grep("mean|std", all_features$V2),]

## 2.2 Subset the data set
dataset_mean_and_std_only <- dataset[,features$V1]

## 3 Uses descriptive activity names to name the activities in the data set

## 3.1 Get activity for each measurement

## 3.2 Load raw data
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

## 3.3 Merge test & train activity data set into one
activity <- rbind(y_test, y_train)
activity <- merge(activity, activity_labels)

## 3.4 Add one variable to main data set to label the activity
dataset_mean_and_std_only$activity <- activity$V2

## 4 Appropriately labels the data set with descriptive variable names
names(dataset_mean_and_std_only) <- rbind(features, data.frame(V1=600, V2="activity"))$V2

## 5 Creates a second, independent tidy data set with the average of each variable for each activity and each subject

## 5.1 Load subject data sets
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

## 5.2 Merge test & train subject data sets into one data set
subject <- rbind(subject_test, subject_train)

## 5.3 Merge it to main data set
dataset_mean_and_std_only$subject <- subject$V1

## 5.4 Transform to data.table
dt <- data.table(dataset_mean_and_std_only)

## 5.5 Create second independent data set with the average of each variable for each activity and each subject
indepentent_dataset <- as.data.frame(dt[,lapply(.SD, mean),by=c("activity", "subject")])

