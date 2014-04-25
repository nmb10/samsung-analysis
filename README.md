run_analysis.R
================

Samsung Galaxy S smartphone accelerometers data analysing tool.

Description
-----------
R script to clean and analyse data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained - [download](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

Here are the data for the script: [download](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

Script does following job:

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive activity names.
- Creates a tidy data set file named tidy_average.txt with the average of each variable for each activity and each subject. 


Installation:
------------
- Download [script](https://github.com/nmb10/samsung-analysis/releases) and [data](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) to the script.
- Unzip data to the script's directory.


Usage:
======
- Run
```sh
Rscript run_analysis.R
```
- When the script ends its job, look for the tidy_average.txt in the script's directory.
