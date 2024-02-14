### Install Jupyter Notebook on a Ubuntu VM

sudo apt update
sudo apt install python3-pip python3-dev
sudo -H pip3 install --upgrade pip
sudo -H pip3 install virtualenv

mkdir ~/my_project_home
      cd ~/my_project_home
      virtualenv my_project_env
      source my_project_env/bin/activate

sudo pip install jupyter

jupyter notebook

python3 -m pip install scikit-learn


or as docker container

mkdir jupyter-notebook
cd jupyter-notebook

docker run -p 8888:8888 -v $(pwd):/home/jovyan/work jupyter/minimal-notebook
docker run -p 8888:8888 -v $(pwd):/home/jovyan/work jupyter/scipy-notebook
docker run -it --rm -p 10000:8888 -v "${PWD}":/home/jovyan/work jupyter/datascience-notebook:2023-06-01

https://cloud.bigopen.io/k8s/clusters/c-m-hrfhrq8g/api/v1/namespaces/shared-namespace/services/http:jupitor-nb:8888/proxy/login?next=%2Flab