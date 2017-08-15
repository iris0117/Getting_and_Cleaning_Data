#read in training and testing dataset
train = read.table("\\\\chnas01\\URC\\URC-Private\\Customer Information\\Users\\Wenting\\Coursera\\Getting_and_Cleaning_Data\\final_project\\FUCIHARD\\UCIHAR\\train\\X_train.txt")
feature = read.table("\\\\chnas01\\URC\\URC-Private\\Customer Information\\Users\\Wenting\\Coursera\\Getting_and_Cleaning_Data\\final_project\\FUCIHARD\\UCIHAR\\features.txt")
test = read.table("\\\\chnas01\\URC\\URC-Private\\Customer Information\\Users\\Wenting\\Coursera\\Getting_and_Cleaning_Data\\final_project\\FUCIHARD\\UCIHAR\\test\\X_test.txt")

#add column name to train and test dataset
colnames(train) = feature$V2
colnames(test) = feature$V2
dt = rbind(train,test)

#extract columns with "mean" and "std"
mean_st_nm = feature[(grepl("mean",feature$V2)|grepl("std",feature$V2))& (!grepl("[Mm]eanFreq",feature$V2)),]
dt_selected = dt[,mean_st_nm$V2]

#load activity file
activity = read.table("\\\\chnas01\\URC\\URC-Private\\Customer Information\\Users\\Wenting\\Coursera\\Getting_and_Cleaning_Data\\final_project\\FUCIHARD\\UCIHAR\\activity_labels.txt")
#load ydataset
y_train = read.table("\\\\chnas01\\URC\\URC-Private\\Customer Information\\Users\\Wenting\\Coursera\\Getting_and_Cleaning_Data\\final_project\\FUCIHARD\\UCIHAR\\train\\y_train.txt")
y_test = read.table("\\\\chnas01\\URC\\URC-Private\\Customer Information\\Users\\Wenting\\Coursera\\Getting_and_Cleaning_Data\\final_project\\FUCIHARD\\UCIHAR\\test\\y_test.txt")
y_dt = rbind(y_train,y_test)
#join y_dt and activity
y_dt_activity = merge(x=y_dt,y=activity,by = "V1" )
names(y_dt_activity) = c("subject","activity") 

#join activity name with dt
dt_final = cbind(y_dt_activity,dt_selected)

#Defining descriptive names for all variables.
names(dt_final) <- make.names(names(dt_final))
names(dt_final) <- gsub('Acc',"Acceleration",names(dt_final))
names(dt_final) <- gsub('GyroJerk',"AngularAcceleration",names(dt_final))
names(dt_final) <- gsub('Gyro',"AngularSpeed",names(dt_final))
names(dt_final) <- gsub('Mag',"Magnitude",names(dt_final))
names(dt_final) <- gsub('^t',"TimeDomain.",names(dt_final))
names(dt_final) <- gsub('^f',"FrequencyDomain.",names(dt_final))
names(dt_final) <- gsub('\\.mean',".Mean",names(dt_final))
names(dt_final) <- gsub('\\.std',".StandardDeviation",names(dt_final))
names(dt_final) <- gsub('Freq\\.',"Frequency.",names(dt_final))
names(dt_final) <- gsub('Freq$',"Frequency",names(dt_final))


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
dt_final_agg = aggregate(. ~subject + activity, dt_final, mean)

write.csv(dt_final,"\\\\chnas01\\URC\\URC-Private\\Customer Information\\Users\\Wenting\\Coursera\\Getting_and_Cleaning_Data\\final_project\\clean.csv")

write.csv(dt_final_agg,"\\\\chnas01\\URC\\URC-Private\\Customer Information\\Users\\Wenting\\Coursera\\Getting_and_Cleaning_Data\\final_project\\average.csv")


