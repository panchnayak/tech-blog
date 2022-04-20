Running a docker image in kubernetes

## Run a docker image using docker run

```
docker run -d --restart=always -e DOMAIN=cluster --name nginx-app -p 80:80 nginx
```

## Run docker image using kubectl

start the pod running nginx
```
kubectl create deployment --image=nginx nginx-app
```

## add env to nginx-app
```
kubectl set env deployment/nginx-app  DOMAIN=cluster
```

## expose a port through with a service

```
kubectl expose deployment nginx-app --port=80 --name=nginx-http
```

docker:
```
docker ps -a
```

kubectl:

```
kubectl get po
```

## DOCKER ATTACH

docker:

```
docker ps
docker attach container_id
```

kubectl:
```
kubectl get pods
```

NAME              READY     STATUS    RESTARTS   AGE
nginx-app-5jyvm   1/1       Running   0          10m

```
kubectl attach -it nginx-app-5jyvm
```
docker exec
```
docker ps
```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
55c103fa1296        nginx               "nginx -g 'daemon of…"   6 minutes ago       Up 6 minutes        0.0.0.0:80->80/tcp   nginx-app

```
docker exec 55c103fa1296 cat /etc/hostname
```

kubectl:

```
kubectl get po
```

NAME              READY     STATUS    RESTARTS   AGE
nginx-app-5jyvm   1/1       Running   0          10m

```
kubectl exec nginx-app-5jyvm -- cat /etc/hostname
```

nginx-app-5jyvm


To use interactive commands.

docker:

```
docker exec -ti 55c103fa1296 /bin/sh
```

kubectl:

```
kubectl exec -ti nginx-app-5jyvm -- /bin/sh
```

```
docker logs
```

docker:

```
docker logs -f a9e
```

kubectl:

```
kubectl logs -f nginx-app-zibvs
```

```
docker stop and docker rm
```

docker:

```
docker ps
docker stop a9ec34d98787
dockr rm a9ec34d98787
```

kubectl:

```
kubectl get deployment nginx-app
kubectl get po -l app=nginx-app
kubectl delete deployment nginx-app
kubectl get po -l app=nginx-app
```

