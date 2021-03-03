#!/bin/bash
echo    "Enter Cluster Provision Type."
echo -n "   1 for kind, 2 for AWS EKS: "
read num

if [[ $num -lt 1 || $num -gt 2 ]]; then
echo "Invalid entry, try again."
exit
elif [ $num -eq 1 ]; then
   kind create cluster --name capstone-part2  --config ./kind/kind-config.yml
   CLUSTER_CONTEXT="kind-capstone-part2"
elif [ $num -eq 2 ]; then
   cd ./aws
   terraform init
   terraform apply -auto-approve
   aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
   CLUSTER_RANDOM=`terraform output | grep "cluster: " | cut -f6 -d ' ' | cut -f2 -d '-'`
   CLUSTER_CONTEXT=`kubectl config get-contexts | grep $CLUSTER_RANDOM | cut -f13 -d ' '`
   cd ..
fi
echo $num > ./config-option.txt
kubectl config use-context $CLUSTER_CONTEXT
