### ML Pipeline

1. Data Gathering
2. Handling Missing Data
   Do Nothing
   Remove Entire Record
   Mode Median/Average/Most Frequent Value replacement
   Model Based Imputation
        K-Neareast Neighbors
        Regression
        Deep Learning
    Iterpolation / Extrapolation
    Forward Filling / Backward Filling
    Hot Deck Imputation

Ignore using LightGBM by using parameter use_missing = false.
XGBoost can impute Missing value.
LinearRegression throws error for missing values

### Example Drop Features with Missing Value

#####################################################

'''
from sklearn.datasets import fetch_california_housing
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import StratifiedKFold
from sklearn.metrics import mean_squared_error
from math import sqrt
import random
import numpy as np
random.seed(0)

#Fetching the dataset
import pandas as pd
dataset = fetch_california_housing()
train, target = pd.DataFrame(dataset.data), pd.DataFrame(dataset.target)
train.columns = ['zero','one','two','three','four','five','six','seven']
train.insert(loc=len(train.columns), column='target', value=target)

#Randomly replace 40% of the first column with NaN values
column = train['zero']
missing_pct = int(column.size * 0.4)
i = [random.choice(range(column.shape[0])) for _ in range(missing_pct)]
column[i] = np.NaN
train
'''
########################################################################
'''
train.shape
'''

######################################################
####### Remove observations that have missing values
####### Will drop all rows that have any missing values.
######################################################
'''
train.dropna(inplace=True)
train.shape
'''

### Impute using SimpleImpute Mean