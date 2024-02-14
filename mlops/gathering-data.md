Run a Jupytor Notebook
'''
docker run -p 8888:8888 -v $(pwd):/home/jovyan/work jupyter/scipy-notebook
'''
Access the Notebook using 
'''
http://127.0.0.1:8888/lab?token=e49f372d89272f09e76d6de61374026ec45ac9f79e383577
'''
Execute the folloing Python Code

'''
from sklearn.datasets import fetch_california_housing
#Fetching the dataset
import pandas as pd
dataset = fetch_california_housing()
housing_data = pd.DataFrame(dataset.data)
housing_data.head()
'''
Execute to see the output

Execute the following to see the shape of data

'''
housing_data.shape
'''
The output will show the Observations (Rows) and the number of Features (columns).
