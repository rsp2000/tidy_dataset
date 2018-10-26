library(dplyr)

# Go to the subdir
setwd("./UCI HAR Dataset")

# 1) Merge the tables
# read tables first
###################
DS_xtrain <- read.table("./train/X_train.txt", header=FALSE)
DS_xtest <- read.table("./test/X_test.txt", header=FALSE)
DS_ytrain <- read.table("./train/Y_train.txt", header=FALSE)
DS_ytest <- read.table("./test/Y_test.txt", header=FALSE)
DS_s_train <- read.table("./train/subject_train.txt", header=FALSE)
DS_s_test <- read.table("./test/subject_test.txt", header=FALSE)
DS_actlbl <- read.table("./activity_labels.txt" , header=FALSE)
DS_features <- read.table("./features.txt" , header=FALSE)

# Combines (by rows) the data in order to create only one data set
##################################################################
DS_s_all <- rbind(DS_s_train, DS_s_test)
DS_y_all <- rbind(DS_ytrain, DS_ytest)
DS_x_all <- rbind(DS_xtrain, DS_xtest)

# 2) Only mean and standard deviation for each measurement
##########################################################
DS_meanstd <- DS_features[grep("mean\\(\\)|std\\(\\)",DS_features[,2]),]
DS_x_all <- DS_x_all[,DS_meanstd[,1]]

# 3) Descriptive activity names
################################
colnames(DS_y_all) <- "exec_activity"
DS_y_all$activitylabel <- factor(DS_y_all$exec_activity, labels = as.character(DS_actlbl$V2))
DS_act_names <- DS_y_all[,-1]

# 4) Labels the columns with descriptive names
##############################################
colnames(DS_x_all) <- DS_features[DS_meanstd[,1],2]

# 5) Create a tidy data set
###########################
colnames(DS_s_all) <- "subj_name"
DS_final <- cbind(DS_x_all, DS_act_names, DS_s_all)
DS_final_summarized <- DS_final %>% group_by(DS_act_names, subj_name) %>% summarise_all(mean)
write.table(DS_final_summarized, file = "./week4_tidydata.txt", col.names = TRUE, row.names = FALSE)
