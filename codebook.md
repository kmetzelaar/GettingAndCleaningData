# Code Book
#
##Download/Unzip/Gather the data
* URL for Data: `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`
* File name stored in working directory: `Dataset.zip`
* Name of the directory zip file unzips to: `UCI HAR Dataset`
* Training experiment measurements read from: `./UCI HAR Dataset/test/X_train.txt`
* Test experiment measurements read from: `./UCI HAR Dataset/test/X_test.txt`
* Training subject numbers (volunteer numbers) read from: `./UCI HAR Dataset/test/subject_train.txt`
* Test experiment measurements read from: `./UCI HAR Dataset/test/subject_test.txt`
* Feature names (measurement names) read from: `./UCI HAR Dataset/features.txt`
* Activity types read from: `./UCI HAR Dataset/activity_labels.txt`

##Steps

* Bind together the Training and Test subjects into one data frame `bindedSubject`
* Bind together the Training and Test activities into one data frame `bindedActivity`
* Combine the subject and activity data frames into one data frame `bindedSubjectActivity`
* Bind the Training and Test experiment measurements into one data frame `bindedTrainTest`
* Bind the subject, activity, and experiment measurements into one data frame `bindedSubjectActivityAndData`
* Merge `activity_name` with `bindedSubjectActivityAndData` using  `activity_number` from each data frame as the key.
* Merged data frame is call `mergedData`.
* Subset `mergedData` to contain only the `std` and `mean` feature columns.
* Use `aggregate` command, which computes summary statistics of data subsets, to calculate the mean along subject plus activity

## Overall Data Set
### Key columns
Column name         | Description
--------------------|------------
`subject_number`    | Subject/Volunteer Number (1-30
`activity_number`   | Activity type (1-6)
`activity_name`     | Label for activity:
                    | WALKING (activity_number 1)
                    | WALKING_UPSTAIRS (2)
                    | WALKING_DOWNSTAIRS (3)
                    | SITTING (4)
                    | STANDING (5)
                    | LAYING (6)

### Feature Name Decoder
Column name         | Description
--------------------|------------
`time`              | Time Domain Measurement
`frequency`         | Frequency Domain Measurement
`accelerometer`     | Measurement from Accelerometer
`gyroscope`         | Measurement from Gyroscope
`magnitude`         | Measurement of Magnitude
`body`              | Measurement from body
`gravity`           | Measurement of gravity
`standard_deviation`| Standard deviation measurement
`mean`              | Mean measurement
`X`,`Y`, or `Z`     | Axis of measurement
## Tidy Data Set
### Key columns
Column name         | Description
--------------------|------------
`subject_number`    | Subject/Volunteer Number (1-30
`activity_name`     | Label for activity, same as above for Overall Data Set

### Feature Name Decoder
* Same as above, except the data recorded are the means along `subject_number` + `activity_name`
* The range of the means is [-1,1]

## Data output files
Name                | Description
--------------------|------------
`DataSet.txt`       | Overall data set with subject, activity, and all experimental measurements
`TidyData.txt`      | Tidy data set with average of each variable for each activity and each subject

