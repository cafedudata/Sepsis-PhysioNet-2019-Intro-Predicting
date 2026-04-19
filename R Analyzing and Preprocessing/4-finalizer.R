# Full remaining analyses and a csv export in the anticipation on if sepsis
# could be predicted ahead of time, but this was too difficult, so the csv goes
# unused

# Library installing
#install.packages('arules')
#install.packages('corrplot')
#install.packages('data.library')

# Library importing
library('arules')
library('corrplot')
library('data.table')

# Resuming where 3-extender.R left off with organized_csv_dataset
organized_csv_dataset <- fread('3.csv')

# Correlation matrix on resulting dataset
corrplot(cor(organized_csv_dataset, use='pairwise.complete.obs'))

# A brief Apriori analysis on resulting dataset
correlations_len_two <- apriori(organized_csv_dataset, parameter=list(supp=0.0001, minlen=2, maxlen=2))
#correlations_len_three <- apriori(organized_csv_dataset, parameter=list(supp=0.0001, minlen=3, maxlen=3))
inspect(sort(correlations_len_two, by='lift', decreasing=TRUE))
#inspect(sort(correlations_len_three, by='lift', decreasing=TRUE))

# V1 and Gender columns removed because identical columns exist
organized_csv_dataset$V1 <- NULL
organized_csv_dataset$Gender <- NULL

# The completed R preprocessing of sepsis dataset export
fwrite(organized_csv_dataset, 'organized_dataset.csv')
