# running
# > Rscript run_analysis.R

require(reshape2)

data_dir <- "UCI HAR Dataset"
#data_dir <- "UCI HAR Dataset_small"

check_data_existance <- function() {
    if (file.exists(data_dir)) {
        TRUE
    } else {
        print(paste("Can not find directory with data. I expect data in the ",  data_dir, "directory."))
        FALSE
    }
}


get_merged <- function() {
    ## adds train and tests datasets to one file.

    # read necessary files
    features <- read.table(file.path(data_dir, "features.txt"),)
    train_X <- read.table(
        file.path(data_dir, "train", "X_train.txt"),
        header=FALSE)
    test_X <- read.table(
        file.path(data_dir, "test", "X_test.txt"),
        header=FALSE)

    train_y <- read.table(
        file.path(data_dir, "train", "y_train.txt"),
        header=FALSE)
    test_y <- read.table(
        file.path(data_dir, "test", "y_test.txt"),
        header=FALSE)

    train_subject <- read.table(
        file.path(data_dir, "train", "subject_train.txt"),
        header=FALSE)
    test_subject <- read.table(
        file.path(data_dir, "test", "subject_test.txt"),
        header=FALSE)

    # merge train and test
    merged_X <- rbind(train_X, test_X)
    merged_y <- rbind(train_y, test_y)
    merged_subject <- rbind(train_subject, test_subject)

    # set column names
    colnames(merged_X) <- features[, 2]
    colnames(merged_y) <- c("Activity_id")
    colnames(merged_subject) <- c("subject_id")

    # merge x an y
    merged <- cbind(merged_X, merged_subject, merged_y)
    merged
}

get_mean_and_std <- function(df) {
    ## removes columns without main or std words in column name

    # find columns to include in the return data frame
    valid_columns <- grep("mean|std|subject_id|Activity_id", names(df), value=TRUE)

    # subsetting data frame on valid columns
    subset(df, select=valid_columns)
}

expand_activities <- function(df) {
    ## replaces activity codes in the given data frame with their names
    ## df - data frame contaning Activity_id column with activity codes
    activity_df <- read.table(
        file.path(data_dir, "activity_labels.txt"),
        header=FALSE)
    names(activity_df) <- c("id", "Activity")
    total <- merge(df, activity_df, by.x="Activity_id", by.y="id")

    # remove activity codes
    total$Activity_id <- NULL

    total
}


activities_average <- function(df) {
    ## gets dataframe, returns dataframe with the average of each variable for each activity and each subject. 

    # add columns with activities
    ids <- c("subject_id", "Activity")
    all_except_ids <- Filter(function(x) !(x %in% ids), names(df))
    activities_melt <- melt(df, id=ids, measure.vars=all_except_ids)
    average_df <- dcast(activities_melt, subject_id + Activity ~ variable, mean)
    average_df
}


main <- function() {
    if (check_data_existance()) {
        merged <- get_merged()

        mean_and_std <- get_mean_and_std(merged)

        with_activities <- expand_activities(mean_and_std)

        average_df <- activities_average(with_activities)
        write.table(average_df, file="tidy_average.txt", row.names=FALSE)

        print("Done. tidy.txt contains tidy data frame. tidy_average.txt contains average activities.")
    } else {
        print("error")
    }
}

arg <- sub(".*=", "", commandArgs()[4])

if (!is.na(arg) & arg == "run_analysis.R") {
    # running as script, do the job
    main()
} else {
    # was imported using require, do nothing
    ;
}

