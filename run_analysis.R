# You should create one R script called run_analysis.R that does the following. 

# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 

# From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.

# Good luck!

# Please upload the tidy data set created in step 5 of the instructions. 
# Please upload your data set as a txt file created with write.table() 
# using row.name=FALSE (do not cut and paste a dataset directly into the 
# text box, as this may cause errors saving your submission).

setwd("~/Dropbox/Trabalho e Estudo/Cursos Livres/Getting and Cleaning Data/Project")

loc.features = "/home/pcbrom/Dropbox/Trabalho e Estudo/Cursos Livres/Getting and Cleaning Data/Project/UCI HAR Dataset/features.txt"
data <- read.table(loc.features, sep="", stringsAsFactors = F)

loc.test = list.files("/home/pcbrom/Dropbox/Trabalho e Estudo/Cursos Livres/Getting and Cleaning Data/Project/UCI HAR Dataset/test")
loc.train = list.files("/home/pcbrom/Dropbox/Trabalho e Estudo/Cursos Livres/Getting and Cleaning Data/Project/UCI HAR Dataset/train")

loc.test = loc.test[grep("*.txt", loc.test)]
loc.train = loc.train[grep("*.txt", loc.train)]

for(i in 1:3) 
{ 
  nam <- paste("data.test", i, sep = "")
  file.dt = paste("/home/pcbrom/Dropbox/Trabalho e Estudo/Cursos Livres/Getting and Cleaning Data/Project/UCI HAR Dataset/test",
                  loc.test[i], sep = "/", collapse = "")
  assign(nam, read.table(file.dt))
}

for(i in 1:3) 
{ 
  nam <- paste("data.train", i, sep = "")
  file.dt = paste("/home/pcbrom/Dropbox/Trabalho e Estudo/Cursos Livres/Getting and Cleaning Data/Project/UCI HAR Dataset/train",
                  loc.train[i], sep = "/", collapse = "")
  assign(nam, read.table(file.dt))
}

test = cbind(data.test1, data.test3, data.test2)
train = cbind(data.train1, data.train3, data.train2)

names(test) = c("subject", "activity", paste0(rep("x",(dim(test)[[2]] - 2)), seq(1:(dim(test)[[2]] - 2))))
names(train) = c("subject", "activity", paste0(rep("x",(dim(train)[[2]] - 2)), seq(1:(dim(train)[[2]] - 2))))

write.csv(test, "test.csv", row.names = F)
write.csv(train, "train.csv", row.names = F)

library(plyr)
data = rbind(train, test)
data = arrange(data, subject)

data.mean = aggregate(x = data, by = list(data$subject, data$activity), FUN = "mean")
data.sd = aggregate(x = data, by = list(data$subject, data$activity), FUN = "sd")

data.mean = data.mean[-c(3,4)]
data.sd = data.sd[-c(3,4)]

names(data.mean) = c("subject", "activity", paste0(rep("mean",(dim(data.mean)[[2]] - 2)), seq(1:(dim(data.mean)[[2]] - 2))))
names(data.sd) = c("subject", "activity", paste0(rep("sd",(dim(data.sd)[[2]] - 2)), seq(1:(dim(data.sd)[[2]] - 2))))

tidy.data = merge.data.frame(data.mean, data.sd, by = intersect(names(data.mean), names(data.sd)))
tidy.data = arrange(tidy.data, subject)

write.csv(tidy.data, "tidy_data.txt", row.names = F)
