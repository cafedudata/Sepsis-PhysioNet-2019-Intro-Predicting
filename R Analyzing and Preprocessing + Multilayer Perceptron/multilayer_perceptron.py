# Importing libraries
import imblearn
import matplotlib.pyplot as plt
import pandas as pd
import sklearn

# Reading and setting up initial dataset
mlp_df_X = pd.read_csv('1-to-1_full.csv')
mlp_df_y = mlp_df_X.pop('SepsisLabel')
mlp_few_df_X = pd.read_csv('1-to-1_few.csv')
mlp_few_df_y = mlp_few_df_X.pop('SepsisLabel')

# 90:10 train test splitting
X_train, X_test, y_train, y_test = sklearn.model_selection.train_test_split(mlp_df_X, mlp_df_y, test_size=0.1, stratify=mlp_df_y, random_state=42)
X_train_few, X_test_few, y_train_few, y_test_few = sklearn.model_selection.train_test_split(mlp_few_df_X, mlp_few_df_y, test_size=0.1, stratify=mlp_few_df_y, random_state=42)

# NA mode imputing
# Unit1
X_train.loc[(y_train == 1) & (X_train['Unit1'].isna())] = X_train[y_train == 1]['Unit1'].mode().iloc[0]
X_train.loc[(y_train == 0) & (X_train['Unit1'].isna())] = X_train[y_train == 0]['Unit1'].mode().iloc[0]
X_test.loc[(y_test == 1) & (X_test['Unit1'].isna())] = X_train[y_train == 1]['Unit1'].mode().iloc[0]
X_test.loc[(y_test == 0) & (X_test['Unit1'].isna())] = X_train[y_train == 0]['Unit1'].mode().iloc[0]
# Unit2
X_train.loc[(y_train == 1) & (X_train['Unit2'].isna())] = X_train[y_train == 1]['Unit2'].mode().iloc[0]
X_train.loc[(y_train == 0) & (X_train['Unit2'].isna())] = X_train[y_train == 0]['Unit2'].mode().iloc[0]
X_test.loc[(y_test == 1) & (X_test['Unit2'].isna())] = X_train[y_train == 1]['Unit2'].mode().iloc[0]
X_test.loc[(y_test == 0) & (X_test['Unit2'].isna())] = X_train[y_train == 0]['Unit2'].mode().iloc[0]

# NA mean imputing, and while mean could have been set for NAs in regards to SepsisLabel in test, that has been stopped because with test data there is no knowing which way to lean
X_train.loc[y_train == 1, X_train.columns] = X_train.loc[y_train == 1, X_train.columns].fillna(X_train.mean())
X_train.loc[y_train == 0, X_train.columns] = X_train.loc[y_train == 0, X_train.columns].fillna(X_train.mean())
X_test.loc[y_test == 1, X_test.columns] = X_test.loc[y_test == 1, X_test.columns].fillna(X_train.mean()) # For testing we don't know sepsis label
X_test.loc[y_test == 0, X_test.columns] = X_test.loc[y_test == 0, X_test.columns].fillna(X_train.mean()) # For testing we don't know sepsis label
X_train_few.loc[y_train_few == 1, X_train_few.columns] = X_train_few.loc[y_train_few == 1, X_train_few.columns].fillna(X_train_few.mean())
X_train_few.loc[y_train_few == 0, X_train_few.columns] = X_train_few.loc[y_train_few == 0, X_train_few.columns].fillna(X_train_few.mean())
X_test_few.loc[y_test_few == 1, X_test_few.columns] = X_test_few.loc[y_test_few == 1, X_test_few.columns].fillna(X_train_few.mean()) # For testing we don't know sepsis label
X_test_few.loc[y_test_few == 0, X_test_few.columns] = X_test_few.loc[y_test_few == 0, X_test_few.columns].fillna(X_train_few.mean()) # For testing we don't know sepsis label
#X_train.to_csv('X_train.csv', index=False)
#X_train_few.to_csv('X_train_few.csv', index=False)

# Undersampling the majority class which is no sepsis
will_undersample = True
print(f'will_undersample = {will_undersample}\n')
if will_undersample:
    X_train, y_train = imblearn.under_sampling.RandomUnderSampler(random_state=42).fit_resample(X_train, y_train)
    X_train_few, y_train_few = imblearn.under_sampling.RandomUnderSampler(random_state=42).fit_resample(X_train_few, y_train_few)

# Dropping Patient_ID column because it does not help in predicting sepsis, but this is the chance to see which rows are associated with which patient IDs for debugging
del X_train['Patient_ID']
del X_test['Patient_ID']
del X_train_few['Patient_ID']
del X_test_few['Patient_ID']

# Training the models
mlp = sklearn.pipeline.make_pipeline(sklearn.preprocessing.StandardScaler(), sklearn.neural_network.MLPClassifier(hidden_layer_sizes=(500, 250), max_iter=3000, early_stopping=True, random_state=42))
mlp_few = sklearn.pipeline.make_pipeline(sklearn.preprocessing.StandardScaler(), sklearn.neural_network.MLPClassifier(hidden_layer_sizes=(500, 250), max_iter=3000, early_stopping=True, random_state=42))
mlp.fit(X_train, y_train)
mlp_few.fit(X_train_few, y_train_few)

# Testing the models
y_predict = mlp.predict(X_test)
print('mlp')
print(f'Accuracy: {sklearn.metrics.accuracy_score(y_test, y_predict)}')
print(f'Precision: {sklearn.metrics.precision_score(y_test, y_predict)}')
print(f'Recall: {sklearn.metrics.recall_score(y_test, y_predict)}')
print(f'F1 Score: {sklearn.metrics.f1_score(y_test, y_predict)}')
print(f'PR-AUC Score: {sklearn.metrics.average_precision_score(y_test, mlp.predict_proba(X_test)[:,1])}')
print(f'Confusion Matrix:\n{sklearn.metrics.confusion_matrix(y_test, y_predict)}')
y_predict_few = mlp_few.predict(X_test_few)
print('\nmlp_few')
print(f'Accuracy: {sklearn.metrics.accuracy_score(y_test_few, y_predict_few)}')
print(f'Precision: {sklearn.metrics.precision_score(y_test_few, y_predict_few)}')
print(f'Recall: {sklearn.metrics.recall_score(y_test_few, y_predict_few)}')
print(f'F1 Score: {sklearn.metrics.f1_score(y_test_few, y_predict_few)}')
print(f'PR-AUC Score: {sklearn.metrics.average_precision_score(y_test_few, mlp_few.predict_proba(X_test_few)[:,1])}')
print(f'Confusion Matrix:\n{sklearn.metrics.confusion_matrix(y_test_few, y_predict_few)}')

sklearn.metrics.ConfusionMatrixDisplay(confusion_matrix=sklearn.metrics.confusion_matrix(y_test_few, y_predict_few), display_labels=['Negative', 'Postive']).plot(cmap=plt.cm.Blues)
plt.show()

precision, recall, thresholds = sklearn.metrics.precision_recall_curve(y_test_few, mlp_few.predict_proba(X_test_few)[:,1])
sklearn.metrics.PrecisionRecallDisplay(precision=precision, recall=recall).plot()
plt.show()
