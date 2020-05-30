## This script completes the following task:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## This script assumes the UCI HAR Dataset is unzipped into the "UCI HAR Dataset" folder in the working directory

# download file
if(!file.exists("dataset.zip")) download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","dataset.zip")

# Check if directory is available then unzip
if(!dir.exists("UCI HAR Dataset")){
    unzip("dataset.zip")
}

# load libraries
library(dplyr)
library(tidyr)
library(stringr)

## 1.Merges the training and the test sets to create one data set.

## Test dataset

#extract subject ID
subjtest <- tbl_df(read.table("UCI HAR Dataset/test/subject_test.txt")) %>%
    rename(ID=V1)

#extract activity IDs
actIDtest <- tbl_df(read.table("UCI HAR Dataset/test/y_test.txt")) %>%
    rename(Activity=V1)

#extract measurements
testset <- tbl_df(read.table("UCI HAR Dataset/test/X_test.txt"))

labeledtest <- tbl_df(cbind(subjtest,actIDtest,testset))

## Training dataset

#extract subject ID
subjtrain <- tbl_df(read.table("UCI HAR Dataset/train/subject_train.txt")) %>%
    rename(ID=V1)

#extract activity IDs
actIDtrain <- tbl_df(read.table("UCI HAR Dataset/train/y_train.txt")) %>%
    rename(Activity=V1)

trainset <- tbl_df(read.table("UCI HAR Dataset/train/X_train.txt"))

labeledtrain <- cbind(subjtrain,actIDtrain,trainset)

# merge datasets; training and test sets have unique IDs so rbind is sufficient
if(is.na(match(subjtest,subjtrain))) mergedset <- tbl_df(rbind(labeledtest,labeledtrain))
if(length(unique(mergedset$ID))==30) print("Merged Sucessfully!")

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# Extract indices with "mean" and "std" in features.txt
feature <- tbl_df(read.table("UCI HAR Dataset/features.txt"))

# Extract variable names from features.txt
filtered <- filter(feature,grepl('mean|std',feature$V2),)

#remove parentheses. duplicates, hyphens
goodnames <- filtered$V2 %>%
    str_replace_all("\\(\\)", "") %>%
    str_replace_all("BodyBody", "Body") %>%
    str_replace_all("-", "") %>%
    str_replace_all("mean", "Mean") %>%
    str_replace_all("std", "Std")

## 3. Uses descriptive activity names to name the activities in the data set

# Extact activity labels
activitylbl <- tbl_df(read.table("UCI HAR Dataset/activity_labels.txt"))

# Recode the activity labels
newdata <- recode(mergedset$Activity,
                  '1' = activitylbl$V2[1],
                  '2' = activitylbl$V2[2],
                  '3' = activitylbl$V2[3],
                  '4' = activitylbl$V2[4],
                  '5' = activitylbl$V2[5],
                  '6' = activitylbl$V2[6])

# Update activity labels
mergedset <- mergedset %>%
    mutate(Activity=newdata)

## 4. Appropriately labels the data set with descriptive variable names.

# Extract relevant variables and rename the variables in the merged set
renamedset <- select(mergedset,c(1:2,grep('Mean|Std',goodnames)+2)) %>%
    rename_at(3:81,funs(c(goodnames)))

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Mean of all columns, grouped by participant ID
avgbyparticiapnt <- renamedset %>%
    group_by(ID,Activity) %>%
    summarise_all("mean")

# store as new dataset "avgbyparticipant.csv"
write.table(avgbyparticiapnt,"avgbyparticipant.txt",row.name=FALSE) 
print("Exported successfully as avgbyparticipant.txt")



    

