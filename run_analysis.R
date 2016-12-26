## Coursera: Getting and Cleaning Data
## Course Project



###################################
## Download/Unzip/Gather the data##
###################################


######Replace "filePath" with your working directory/folder############
filePath <- "/Users/kmetzelaar/GettingAndCleaningData/Project" 

## Change the following values as necessary based on updates to the data set and/or zip file
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "Dataset.zip"
unzipDir <- "UCI HAR Dataset"
trainDir <- "train"
testDir <- "test"

## Download data set to working directory
download.file(fileURL,file.path(filePath,fileName))

## Unzip to local disk, "UCI HAR Dataset" sub-directory
unzip(file.path(filePath,fileName), overwrite = TRUE, exdir = filePath)

## Read the Training and Test experiment measurements
xTrainData <- read.table(file.path(filePath,unzipDir,trainDir,"X_train.txt"))
xTestData <- read.table(file.path(filePath,unzipDir,testDir,"X_test.txt"))
yTrainData <- read.table(file.path(filePath,unzipDir,trainDir,"y_train.txt"))
yTestData <- read.table(file.path(filePath,unzipDir,testDir,"y_test.txt"))

## Read the volunteer (subject) list
trainSubject <- read.table(file.path(filePath,unzipDir,trainDir,"subject_train.txt"))
testSubject <- read.table(file.path(filePath,unzipDir,testDir,"subject_test.txt"))

# Read the names of the "features," which are the names/categories of the experimental data collected
features <- read.table(file.path(filePath,unzipDir,"features.txt"))
# Normalize feature names to lower case
features$V2 <- tolower(features$V2)




#################################################################
## Project Goal #1                                             ##
## Merge the training and the test sets to create one data set.##
#################################################################

# Read the names of the activities (WALKING, SITTING, etc.)
activityLabels <- read.table(file.path(filePath,unzipDir,"activity_labels.txt"))
## Assign names to columns
names(activityLabels) <- c("activity_number", "activity_name")

## Bind together the Training and Test subjects into one data frame
bindedSubject <- rbind(trainSubject, testSubject)

## Bind together the Training and Test activities into one data frame
bindedActivity <- rbind(yTrainData, yTestData)

## combine the subject and activity data frames
bindedSubjectActivity <- cbind(bindedSubject, bindedActivity)
## assign names to columns
names(bindedSubjectActivity) <- c("subject_number", "activity_number")

## Bind together the Training and Test experiment measurements
bindedTrainTest <- rbind(xTrainData, xTestData)
## Assign names to columns
names(bindedTrainTest) <- features$V2

## Combine the subject, activity, and experiment measurements into one data frame
bindedSubjectActivityAndData <- cbind(bindedSubjectActivity, bindedTrainTest)



############################################################################
## Project Goal #3                                                        ##
## Uses descriptive activity names to name the activities in the data set.##
############################################################################

## Merge the subject, activity, and experiment measurement data frame with the activityLabels
## This will add a column with the descriptive activity name (WALKING, SITTING, etc) to a new data frame
mergedData <- merge(bindedSubjectActivityAndData, activityLabels, by.x = "activity_number", all.x=TRUE)
## Re-order the columns such that activity name comes after subject number. Remove activity number.
mergedData <- mergedData[ , c(2, 564, 3:563)]
#############################################################################
## At this point the data table "mergedData" achieves Project Goals #1 & #3##
#############################################################################



###########################################################################################
## Project Goal #2                                                                       ##     
## Extract only the measurements on the mean and standard deviation for each measurement.##
###########################################################################################

## Extract only the columns that contain mean and standard deviation measurements
## Don't forget to keep the columns that contain activity and subject information
mergedData <- mergedData[ , grepl("activity|subject|(mean|std)\\(\\)",names(mergedData))]
#######################################################################
## At this point the data table "mergedData" achieves Project Goal #2##
#######################################################################




#######################################################################
## Project Goal #4                                                   ##     
## Appropriately labels the data set with descriptive variable names.##
#######################################################################

## Make more descriptive, normalized column names
tempNames <- names(mergedData) 
tempNames <- gsub("^t", "time_", tempNames)
tempNames <- gsub("^f", "frequency_", tempNames)
tempNames <- gsub("acc", "_accelerometer_", tempNames)
tempNames <- gsub("gyro", "_gyroscope_", tempNames)
tempNames <- gsub("mag", "_magnitude_", tempNames)
tempNames <- gsub("-", "", tempNames)
tempNames <- gsub("std", "_standard_deviation_", tempNames)
tempNames <- gsub("mean", "_mean_", tempNames)
tempNames <- gsub("[(][)]", "", tempNames)
tempNames <- gsub("__", "_", tempNames)
tempNames <- gsub("_$", "", tempNames)
names(mergedData) <- tempNames
#######################################################################
## At this point the data table "mergedData" achieves Project Goal #4##
#######################################################################




############################################################################
## Project Goal #5                                                        ##     
## From the data set in step 4, create a second, independent tidy data set##
## with the average of each variable for each activity and each subject.  ##
############################################################################

## Create Tidy Data
## Use "aggregate" command, which computes summary statistics of data subsets, to calculate the mean along subject + activity
tidyData <- aggregate(mergedData[ , 3:68], by = list(activity = mergedData$activity_name, subject = mergedData$subject_number), FUN = mean)

## Write overall data set with subject, activity, and experimental measurements to file
write.table(mergedData, file.path(filePath,"DataSet.txt"), row.names = FALSE)

## Write tidy data set with average of each variable for each activity and each subject.
write.table(tidyData, file.path(filePath, "TidyData.txt"), row.names = FALSE)

###############################
## All Project Goals complete##
###############################

