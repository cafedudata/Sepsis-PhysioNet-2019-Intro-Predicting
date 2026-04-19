# Doing more rigorous dataset checking and adding columns

# Library installing
#install.packages('data.library')
#install.packages('modeest')

# Library importing
library('data.table')
library('modeest')

# Importing sepsis raw dataset and getting count for unique patient IDs for later R operations
csv_dataset <- fread('Dataset.csv')
unique_patient_ids_length <- length(unique(csv_dataset$Patient_ID))

# Sanity checks required for data cleanliness and the following
# SepsisLabelChanged calculation, Bilirubin_indirect column addition,
# and one-hot encoding for Gender column to Male and Female columns
organized_csv_dataset <- csv_dataset[order(csv_dataset$Patient_ID, csv_dataset$Hour)]
paste('Patient_ID and Hour combiantions, which must be unique, being unique is', nrow(unique(organized_csv_dataset[,.(Patient_ID, Hour)])) == nrow(organized_csv_dataset))
paste('Each Patient_ID and Hour being an integer is', all(is.integer(organized_csv_dataset$Patient_ID)) & all(is.integer(organized_csv_dataset$Hour)))
paste('Each hour being +1 of the previous hour (except 0) is', identical(data.table(organized_csv_dataset)[, max(Hour), by=Patient_ID][,Patient_ID:=NULL], data.table(organized_csv_dataset)[, max(Hour), by=Patient_ID][,Patient_ID:=NULL] - data.table(organized_csv_dataset)[, min(Hour), by=Patient_ID][,Patient_ID:=NULL]))
organized_csv_dataset$Bilirubin_indirect <- ifelse(is.na(organized_csv_dataset$Bilirubin_total) | is.na(organized_csv_dataset$Bilirubin_direct), NA, organized_csv_dataset$Bilirubin_total - organized_csv_dataset$Bilirubin_direct)
organized_csv_dataset$Male <- organized_csv_dataset$Gender
organized_csv_dataset$Female <- ifelse(organized_csv_dataset$Male, 0, 1)

# Calculating and adding SepsisLabelChanged column, then freeing temporary variables
a <- organized_csv_dataset
a <- rbind(a, list(NA, max(a$Hour)+1, NA, NA, NA, NA, NA, NA, NA, NA,
                   NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                   NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                   NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                   NA, NA, -1, max(a$Patient_ID)+1, NA, NA, NA))
a <- a[order(a$Patient_ID, a$Hour)]
b <- organized_csv_dataset
b <- rbind(b, list(NA, min(b$Hour)-1, NA, NA, NA, NA, NA, NA, NA, NA,
                   NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                   NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                   NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                   NA, NA, -1, min(b$Patient_ID)-1, NA, NA, NA))
b <- b[order(b$Patient_ID, b$Hour)]
C <- data.frame(matrix(nrow=nrow(a), ncol=0))
C$Hour <- a$Hour
C$SepsisLabelChanged <- ifelse(a$SepsisLabel == b$SepsisLabel, 0, 1)
C <- head(C, -1)
C$SepsisLabelChanged[C$Hour == 0] <- 0
organized_csv_dataset$SepsisLabelChanged <- C$SepsisLabelChanged
rm(a, b, C)
gc()

# A grand discovery
paste('The amount of times sepsis label changes for any given patient at most is', length(organized_csv_dataset$Patient_ID[organized_csv_dataset$SepsisLabelChanged == 1 & organized_csv_dataset$Patient_ID == mfv1(organized_csv_dataset$Patient_ID[organized_csv_dataset$SepsisLabelChanged == 1])]))

# Calculating patient IDs of sepsis label change possibilities
patient_ids_no_fully <- organized_csv_dataset$Patient_ID[organized_csv_dataset$Hour == 0 & organized_csv_dataset$SepsisLabel == 0][!organized_csv_dataset$Patient_ID[organized_csv_dataset$Hour == 0 & organized_csv_dataset$SepsisLabel == 0] %in% organized_csv_dataset$Patient_ID[organized_csv_dataset$SepsisLabelChanged == 1]]
patient_ids_yes_fully <- organized_csv_dataset$Patient_ID[organized_csv_dataset$Hour == 0 & organized_csv_dataset$SepsisLabel == 1][!organized_csv_dataset$Patient_ID[organized_csv_dataset$Hour == 0 & organized_csv_dataset$SepsisLabel == 1] %in% organized_csv_dataset$Patient_ID[organized_csv_dataset$SepsisLabelChanged == 1]]
patient_ids_no_to_yes <- organized_csv_dataset$Patient_ID[organized_csv_dataset$Hour == 0 & organized_csv_dataset$SepsisLabel == 0][organized_csv_dataset$Patient_ID[organized_csv_dataset$Hour == 0 & organized_csv_dataset$SepsisLabel == 0] %in% organized_csv_dataset$Patient_ID[organized_csv_dataset$SepsisLabelChanged == 1]]
patient_ids_yes_to_no <- organized_csv_dataset$Patient_ID[organized_csv_dataset$Hour == 0 & organized_csv_dataset$SepsisLabel == 1][organized_csv_dataset$Patient_ID[organized_csv_dataset$Hour == 0 & organized_csv_dataset$SepsisLabel == 1] %in% organized_csv_dataset$Patient_ID[organized_csv_dataset$SepsisLabelChanged == 1]]

# Calculating and analyzing count and percentage of sepsis label change possibilities
dataset_row_length <- nrow(organized_csv_dataset)
no_fully_row_length <- length(organized_csv_dataset$Patient_ID[organized_csv_dataset$Patient_ID %in% patient_ids_no_fully])
yes_fully_row_length <- length(organized_csv_dataset$Patient_ID[organized_csv_dataset$Patient_ID %in% patient_ids_yes_fully])
no_to_yes_row_length <- length(organized_csv_dataset$Patient_ID[organized_csv_dataset$Patient_ID %in% patient_ids_no_to_yes])
yes_to_no_row_length <- length(organized_csv_dataset$Patient_ID[organized_csv_dataset$Patient_ID %in% patient_ids_yes_to_no])
paste('No Sepsis Fully |', length(patient_ids_no_fully), 'Patients as Patient %:', (as.numeric(length(patient_ids_no_fully)) / unique_patient_ids_length) * 100.0, '|', no_fully_row_length, 'Patient Rows as Patients\' Row %:', (as.numeric(no_fully_row_length) / dataset_row_length) * 100.0)
paste('Yes Sepsis Fully |', length(patient_ids_yes_fully), 'Patients as Patient %:', (as.numeric(length(patient_ids_yes_fully)) / unique_patient_ids_length) * 100.0, '|', yes_fully_row_length, 'Patient Rows as Patients\' Row %:', (as.numeric(yes_fully_row_length) / dataset_row_length) * 100.0)
paste('No Sepsis to Yes Sepsis |', length(patient_ids_no_to_yes), 'Patients as Patient %:', (as.numeric(length(patient_ids_no_to_yes)) / unique_patient_ids_length) * 100.0, '|', no_to_yes_row_length, 'Patient Rows as Patients\' Row %:', (as.numeric(no_to_yes_row_length) / dataset_row_length) * 100.0)
paste('Yes Sepsis to No Sepsis |', length(patient_ids_yes_to_no), 'Patients as Patient %:', (as.numeric(length(patient_ids_yes_to_no)) / unique_patient_ids_length) * 100.0, '|', yes_to_no_row_length, 'Patient Rows as Patients\' Row %:', (as.numeric(yes_to_no_row_length) / dataset_row_length) * 100.0)

# Dataset preprocessing to be continued in 3-extender.R with this export
# TODO: Make each patient be 1 row and then export
fwrite(organized_csv_dataset, '2.csv')

# Configuring a full features and vitals features one patient one row csv where
# the first hour of the final sepsis status rows are used which initially was
# just for MLP (multilayer perceptron) but later Random Forest and XGBoost too
mlp_df <- organized_csv_dataset
# NA handling - DO NOT USE OTHERWISE DATA LEAKAGE WILL OCCUR
#mlp_df$Unit1[is.na(mlp_df$Unit1) & mlp_df$SepsisLabel == 1] <- mfv1(mlp_df$Unit1[mlp_df$SepsisLabel == 1], na_rm=TRUE)
#mlp_df$Unit1[is.na(mlp_df$Unit1) & mlp_df$SepsisLabel == 0] <- mfv1(mlp_df$Unit1[mlp_df$SepsisLabel == 0], na_rm=TRUE)
#mlp_df$Unit2[is.na(mlp_df$Unit2) & mlp_df$SepsisLabel == 1] <- mfv1(mlp_df$Unit2[mlp_df$SepsisLabel == 1], na_rm=TRUE)
#mlp_df$Unit2[is.na(mlp_df$Unit2) & mlp_df$SepsisLabel == 0] <- mfv1(mlp_df$Unit2[mlp_df$SepsisLabel == 0], na_rm=TRUE)
#for (colname in colnames(mlp_df)) {
#  if (colname %in% c('Gender', 'Unit1', 'Unit2', 'Male', 'Female')) {
#    next
#  }
#  mlp_df[[colname]][is.na(mlp_df[[colname]]) & mlp_df$SepsisLabel == 1] <- mean(mlp_df[[colname]][mlp_df$SepsisLabel == 1], na.rm=TRUE)
#  mlp_df[[colname]][is.na(mlp_df[[colname]]) & mlp_df$SepsisLabel == 0] <- mean(mlp_df[[colname]][mlp_df$SepsisLabel == 0], na.rm=TRUE)
#}
# With grand discovery, have each patient have only one row that is their
# earliest final sepsis status
mlp_df <- mlp_df[!(mlp_df$Patient_ID %in% c(patient_ids_no_fully, patient_ids_yes_fully) & mlp_df$Hour > 0) & !(mlp_df$Patient_ID %in% patient_ids_no_to_yes & mlp_df$SepsisLabelChanged != 1)]
# Clear columns that go unused
mlp_df$V1 <- NULL
mlp_df$Hour <- NULL
mlp_df$Gender <- NULL
mlp_df$Bilirubin_indirect <- NULL
mlp_df$SepsisLabelChanged <- NULL
# Preparation to verify csv computation and output
intended_mlp_df <- fread('intended_1-to-1_full.csv')
intended_mlp_few_df <- fread('intended_1-to-1_few.csv')
# Exporting 1 to 1 with all features
if (isTRUE(all.equal(mlp_df, intended_mlp_df))) {
  fwrite(mlp_df, '1-to-1_full.csv')
  print('1-to-1_full.csv was successfully computed and generated!')
} else {
  print('1-to-1_full failed verification and hence its csv was NOT generated!')
}
# Computing with few features, primarily the vitals
mlp_few_df <- mlp_df[, c('HR', 'O2Sat', 'Temp', 'SBP', 'MAP', 'DBP', 'Resp', 'EtCO2', 'Age', 'SepsisLabel', 'Patient_ID', 'Male', 'Female')]
# Exporting 1 to 1 with few features, primarily the vitals
if (isTRUE(all.equal(mlp_few_df, intended_mlp_few_df))) {
  fwrite(mlp_few_df, '1-to-1_few.csv')
  print('1-to-1_few.csv was successfully computed and generated!')
} else {
  print('1-to-1_few failed verification and hence its csv was NOT generated!')
}
