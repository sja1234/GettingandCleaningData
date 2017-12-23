library(data.table)
library(dplyr)


featureNames <- read.table("~/UCI HAR Dataset/features.txt")
activityLabels <- read.table("~/UCI HAR Dataset/activity_labels.txt", header = FALSE)

subject_training_data <- read.table("~/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activity_training_data <- read.table("~/UCI HAR Dataset/train/y_train.txt", header = FALSE)
features_training_data <- read.table("~/UCI HAR Dataset/train/X_train.txt", header = FALSE)

subject_training_test <- read.table("~/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activity_training_test <- read.table("~/UCI HAR Dataset/test/y_test.txt", header = FALSE)
features_training_test <- read.table("~/UCI HAR Dataset/test/X_test.txt", header = FALSE)

subject <- rbind(subject_training_data, subject_training_test)
activity <- rbind(activity_training_data, activity_training_test)
features <- rbind(features_training_data, features_training_test)

colnames(features) <- t(featureNames[2])

colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
mergeddata <- cbind(features,activity,subject)
columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(mergeddata), ignore.case=TRUE)
requiredColumns <- c(columnsWithMeanSTD, 562, 563)
dim(mergeddata)

resultData <- mergeddata[,requiredColumns]
dim(resultData)

resultData$Activity <- as.character(resultData$Activity)
for (i in 1:6){
  resultData$Activity[resultData$Activity == i] <- as.character(activityLabels[i,2])
}


resultData$Activity <- as.factor(resultData$Activity)

resultData$Subject <- as.factor(resultData$Subject)
resultData <- data.table(resultData)

tidyData <- aggregate(. ~Subject + Activity, resultData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "~/Tidy.txt", row.names = FALSE)
