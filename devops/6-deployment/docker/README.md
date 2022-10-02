# Install Docker on any CentOS-7 or Ubuntu VM

The easy way to install docker on your Linux VM or laptop or desktop is to execute the following command from a terminal 

```
curl -sSL https://get.docker.com | bash

sudo usermod -aG docker $USER
sudo systemctl enable --now docker
```
logout and login so that the user can execute the docker commands successfully.

```
docker run
docker ps
docker images
docker stop $CONTAINER_ID
docker rm $CONTAINER_ID
docker rmi $IMAGE_ID
```