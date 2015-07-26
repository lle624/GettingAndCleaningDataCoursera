# If the package "plyr" does not already exist, then install.packages("plyr")
# Load the necessary libraries
library(plyr)

# Obtain the data and unzip the data
filename <- "getdata_dataset.zip"
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

# 1. Merge the training and test sets to create one data set
##Load the training data
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

##Load the test data
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

##Combines the training and test sets into one dataset
x_all <- rbind(x_train, x_test)
y_all <- rbind(y_train, y_test)
subject_all <- rbind(subject_train, subject_test)

# 2. Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table("features.txt")
mean_sd_features <- grep("-(mean|std)\\(\\)", features[, 2])
x_all <- x_all[, mean_sd_features]
names(x_all) <- features[mean_sd_features, 2]

# 3. Use descriptive activity names to name the activities in the data set
activity_labels <- read.table("activity_labels.txt")
y_all[, 1] <- activity_labels[y_all[, 1], 2]
names(y_all) <- "activity"

# 4. Appropriately label the data set with descriptive variable names
names(subject_all) <- "subject"
all_data <- cbind(x_all, y_all, subject_all)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidydata <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(tidydata, "mytidydata.txt", row.name=FALSE)
