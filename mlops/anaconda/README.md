Anaconda - Open Source Python Destribution


Install Anaconda : Download the installer from https://www.anaconda.com/

```
which jupyter
conda create -n localsm python==3.9
conda activate localsm
conda install pip3 pandas tensorflow  keras
pip3 install notebook
pip3 install sagemaker
conda install ipykernel
python -m ipykernel install --user --name localsm --display-name "Python (localsm)"
jupytor notebook&
```