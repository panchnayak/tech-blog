#!/bin/bash

RANCHER_API_ENDPOINT=https://192.168.1.103.bigopencloud.pnayak.com/v3
# The name of the cluster where the user needs to be added
CLUSTER_NAME=local
# Username, password and realname of the user
USER_NAME=pnayak
USER_PASSWORD=pnayakPassword
USER_REAL_NAME="PanchaleswarNayak"
# Role of the user
GLOBAL_ROLE=user
CLUSTER_ROLE=cluster-member
# Admin bearer token to create user
ADMIN_BEARER_TOKEN=token-zvwg6:5nh92n9z6sz7glpxsz7b9fmgwnckhk99flxbrnj4bz7v7ff2x7sx5v

# Create user and assign role

USER_ID=`curl -s -u $ADMIN_BEARER_TOKEN $RANCHER_API_ENDPOINT/user -H 'content-type: application/json' --data-binary '{"me":false,"mustChangePassword":false,"type":"user","username":"'$USER_NAME'","password":"'$USER_PASSWORD'","name":"'$USER_REAL_NAME'"}' --insecure | jq -r .id`
curl -s -u $ADMIN_BEARER_TOKEN $RANCHER_API_ENDPOINT/globalrolebinding -H 'content-type: application/json' --data-binary '{"type":"globalRoleBinding","globalRoleId":"'$GLOBAL_ROLE'","userId":"'$USER_ID'"}' --insecure

# Get clusterid from name
CLUSTER_ID=`curl -s -u $ADMIN_BEARER_TOKEN $RANCHER_API_ENDPOINT/clusters?name=$CLUSTER_NAME --insecure | jq -r .data[].id`

# Add user as member to cluster
curl -s -u $ADMIN_BEARER_TOKEN $RANCHER_API_ENDPOINT/clusterroletemplatebinding -H 'content-type: application/json' --data-binary '{"type":"clusterRoleTemplateBinding","clusterId":"'$CLUSTER_ID'","userPrincipalId":"local://'$USER_ID'","roleTemplateId":"'$CLUSTER_ROLE'"}' --insecure

# Login as user and get usertoken
LOGIN_RESPONSE=`curl -s $RANCHER_API_ENDPOINT-public/localProviders/local?action=login -H 'content-type: application/json' --data-binary '{"username":"'$USER_NAME'","password":"'$USER_PASSWORD'"}' --insecure`
USER_TOKEN=`echo $LOGIN_RESPONSE | jq -r .token`

# Generate and save kubeconfig
curl -s -u $USER_TOKEN $RANCHER_API_ENDPOINT/clusters/$CLUSTER_ID?action=generateKubeconfig -X POST -H 'content-type: application/json' --insecure | jq -r .config > kubeconfig

# Set mustChangePassword to true for user to change password upon login
curl -s -u $ADMIN_BEARER_TOKEN $RANCHER_API_ENDPOINT/users/$USER_ID -X PUT -H 'content-type: application/json' --data-binary '{"mustChangePassword":true}' --insecure