# Getting and Cleaning Data - Course Project

require("reshape2")

# Merge the training and the test sets to create one data set.

x_data <- rbind(read.table("UCI HAR Dataset/train/X_train.txt"), 
                read.table("UCI HAR Dataset/test/X_test.txt"))

y_data <- rbind(read.table("UCI HAR Dataset/train/y_train.txt"),
                read.table("UCI HAR Dataset/test/y_test.txt"))

s_data <- rbind(read.table("UCI HAR Dataset/train/subject_train.txt"),
                read.table("UCI HAR Dataset/test/subject_test.txt"))

# Extract only the measurements on the mean and standard deviation for each measurement.

features <- read.table("UCI HAR Dataset/features.txt")[,2]
names(x_data) <- features
x_data <- x_data[,grepl("-mean\\(|-std\\(", features)]

# Use descriptive activity names to name the activities in the data set
# Appropriately label the data set with descriptive variable names.

activity <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]
names(y_data) <- "activity"
y_data$activity <- activity[y_data$activity]

names(s_data) <- "subject"

#Combine all into one tidy data set

t_data <- cbind(s_data, y_data, x_data)

# First tidy data set output not needed...
# write.table(t_data, "tidy_dataset_1.txt")

# Create a second, independent tidy data set with the average of each variable 
# for each activity and each subject.

m_data <- melt(t_data, id.vars = c("subject", "activity"))
tidy_data <- dcast(m_data, subject + activity ~ variable, mean)

write.table(tidy_data, "tidy_dataset.txt")