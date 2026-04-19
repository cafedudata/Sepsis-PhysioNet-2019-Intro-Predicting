# All operations here show our group how to interpret the sepsis dataset
# generally in preparation to taking a deeper dive into further comprehension

# Library installing
#install.packages('arules')
#install.packages('corrplot')
#install.packages('data.library')

# Library importing
library('arules')
library('corrplot')
library('data.table')

# Disabling scientific notation
options(scipen=99)

# Importing sepsis raw dataset as dataframes of full, no sepsis, and yes sepsis
csv_dataset <- fread('Dataset.csv')
csv_dataset_no <- csv_dataset[csv_dataset$SepsisLabel == 0]
csv_dataset_yes <- csv_dataset[csv_dataset$SepsisLabel == 1]

# Seeing summary of raw dataset
summary(csv_dataset)
summary(csv_dataset_no)
summary(csv_dataset_yes)

# Investigating percentage of null in each column of raw dataset
sort(colMeans(is.na(csv_dataset) * 100.0))
sort(colMeans(is.na(csv_dataset_no) * 100.0))
sort(colMeans(is.na(csv_dataset_yes) * 100.0))

# Seeing how balanced the patient counts are of raw dataset
unique_patient_ids_length <- length(unique(csv_dataset$Patient_ID))
unique_patient_ids_no_length <- length(unique(csv_dataset_no$Patient_ID))
unique_patient_ids_yes_length <- length(unique(csv_dataset_yes$Patient_ID))
unique_patient_ids_both_length <- (unique_patient_ids_no_length + unique_patient_ids_yes_length) - unique_patient_ids_length
paste('The number of unique patients is', unique_patient_ids_length, 'or', as.numeric(unique_patient_ids_length) / unique_patient_ids_length * 100.0, 'percent')
paste('The number of unique yes sepsis patients is', unique_patient_ids_yes_length, 'or', as.numeric(unique_patient_ids_yes_length) / unique_patient_ids_length * 100.0, 'percent')
paste('The number of unique no sepsis patients is', unique_patient_ids_no_length, 'or', as.numeric(unique_patient_ids_no_length) / unique_patient_ids_length * 100.0, 'percent')
paste('The number of unique have-yes-and-no patients is', unique_patient_ids_both_length, 'or', as.numeric(unique_patient_ids_both_length) / unique_patient_ids_length * 100.0, 'percent')

# Seeing the general cases where sepsis is to be predicted of raw dataset which
# helps in showing how to logically handle it both for machine learning models
# and preprocessing in R
unique_patient_ids <- unique(csv_dataset$Patient_ID)
paste('Each patient starting on hour 0 is', (min(csv_dataset$Hour) == 0) & (length(unique(csv_dataset$Patient_ID[csv_dataset$Hour == 0])) == unique_patient_ids_length))
paste('Each patient starting with no sepsis is', length(csv_dataset[csv_dataset$Hour == 0 & csv_dataset$SepsisLabel == 0]) == unique_patient_ids_length)
paste('Each patient starting with yes sepsis is', length(csv_dataset[csv_dataset$Hour == 0 & csv_dataset$SepsisLabel == 1]) == unique_patient_ids_length)
paste('Each patient having at least one status state where they are yes sepsis is', unique_patient_ids_yes_length == unique_patient_ids_length)
paste('Each patient having at least one status state where they are no sepsis is', unique_patient_ids_no_length == unique_patient_ids_length)

# Ensuring no ambiguity or redundancy
paste('V1 and Hour being identical is', isTRUE(all.equal(csv_dataset$V1, csv_dataset$Hour)))
paste('Unit 1 and Unit 2 having XOR relationship is', all(is.na(csv_dataset$Unit1) | is.na(csv_dataset$Unit2) | (csv_dataset$Unit1 != csv_dataset$Unit2)))

# Correlation matrix on raw dataset
corrplot(cor(csv_dataset, use='pairwise.complete.obs'))

# A brief Apriori analysis on raw dataset
correlations_len_two <- apriori(csv_dataset_yes, parameter=list(supp=0.0001, minlen=2, maxlen=2))
#correlations_len_three <- apriori(csv_dataset, parameter=list(supp=0.0001, minlen=3, maxlen=3))
inspect(sort(correlations_len_two, by='lift', decreasing=TRUE))
#inspect(sort(correlations_len_three, by='lift', decreasing=TRUE))
