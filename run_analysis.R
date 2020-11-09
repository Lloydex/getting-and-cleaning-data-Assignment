library(dplyr)
# reading the train data
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# reading test data
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# reading features of the data
feature_names <- read.table("./UCI HAR Dataset/features.txt")

# reading activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# 1. Merging the training and the test sets to create one data set.
x_total <- rbind(xtrain, xtest)
y_total <- rbind(ytrain, ytest)
sub_total <- rbind(sub_train, sub_test)

# 2. Extracting the measurements on the mean and standard deviation for each measurement.
selected_var <- feature_names[grep("mean\\(\\)|std\\(\\)",feature_names[,2]),]
x_total <- x_total[selected_var[,1]]

# 3. Useing descriptive activity names to name the activities in the data set
colnames(y_total) <- "activity"
y_total$activitylabel <- factor(y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- y_total[,2]

# 4. Appropriately labeling the data set with descriptive variable names.
colnames(x_total) <- feature_names[selected_var[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(sub_total) <- "subject"
total <- cbind(x_total, activitylabel, sub_total)
data_set<- total %>% group_by(subject,activitylabel) %>% summarize_each(funs(mean))
write.table(data_set, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
