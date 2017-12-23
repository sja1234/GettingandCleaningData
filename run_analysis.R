library(data.table)
library(dplyr)


featureLabels <- read.table("~/UCI HAR Dataset/features.txt")
activityLabels <- read.table("~/UCI HAR Dataset/activity_labels.txt", header = FALSE)

subject_training_data <- read.table("~/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activity_training_data <- read.table("~/UCI HAR Dataset/train/y_train.txt", header = FALSE)
features_training_data <- read.table("~/UCI HAR Dataset/train/X_train.txt", header = FALSE)

subject_training_test <- read.table("~/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activity_training_test <- read.table("~/UCI HAR Dataset/test/y_test.txt", header = FALSE)
features_training_test <- read.table("~/UCI HAR Dataset/test/X_test.txt", header = FALSE)

mergeddata <- rbind(
  cbind(subject_training_data, features_training_data, activity_training_data),
  cbind(subject_training_test, features_training_test, activity_training_test)
)
colnames(mergeddata) <- c("subject", t(featureLabels[2]), "activity")
columns_result <- grep("subject|activity|.*Mean.*|.*Std.*", colnames(mergeddata), ignore.case=TRUE)
resultData <- mergeddata[,columns_result]
dim(resultData)

resultData$activity <- as.character(resultData$activity)
for (i in 1:6){
  resultData$activity[resultData$activity == i] <- as.character(activityLabels[i,2])
}

resultData$activity <- as.factor(resultData$activity)
resultData$subject <- as.factor(resultData$subject)
resultData <- data.table(resultData)

tidyData <- aggregate(. ~subject + activity, resultData, mean)
tidyData <- tidyData[order(tidyData$subject,tidyData$activity),]
write.table(tidyData, file = "~/Tidy.txt", row.names = FALSE)
