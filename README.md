Getting and Cleaning Data - Course Project
========================================================

This analysis uses the Human Activity Recognition Using Smartphones Dataset V1.0
------------------

The purpose of this project is to demonstrate collecting, working with, and cleaning a data set. The result is a tidy data set that can be used for later analysis. 

Included is:  
1. a tidy data set as described below,  
2. a link to a Github repository with the script used for performing the analysis, and  
3. a code book that describes the variables, the data, and any transformations or work that was performed to clean up the data called CodeBook.md.  
  
Also included is this README.md in the repo with the scripts. This repo explains how all of the scripts work and how they are connected.

Description
------------------
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

Website: [UC Irvine Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

Here is the dataset used for the project: 

Dataset: [UCI Human Activity Recognition data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

# Here are the details of the R script called "run_analysis.R" that does the following:

The "reshape2" library is necessary for the melt/dcast used later in the script:

```r
require("reshape2")
```

```
## Loading required package: reshape2
```


## Merge the training and the test sets to create one data set.
The test & train data for subject (s), observation (x), and activity (y) data are merged.

```r
x_data <- rbind(read.table("UCI HAR Dataset/train/X_train.txt"), 
                read.table("UCI HAR Dataset/test/X_test.txt"))

y_data <- rbind(read.table("UCI HAR Dataset/train/y_train.txt"),
                read.table("UCI HAR Dataset/test/y_test.txt"))

s_data <- rbind(read.table("UCI HAR Dataset/train/subject_train.txt"),
                read.table("UCI HAR Dataset/test/subject_test.txt"))
```


## Extract only the measurements on the mean and standard deviation for each measurement.
The features table is assigned to the column headings of the observation (x) data, and the columns which do not contain mean or std data are excluded.

```r
features <- read.table("UCI HAR Dataset/features.txt")[,2]
names(x_data) <- features
x_data <- x_data[,grepl("-mean\\(|-std\\(", features)]
```


## Use descriptive activity names to name the activities in the data set
## Appropriately label the data set with descriptive variable names.
The activity table is used to update the activity (y) index with the applicable activity description instead. Column headings for the activity (y) and subject (s) data are made more descriptive.

```r
activity <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]
names(y_data) <- "activity"
y_data$activity <- activity[y_data$activity]

names(s_data) <- "subject"
```


## Combine all into one tidy data set
A column-bind merges the three tables into one large, tidy data set.

```r
t_data <- cbind(s_data, y_data, x_data)
```


## Create a second, independent tidy data set with the average of each variable for each activity and each subject.
A "melt" is used to create a "tall/skinny" summary (with means for each data observation) by subject & activity, and then the "dcast" re-summarizes the data by subject & activity into one tidy data set.  
Finally, the new, small, tidy dataset is written out as "tidy_dataset.txt".

```r
m_data <- melt(t_data, id.vars = c("subject", "activity"))
tidy_data <- dcast(m_data, subject + activity ~ variable, mean)

write.table(tidy_data, "tidy_dataset.txt")
```
