# Extending 2.csv (extended_csv_dataset) with calculated SepsisWithinColumns

# Library installing
#install.packages('data.library')

# Library importing
library('data.table')

# Resuming where 2-organizer.R left off with organized_csv_dataset
organized_csv_dataset <- fread('2.csv')

# Warning: This may be RAM intensive, but calculates and adds
# SepsisWithinOneHour to SepsisWithinSixHours
organized_csv_dataset$SepsisWithinOneHour <- organized_csv_dataset$SepsisLabel
organized_csv_dataset$SepsisWithinOneHour[which(organized_csv_dataset$Hour > 0 & organized_csv_dataset$SepsisLabelChanged == 1) - 1] <- 1
organized_csv_dataset$SepsisWithinTwoHours <- organized_csv_dataset$SepsisWithinOneHour
organized_csv_dataset$SepsisWithinTwoHours[which(organized_csv_dataset$Hour > 0 & organized_csv_dataset$SepsisWithinTwoHours == 1) - 1] <- 1
organized_csv_dataset$SepsisWithinThreeHours <- organized_csv_dataset$SepsisWithinTwoHours
organized_csv_dataset$SepsisWithinThreeHours[which(organized_csv_dataset$Hour > 0 & organized_csv_dataset$SepsisWithinThreeHours == 1) - 1] <- 1
organized_csv_dataset$SepsisWithinFourHours <- organized_csv_dataset$SepsisWithinThreeHours
organized_csv_dataset$SepsisWithinFourHours[which(organized_csv_dataset$Hour > 0 & organized_csv_dataset$SepsisWithinFourHours == 1) - 1] <- 1
organized_csv_dataset$SepsisWithinFiveHours <- organized_csv_dataset$SepsisWithinFourHours
organized_csv_dataset$SepsisWithinFiveHours[which(organized_csv_dataset$Hour > 0 & organized_csv_dataset$SepsisWithinFiveHours == 1) - 1] <- 1
organized_csv_dataset$SepsisWithinSixHours <- organized_csv_dataset$SepsisWithinFiveHours
organized_csv_dataset$SepsisWithinSixHours[which(organized_csv_dataset$Hour > 0 & organized_csv_dataset$SepsisWithinSixHours == 1) - 1] <- 1

# Final dataset analysis and organizing before model training to be done in
# 4-finalizer.R with this export
fwrite(organized_csv_dataset, '3.csv')
