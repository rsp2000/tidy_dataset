library(dplyr)
# read the X_train and X_test text files
X_test<-tbl_df(read.table("./test/X_test.txt",sep="",stringsAsFactors=F,header=F))
X_train<-tbl_df(read.table("./train/X_train.txt",sep="",stringsAsFactors=F,header=F))

# 1) Merge de tables
X_merge<-merge(X_train, X_test)

# 3) Uses descriptive activity names to name the activities in the data set 
activ_labels <- tbl_df(read.table("./activity_labels.txt",sep="",stringsAsFactors=F,header=F))
subject_train <- tbl_df(read.table("./train/subject_train.txt",sep="",stringsAsFactors=F,header=F))
activ_train <- merge(activ_labels, subject_train, by.x='V1', by.y='V1')
write.csv(activ_train, file = "activ_train.csv")
subject_test <- tbl_df(read.table("./test/subject_test.txt",sep="",stringsAsFactors=F,header=F))
activ_test <- merge(activ_labels, subject_test, by.x='V1', by.y='V1')
write.csv(activ_test, file = "activ_test.csv")


# 4) Appropriately labels the data set with descriptive variable names
features<-tbl_df(read.table("./features.txt",sep="",stringsAsFactors=F,header=F))
colnames(X_merge) <- features$V2

# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
listcolnames <- colnames(X_merge[grepl ("mean\\(\\).|std\\(\\).", colnames(X_merge))])
X_merge_stdmean <- subset (X_merge, select=c(listcolnames))

# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_dataset <- colMeans(X_merge_stdmean, na.rm=TRUE)
# Write CSV in R
write.csv(tidy_dataset, file = "tidy_dataset.csv")