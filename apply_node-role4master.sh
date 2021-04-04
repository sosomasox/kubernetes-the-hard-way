#!/bin/bash

kubectl label node `hostname` node-role.kubernetes.io/master=''
kubectl label node `hostname` node-role.kubernetes.io/controlplane=''
kubectl label node `hostname` node-role.kubernetes.io/etcd=''
kubectl taint node `hostname` node-role.kubernetes.io/master=:NoSchedule
kubectl taint node `hostname` node-role.kubernetes.io/controlplane=:NoSchedule
kubectl taint node `hostname` node-role.kubernetes.io/etcd=:NoExecute
exit 0
