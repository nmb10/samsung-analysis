# running
# > Rscript run_analysis.R

data_dir <- "UCI HAR Dataset"
# data_dir <- "UCI HAR Dataset_small"

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

    # merge train and test
    merged_X <- rbind(train_X, test_X)
    merged_y <- rbind(train_y, test_y)

    # set column names
    colnames(merged_X) <- features[, 2]
    colnames(merged_y) <- c("Activity")

    # merge x an y
    merged <- cbind(merged_X, merged_y)
    merged
}

get_mean_and_std <- function(df) {
    ## removes columns without main or std words in column name

    # find columns to include in the return data frame
    valid_columns <- grep("mean|std", names(df), value=TRUE)

    # subsetting data frame on valid columns
    subset(df, select=valid_columns)
}

main <- function() {
    if (check_data_existance()) {
        merged <- get_merged()
        write.table(merged, file="merged.txt", row.names=FALSE)
        mean_and_std <- get_mean_and_std(merged)
        write.table(mean_and_std, file="mean_and_std.txt", row.names=FALSE)
        print("Done. FIXME: What user should see?")
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

