## README

This repo is created as part of the course project for the Getting and Clearning Data Coursera course. It contains the following files:

- "UCI HAR Dataset" folder:  [Source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) | [Companion Site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
- run_analysis.R script, which processes the test and training datasets from the UCI HAR Dataset folder to create a tidied dataset
- codeBook.Rmd, which describes the changes from the original dataset
- avgbyparticipant.csv, which is the ouput of run_analysis.R

## Analysis R Script
**run_analysis.R**: This file achieves the following:

1. Checks if the folder "*UCI HAR Dataset*" containing the dataset is present in the working directory.
2. Reads and combines the subject IDs in *subject_test.txt* with the measurement data in the test set *X_test.txt*
3. Repeats #2 for subject IDs and measurement data in the training set, i.e. *subject_train.txt* & *X_train.txt*
4. Merge the datasets from #2 and #3
5. Extract activity labels from *activity_labels.txt* and recode the merged dataset
6. Since only the mean and standard deviations measurements are required, i.e. *"mean"* & *"std"*, the corresponding feature/variable names are extracted from the *features.txt*
7. The variable names are renamed for clarity under these conditions:
    - Parentheses removed, i.e. *"()"*
    - First letter of *"mean"* and *"std"* capitalised, i.e. *"Mean"*
    - Duplicates removed, i.e. *"BodyBody"*
    - Hyphens removed, i.e. *"-"*
8. The variables in #5 are renamed with the renamed features in #7
9. The dataset from #8 is summarised by participant *ID* and *Activity* labels to yield the mean values of each variable
10. The dataset from #9 is exported to a txt file, i.e. *"avgbyparticipant.txt"*