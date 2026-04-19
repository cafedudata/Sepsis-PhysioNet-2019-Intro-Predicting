# Sepsis-PhysioNet-2019-Intro-Predicting 

## Overview
This project focuses on predicting sepsis using the PhysioNet 2019 dataset. It explores how preprocessing, feature selection, and class imbalance handling affect model performance across Random Forest, XGBoost and Multilayer Perceptron models.

---

## Dataset Usage & License

This project uses the **“Prediction of Sepsis” dataset** from Kaggle:

https://www.kaggle.com/datasets/salikhussaini49/prediction-of-sepsis

The dataset is licensed under:

**Creative Commons BY-NC-SA 4.0**  
https://creativecommons.org/licenses/by-nc-sa/4.0/

### What this means:
- You may use, modify, and share the dataset  
- You may NOT use it for commercial purposes  
- You MUST provide attribution  
- Any modified versions must use the same license  

---

## Dataset Inclusion

This repository **includes preprocessed versions of the dataset**:

- `intended_1-to-1_full.csv`
- `intended_1-to-1_few.csv`

These files are derived from the original dataset and have been:
- Cleaned
- Restructured
- Prepared for modeling

### Attribution
This project uses the dataset created by the Kaggle author.  
Changes were made to preprocess, clean, and restructure the data.

### Usage Restriction
This repository is intended **strictly for academic and non-commercial use** in accordance with the dataset license.

---


## Project Structure

```

Sepsis-PhysioNet-2019-Intro-Predicting/
│
├── R Analyzing and Preprocessing + Multilayer Perceptron/
│   ├── 1-generalizer.R
│   ├── 2-organizer.R
│   ├── 3-extender.R
│   ├── 4-finalizer.R
│   ├── multilayer_perceptron.py
│   ├── Dataset.csv                       # Download off of https://www.kaggle.com/datasets/salikhussaini49/prediction-of-sepsis
│   ├── intended_1-to-1_few.csv
│   ├── intended_1-to-1_full.csv
│   ├── 2.csv                             # Created after running 2-organizer.R on Dataset.csv
│   ├── 1-to-1_few.csv                    # Created after running 2-organizer.R on intended_1-to-1_few.csv
│   └── 1-to-1_full.csv                   # Created after running 2-organizer.R on intended_1-to-1_full.csv
│
├── XGBoost/
│   └── xgboost.ipynb
│
└── requirements.txt

```
---

## Installation

```bash
pip install -r requirements.txt
```
---

## Usage

### 1. Clone the Repository

```bash
git clone https://github.com/cafedudata/Sepsis-PhysioNet-2019-Intro-Predicting.git
cd Sepsis-PhysioNet-2019-Intro-Predicting
```

### 2. Download the Dataset

Download the dataset from Kaggle:

https://www.kaggle.com/datasets/salikhussaini49/prediction-of-sepsis

Place the file (`Dataset.csv`) into the following directory:

```
Sepsis-PhysioNet-2019-Intro-Predicting/
│
└── R Analyzing and Preprocessing + Multilayer Perceptron/
    └── Dataset.csv
```

---

### 3. Run Initial EDA

Run the generalizer script to explore the dataset:

```bash
Rscript "R Analyzing and Preprocessing + Multilayer Perceptron/1-generalizer.R"
```

### 4. Generate Processed Datasets

Run the organizer script to clean and restructure the data:

```bash
Rscript "R Analyzing and Preprocessing + Multilayer Perceptron/2-organizer.R"
```

### 5. Train Multilayer Perceptron Model

Run the following command to train and evaluate the MLP model:

```bash
python "R Analyzing and Preprocessing + Multilayer Perceptron/multilayer_perceptron.py"
```

### 6. Run XGBoost Model

Open and run the XGBoost Notebook:

```
XGBoost/xgboost.ipynb
```

---

## Key Insights

- Preprocessing significantly improves performance  
- Undersampling is not always beneficial after proper preprocessing  
- Feature richness is more impactful than feature reduction  
- PR-AUC reflects the difficulty of imbalanced classification  

---
