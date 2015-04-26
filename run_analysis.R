## run_analysis.R
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

setwd("/Users/nezah/projects/gettingandcleaningdata2/data")

activity_label <- read.table("./activity_labels.txt")
features <- read.table("./features.txt")
test_data <- read.table("./test/X_test.txt")
test_label <- read.table("./test/Y_test.txt")
train_data <-read.table("./train/X_train.txt")
train_label <-read.table("./train/Y_train.txt")

# 1. Merges the training and the test sets to create one data set.
merged_train_test_data <- rbind(train_data, test_data)
merged_train_test_label <- rbind(train_label, test_label)
nrow(train_data)
nrow(test_data)
nrow(merged_train_test_data)
head(merged_train_test_data)
head(merged_train_test_label)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
names(merged_train_test_data) = features$V2
head(merged_train_test_data)
onlymeanandstd <- merged_train_test_data[,grepl("mean\\(\\)|std\\(\\)", names(merged_train_test_data))]
head(onlymeanandstd)

# 3. Uses descriptive activity names to name the activities in the data set
head(merged_train_test_label)
names(merged_train_test_label) <- "act"
head(activity_label)
actnames <- factor(merged_train_test_label$act, activity_label$V1, activity_label$V2)
act_labeled_data <- cbind(onlymeanandstd, actnames)
head(act_labeled_data, n=5)
last(act_labeled_data)

# 4. Appropriately labels the data set with descriptive variable names. 
library(dplyr)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy <- mutate(group_by(act_labeled_data, actnames), avg=sum(x) / count(x))
