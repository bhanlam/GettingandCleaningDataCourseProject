## This script completes the following task:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## This script assumes the UCI HAR Dataset is unzipped into the "UCI HAR Dataset" folder in the working directory

# Check if dataset is available
if(!dir.exists("UCI HAR Dataset")){
    print("Dataset not in the right place!")
}else{ 

    # load libraries
    library(dplyr)
    library(tidyr)
    library(stringr)
    
    ## 1.Merges the training and the test sets to create one data set.
    
    # Extract featurenames
    feature <- tbl_df(read.table("UCI HAR Dataset/features.txt"))
    
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
    ## 3. Uses descriptive activity names to name the activities in the data set
    
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
    
    ## 4. Appropriately labels the data set with descriptive variable names.
    
    # Extract relevant variables and rename the variables in the merged set
    renamedset <- select(mergedset,c(1,grep('Mean|Std',goodnames)+1)) %>%
        rename_at(2:80,funs(c(goodnames)))
    
    ## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    
    # Mean of all columns, grouped by participant ID
    avgbyparticiapnt <- renamedset %>%
        group_by(ID) %>%
        summarise_all("mean")
    
    # store as new dataset "avgbyparticipant.csv"
    write.csv(avgbyparticiapnt,"avgbyparticipant.csv",row.names=FALSE)

}


    

