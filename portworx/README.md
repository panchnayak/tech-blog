# Installing Portworx on a Kubernetes Platform

Create a portworx-policy
```
aws iam create-policy --policy-name portworx-policy --tags Key=Name,Value=portworx-policy --policy-document file://portworx-policy.json

```

If you are familiar with terraform then it is best you use the terraform eks blueprint for portworx

Clone the repo to your local directory

git clone https://github.com/panchnayak/terraform-eksblueprints-portworx-addon

You can follow the getting started guide at 

https://github.com/panchnayak/terraform-eksblueprints-portworx-addon/tree/main/blueprint/getting_started

Initialize the Terraform module:

```
cd blueprint/portworx_with_iam_policy
terraform init
```

Edit the values in main.tf according to your environment


If you dont want to use Terraform but eksctl tool, then create an EKS Cluster on AWS using eksctl

```
eksctl create -f kafka-poc/kafka-eks-cluster-demo.yaml
```

### Installing portworx is a very simple process

Check the accesability of the kubernetes cluster 
```
kubectl get nodes
```
### Check the pre-requisites from the following site

### Create a Operator Specification using https://central.portwox.com


### Install Portworx Operator
```

kubectl apply -f 'https://install.portworx.com/2.13?comp=pxoperator&kbver=1.24.0&ns=portworx'

```
Download the specificastion

Edit the epecification

### Apply the portworx specification

```
kubectl apply -f portworx-spec.yaml
```

Verify pxctl cluster provision status

kubectl -n kube-system get storagecluster

### Verify Portworx cluster status

export PX_POD=$(kubectl get pods -l name=portworx -n kube-system -o jsonpath='{.items[0].metadata.name}')
alias "kubectl exec $PX_POD -n kube-system -- /opt/pwx/bin/pxctl" pxctl

pxctl status

Create your portworx storage class for Kafka

kubectl apply -f portworx-sc.yaml
kubectl apply -f zookeeper-all.yaml
kubectl get pods
kubectl get pvc
kubectl get sts

pxctl volume inspect pvc-b79e96e9-7b79-11e7-a940-42010a8c0002

Verify that the Zookeeper ensemble is working.

kubectl exec zk-0 -- /opt/zookeeper/bin/zkCli.sh create /foo bar
kubectl exec zk-2 -- /opt/zookeeper/bin/zkCli.sh get /foo


### Install Kafka

Get the FQDN of each Zookeeper Pod by entering the following command:

```
for i in 0 1 2; do kubectl exec zk-$i -- hostname -f; done
```

Update the file kafka-all.yaml with the values in the zookeeper.connect property, then apply it.

```
kubectl apply -f kafka-all.yaml
```

kubectl get pods -l "app=kafka" -n kafka -w
kubectl get pvc -n kafka
pxctl volume list
pxctl volume inspect pvc-c405b033-7c4b-11e7-a940-42010a8c0002


## Find the Kafka brokers

for i in 0 1 2; do kubectl exec -n kafka kafka-$i -- hostname -f; done

### Create a topic with 3 partitions and which has a replication factor of 3

kubectl exec -n kafka -it kafka-0 -- bash

bin/kafka-topics.sh --zookeeper zk-headless.default.svc.cluster.local:2181 --create --if-not-exists --topic px-kafka-topic --partitions 3 --replication-factor 3

bin/kafka-topics.sh --list --zookeeper zk-headless.default.svc.cluster.local:2181
bin/kafka-topics.sh --describe --zookeeper zk-headless.default.svc.cluster.local:2181 --topic px-kafka-topic

### Push messages to the topic

bin/kafka-console-producer.sh --broker-list kafka-0.broker.kafka.svc.cluster.local:9092,kafka-1.broker.kafka.svc.cluster.local:9092,kafka-2.broker.kafka.svc.cluster.local:9092 --topic px-kafka-topic

### Consume messages from topic

bin/kafka-console-consumer.sh --zookeeper zk-headless.default.svc.cluster.local:2181 —topic px-kafka-topic --from-beginning

### Scalling

pxctl cluster list

kubectl get nodes -o wide

pxctl status

pxctl cluster list

kubectl scale -n kafka sts kafka --replicas=4

kubectl get pods -n kafka -l "app=kafka" -w

kubectl get pvc -n kafka

kubectl exec -n kafka -it kafka-0 -- bash

zkCli.sh

ls /brokers/ids

ls /brokers/topics

get /brokers/ids/3


## Failover

Pod Failover for Zookeeper

```
kubectl exec zk-0 -- pkill java
kubectl get pod -w -l "app=zk"
```

```
kubectl exec zk-0 -- zkCli.sh get /foo
```

### Pod Failover for Kafka

kubectl get pods -n kafka -o wide

kubectl cordon k8s-0

kubectl get nodes

kubectl get pvc -n kafka | grep data-kafka-1

/opt/pwx/bin/pxctl volume list | grep pvc-cc70447a-7c4b-11e7-a940-42010a8c0002

kubectl exec -n kafka -it kafka-0 -- bash

bin/kafka-topics.sh --describe --zookeeper zk-headless.default.svc.cluster.local:2181 --topic px-kafka-topic

kubectl delete po/kafka-1 -n kafka

kubectl get pods -n kafka -w

kubectl get pods -n kafka -o wide

bin/kafka-topics.sh --describe --zookeeper zk-headless.default.svc.cluster.local:2181 --topic px-kafka-topic


### Node Failover

