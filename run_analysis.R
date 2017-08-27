> setwd("C:/Users/susco/Desktop/Library_course3_w4/UCI HAR Dataset")
> library("data.table", lib.loc="~/R/win-library/3.4")
data.table 1.10.4
  The fastest way to learn (by data.table authors): https://www.datacamp.com/courses/data-analysis-the-data-table-way
  Documentation: ?data.table, example(data.table) and browseVignettes("data.table")
  Release notes, videos and slides: http://r-datatable.com
> library("dplyr", lib.loc="~/R/win-library/3.4")

Attaching package: ‘dplyr’

The following objects are masked from ‘package:data.table’:

    between, first, last

The following objects are masked from ‘package:stats’:

    filter, lag

The following objects are masked from ‘package:base’:

    intersect, setdiff, setequal, union

> library("reshape2", lib.loc="~/R/win-library/3.4")

Attaching package: ‘reshape2’

The following objects are masked from ‘package:data.table’:

    dcast, melt

> # Step 1. Merge the training and the test sets to create one data set.
> 
> ## Step 1.1. Download the assignment’s zip file from the indicated website 
> 
> if(!file.exists("./data")) dir.create("./data")
> fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
> download.file(fileUrl, destfile = "./data/projectData_getCleanData.zip")
trying URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
Content type 'application/zip' length 62556944 bytes (59.7 MB)
downloaded 59.7 MB

> 
> ## Step 1.2. Unzip and save the data from step 1.1.
> listZip <- unzip("./data/projectData_getCleanData.zip", exdir = "./data")
> 
> ## Step 1.3. Load the data from step 1.1. into R
> train.x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
> train.y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
> train.subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
> test.x <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
> test.y <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
> test.subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
> 
> ## Step 1.3. Merge train and test data
> trainData <- cbind(train.subject, train.y, train.x)
> testData <- cbind(test.subject, test.y, test.x)
> fullData <- rbind(trainData, testData)
> 
> #-------------------------------------------------------------------------------
> 
> # Step 2. Extract only the measurements on the mean and standard deviation for each measurement. 
> 
> ## Step 2.1. load feature name into R
> featureName <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
> 
> ##Step 2.2. Extract mean and standard deviation of each measurements
> featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName)
> finalData <- fullData[, c(1, 2, featureIndex+2)]
> colnames(finalData) <- c("subject", "activity", featureName[featureIndex])
> 
> #-------------------------------------------------------------------------------
> # Step 3. Uses descriptive activity names to name the activities in the data set
> 
> ## Step 3.1. load activity data into R
> activityName <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
> 
> ## Step 3.2, replace 1 to 6 with activity names
> finalData$activity <- factor(finalData$activity, levels = activityName[,1], labels = activityName[,2])
> 
> #-------------------------------------------------------------------------------
> 
> #Step 4. Appropriately labels the data set with descriptive variable names.
> 
> names(finalData) <- gsub("\\()", "", names(finalData))
> names(finalData) <- gsub("^t", "time", names(finalData))
> names(finalData) <- gsub("^f", "frequence", names(finalData))
> names(finalData) <- gsub("-mean", "Mean", names(finalData))
> names(finalData) <- gsub("-std", "Std", names(finalData))
> 
> #------------------------------------------------------------------------------------
> 
> 
> # Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
> library(dplyr)
> groupData <- finalData %>%
+     group_by(subject, activity) %>%
+     summarise_all(funs(mean))
> 
> write.table(groupData, "C:/Users/susco/Desktop/Library_course3_w4/UCI HAR Dataset/CleanData.txt", row.names = FALSE)
