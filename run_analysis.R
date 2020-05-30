## This script completes the following task:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#load libraries
library(dplyr)

## 1.Merges the training and the test sets to create one data set.

# test dataset
subjtest <- tbl_df(read.table("UCI HAR Dataset/test/subject_test.txt")) %>%
    rename(ID=V1)
testset <- tbl_df(read.table("UCI HAR Dataset/test/X_test.txt"))
labeledtest <- cbind(subjtest,testset)

# training dataset
subjtrain <- tbl_df(read.table("UCI HAR Dataset/train/subject_train.txt")) %>%
    rename(ID=V1)
trainset <- tbl_df(read.table("UCI HAR Dataset/train/X_train.txt"))
labeledtrain <- cbind(subjtrain,trainset)

# merge datasets; training and test sets have unique IDs so rbind is sufficient
if(is.na(match(subjtest,subjtrain))) mergedset <- tbl_df(rbind(labeledtest,labeledtrain))
if(length(unique(mergedset$ID))==30) print("Merged Sucessfully!")

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# Extract indices with "mean" and "std" in features.txt
feature <- tbl_df(read.table("UCI HAR Dataset/features.txt"))
