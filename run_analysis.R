
#This part shoul be change for each computer
setwd("E:/Cursos/DATA SCIENCES/Coursera/Getting and Cleaning Data/WEEK 4/MY PROJECT/Home Work")
if (!file.exists("MY PROJECT GETTING AND CLEANING DATA"))
{dir.create("MY PROJECT GETTING AND CLEANING DATA")}

UrlforFile <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(UrlforFile, destfile = "./MY PROJECT GETTING AND CLEANING DATA/Run Analysis.zip")


if (!file.exists("UCI HAR Dataset")) { 
unzip("./MY PROJECT GETTING AND CLEANING DATA/Run Analysis.zip")}


# Load activity labels + features
activityLabels1 <- read.table("E:/Cursos/DATA SCIENCES/Coursera/Getting and Cleaning Data/WEEK 4/MY PROJECT/Home Work/UCI HAR Dataset/activity_labels.txt")
activityLabels1
activityLabels1forcolumn2 <- as.character(activityLabels1[,2])
activityLabels1forcolumn2
features1 <- read.table("E:/Cursos/DATA SCIENCES/Coursera/Getting and Cleaning Data/WEEK 4/MY PROJECT/Home Work/UCI HAR Dataset/features.txt")
features1
features1forcolumn2<- as.character(features1[,2])
features1forcolumn2

# Extract only the data on mean and standard deviation
Operations <- grep(".*mean.*|.*std.*", features1[,2])
Operations
Operations.names <- features1[Operations,2]
Operations.names
Operations.names = gsub('-mean', 'Mean', Operations.names)
Operations.names
Operations.names = gsub('-std', 'Std', Operations.names)
Operations.names
Operations.names <- gsub('[-()]', '', Operations.names)
Operations.names

#Loading datasets (Test and Traing)
TrainingTest <- read.table("E:/Cursos/DATA SCIENCES/Coursera/Getting and Cleaning Data/WEEK 4/MY PROJECT/Home Work/UCI HAR Dataset/test/X_test.txt")[Operations]
TrainingTest
TrainingTestActivities <- read.table("E:/Cursos/DATA SCIENCES/Coursera/Getting and Cleaning Data/WEEK 4/MY PROJECT/Home Work/UCI HAR Dataset/test/y_test.txt")
TrainingTestActivities
TrainingTestActivities_S <- read.table("E:/Cursos/DATA SCIENCES/Coursera/Getting and Cleaning Data/WEEK 4/MY PROJECT/Home Work/UCI HAR Dataset/test/subject_test.txt")
TrainingTestActivities_S
TrainingTest <- cbind(TrainingTestActivities_S, TrainingTestActivities, TrainingTest)
TrainingTest


TrainTest <- read.table("E:/Cursos/DATA SCIENCES/Coursera/Getting and Cleaning Data/WEEK 4/MY PROJECT/Home Work/UCI HAR Dataset/train/X_train.txt")[Operations]
TrainTest
TrainTestActivities <- read.table("E:/Cursos/DATA SCIENCES/Coursera/Getting and Cleaning Data/WEEK 4/MY PROJECT/Home Work/UCI HAR Dataset/train/y_train.txt")
TrainTestActivities
TrainTestActivities_S <- read.table("E:/Cursos/DATA SCIENCES/Coursera/Getting and Cleaning Data/WEEK 4/MY PROJECT/Home Work/UCI HAR Dataset/train/subject_train.txt")
TrainTestActivities_S
TrainTest <- cbind(TrainTestActivities_S, TrainTestActivities, TrainTest)
TrainTest

# It is time to merge datasets and start to add labels
Datasetstoguethers <- rbind(TrainingTest, TrainTest)
Datasetstoguethers
colnames(Datasetstoguethers) <- c("subject", "activity", Operations.names)
colnames(Datasetstoguethers)

# Transforming activities & subjects into factors
Datasetstoguethers$activity <- factor(Datasetstoguethers$activity, levels = activityLabels1[,1], labels = activityLabels1forcolumn2)
Datasetstoguethers$subject <- as.factor(Datasetstoguethers$subject)
Datasetstoguethers$subject

#Writing the table in a more efficient way (Faster for the system) calculing the  average of each variable for each activity and each subject
library(reshape2)
allData.melted <- melt(Datasetstoguethers, id = c("subject", "activity"))
allData.melted
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)
allData.mean
View(allData.mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)


