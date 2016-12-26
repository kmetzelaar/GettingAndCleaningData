## Coursera: Getting and Cleaning Data
## Course Project


######Replace "filePath" with your working directory/folder############
filePath <- "/Users/kmetzelaar/GettingAndCleaningData/Project" 

## Create a function to write a new line to the codebook.md

codebook <- function(...){
        cat(..., "\n",file=codebookFile,append=TRUE, sep="")
}
codebookFile <- file.path(filePath,"codebook.md")
file.remove(codebookFile)
codebook("# Code Book")
codebook("#")


#############################################
codebook("##Download/Unzip/Gather the data")##
#############################################

## Change the following values as necessary based on updates to the data set and/or zip file
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
codebook("* URL for Data: `",fileURL,"`")
fileName <- "Dataset.zip"
codebook("* File name stored in working directory: `",fileName,"`")
unzipDir <- "UCI HAR Dataset"
codebook("* Name of the directory zip file unzips to: `",unzipDir,"`")
trainDir <- "train"
testDir <- "test"

## Download data set to working directory       
download.file(fileURL,file.path(filePath,fileName))

## Unzip to local disk, "UCI HAR Dataset" sub-directory
unzip(file.path(filePath,fileName), overwrite = TRUE, exdir = filePath)

## Read the Training and Test experiment measurements
codebook("* Training experiment measurements read from: `",file.path(".",unzipDir,testDir,"X_train.txt"),"`")
xTrainData <- read.table(file.path(filePath,unzipDir,trainDir,"X_train.txt"))
codebook("* Test experiment measurements read from: `",file.path(".",unzipDir,testDir,"X_test.txt"),"`")
xTestData <- read.table(file.path(filePath,unzipDir,testDir,"X_test.txt"))
yTrainData <- read.table(file.path(filePath,unzipDir,trainDir,"y_train.txt"))
yTestData <- read.table(file.path(filePath,unzipDir,testDir,"y_test.txt"))

## Read the volunteer (subject) list
codebook("* Training subject numbers (volunteer numbers) read from: `",file.path(".",unzipDir,testDir,"subject_train.txt"),"`")
trainSubject <- read.table(file.path(filePath,unzipDir,trainDir,"subject_train.txt"))
codebook("* Test experiment measurements read from: `",file.path(".",unzipDir,testDir,"subject_test.txt"),"`")
testSubject <- read.table(file.path(filePath,unzipDir,testDir,"subject_test.txt"))

# Read the names of the "features," which are the names/categories of the experimental data collected
features <- read.table(file.path(filePath,unzipDir,"features.txt"))
# Normalize feature names to lower case
features$V2 <- tolower(features$V2)
codebook("* Feature names (measurement names) read from: `",file.path(".",unzipDir,"features.txt"),"`")

# Read the names of the activities (WALKING, SITTING, etc.)
activityLabels <- read.table(file.path(filePath,unzipDir,"activity_labels.txt"))
codebook("* Activity types read from: `",file.path(".",unzipDir,"activity_labels.txt"),"`")

## Assign names to columns
names(activityLabels) <- c("activity_number", "activity_name")



#################################################################
## Project Goal #1                                             ##
## Merge the training and the test sets to create one data set.##
#################################################################

codebook("##Steps")

codebook("* Bind together the Training and Test subjects into one data frame `bindedSubject`")
bindedSubject <- rbind(trainSubject, testSubject)


codebook("* Bind together the Training and Test activities into one data frame `bindedActivity`")
bindedActivity <- rbind(yTrainData, yTestData)


codebook("* Combine the subject and activity data frames into one data frame `bindedSubjectActivity`")
bindedSubjectActivity <- cbind(bindedSubject, bindedActivity)
## Assign names to columns
names(bindedSubjectActivity) <- c("subject_number", "activity_number")


codebook("* Bind the Training and Test experiment measurements into one data frame `bindedTrainTest`")
bindedTrainTest <- rbind(xTrainData, xTestData)
## Assign names to columns
names(bindedTrainTest) <- features$V2


codebook("* Bind the subject, activity, and experiment measurements into one data frame `bindedSubjectActivityAndData`")
bindedSubjectActivityAndData <- cbind(bindedSubjectActivity, bindedTrainTest)



############################################################################
## Project Goal #3                                                        ##
## Uses descriptive activity names to name the activities in the data set.##
############################################################################

## Merge the subject, activity, and experiment measurement data frame with the activityLabels
## This will add a column with the descriptive activity name (WALKING, SITTING, etc) to a new data frame
codebook("* Merge `activity_name` with `bindedSubjectActivityAndData` using  `activity_number` from each data frame as the key.")
codebook("* Merged data frame is call `mergedData`.")
mergedData <- merge(bindedSubjectActivityAndData, activityLabels, by.x = "activity_number", all.x=TRUE)
## Re-order the columns such that activity name comes after subject number. Remove activity number.
mergedData <- mergedData[ , c(2, 1, 564, 3:563)]
#############################################################################
## At this point the data table "mergedData" achieves Project Goals #1 & #3##
#############################################################################



###########################################################################################
## Project Goal #2                                                                       ##     
## Extract only the measurements on the mean and standard deviation for each measurement.##
###########################################################################################

## Extract only the columns that contain mean and standard deviation measurements
## Don't forget to keep the columns that contain activity and subject information
codebook("* Subset `mergedData` to contain only the `std` and `mean` feature columns.")
mergedData <- mergedData[ , grepl("activity|subject|(mean|std)\\(\\)",names(mergedData))]
#######################################################################
## At this point the data table "mergedData" achieves Project Goal #2##
#######################################################################

codebook("* Use `aggregate` command, which computes summary statistics of data subsets, to calculate the mean along subject + activity")



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


codebook("## Overall Data Set")
codebook("### Key columns")
codebook("Column name         | Description")
codebook("--------------------|------------")
codebook("`subject_number`    | Subject/Volunteer Number (1-30")
codebook("`activity_number`   | Activity type (1-6)")
codebook("`activity_name`     | Label for activity:")
codebook("                    | WALKING (activity_number 1)")
codebook("                    | WALKING_UPSTAIRS (2)")
codebook("                    | WALKING_DOWNSTAIRS (3)")
codebook("                    | SITTING (4)")
codebook("                    | STANDING (5)")
codebook("                    | LAYING (6)")
codebook("")

codebook("### Feature Name Decoder")
codebook("Column name         | Description")
codebook("--------------------|------------")
codebook("`time`              | Time Domain Measurement")
codebook("`frequency`         | Frequency Domain Measurement")
codebook("`accelerometer`     | Measurement from Accelerometer")
codebook("`gyroscope`         | Measurement from Gyroscope")
codebook("`magnitude`         | Measurement of Magnitude")
codebook("`body`              | Measurement from body")
codebook("`gravity`           | Measurement of gravity")
codebook("`standard_deviation`| Standard deviation measurement")
codebook("`mean`              | Mean measurement")
codebook("`X`,`Y`, or `Z      | Axis of measurement")


  


############################################################################
## Project Goal #5                                                        ##     
## From the data set in step 4, create a second, independent tidy data set##
## with the average of each variable for each activity and each subject.  ##
############################################################################

## Create Tidy Data
## Use "aggregate" command, which computes summary statistics of data subsets, to calculate the mean along subject + activity
tidyData <- aggregate(mergedData[ , 4:69], by = list(activity_name = mergedData$activity_name, subject_number = mergedData$subject_number), FUN = mean)



codebook("## Tidy Data Set")
codebook("### Key columns")
codebook("Column name         | Description")
codebook("--------------------|------------")
codebook("`subject_number`    | Subject/Volunteer Number (1-30")
codebook("`activity_name`     | Label for activity, same as above for Overall Data Set")
codebook("")

codebook("### Feature Name Decoder")
codebook("* Same as above, except the data recorded are the means along `subject_number` + `activity_name`")
codebook("* The range of the means is [-1,1]")
codebook("")



## Write overall data set with subject, activity, and experimental measurements to file
write.table(mergedData, file.path(filePath,"DataSet.txt"), row.names = FALSE)

## Write tidy data set with average of each variable for each activity and each subject.
write.table(tidyData, file.path(filePath, "TidyData.txt"), row.names = FALSE)


codebook("## Data output files")
codebook("Name                | Description")
codebook("--------------------|------------")
codebook("`DataSet.txt`       | Overall data set with subject, activity, and all experimental measurements") 
codebook("`TidyData.txt`      | Tidy data set with average of each variable for each activity and each subject")
codebook("")


############################### 
## All Project Goals complete##
###############################

