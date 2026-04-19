intended_1-to-1_few.csv and intended_1-to-1_full.csv are the dataset split our group is using from 2-organizer.R being ran on the original dataset with the original dataset being https://www.kaggle.com/datasets/salikhussaini49/prediction-of-sepsis. For Multilayer Perceptron, to use the two csvs, the "intended_" part has to be removed.
For verifying the dataset split csvs, check their SHA-256 hashes. They are as follows:
intended_1-to-1_few.csv  SHA-256: 25060480879FE349B93FCABD0BED6FB5CCCF47171BAE283F440FC9CA52AEB273
intended_1-to-1_full.csv SHA-256: 208E5780A68F2A6C761F0C233364260AA733149DC1F0C21188FF078F39E7685F

And as for code:
1-generalizer.R          SHA-256: 6DD96900D24571F0C37878D4640041620CC69EF13A3CE764661028C139F0BBC2
2-organizer.R            SHA-256: A27481127373495A396C165C74DF30FCBFD8C1DA3231DC04172EF027C9D470E4
3-extender.R             SHA-256: 2694D25F4EDE1BE1F0FE8C0C4412F11C19403CBB633B73A8D17244665DFC95E4
4-finalizer.R            SHA-256: DDEAA5704AA900D2691C98E2EDFED78DD273E56422A867AFE1347433B4BF044B
multilayer_perceptron.py SHA-256: 398FA8F8D2BC98977951B97DEFC67F5DA5C971D78CD20869E887E17459B58095

When running any R file here, run them in RStudio with Source to Echo.
For any wonders on the code, there are notes across the code that explain them.
3-extender.R and 4-finalizer.R is only for analyzing and computing a dataset that could help for predicting sepsis within hours before occurrence. Our group ended up doing sepsis prediction at the moment the prediction tries to be made.
If those two R files are to be run, 3 depends on 2, and 4 depends on 3.

For "the same dataset split", please have 2-organizer.R, Dataset.csv, intended_1-to-1_few.csv, and intended_1-to-1_full.csv in the same folder, then run 2-organizer.R.
The 1-to-1_few.csv and 1-to-1_full.csv will have been generated if the code computed them as intended.
intended_1-to-1_few.csv and intended_1-to-1_full.csv are the authentic original dataset split computed and used in the Multilayer Perceptron model but used across all three models chosen now.