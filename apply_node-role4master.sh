#!/bin/bash

MASTER1_HOSTNAME=k8s-master1
MASTER2_HOSTNAME=k8s-master2
MASTER3_HOSTNAME=k8s-master3

for instance in ${MASTER1_HOSTNAME} ${MASTER2_HOSTNAME} ${MASTER3_HOSTNAME}; do
	kubectl label node $instance node-role.kubernetes.io/master=''
	kubectl label node $instance node-role.kubernetes.io/controlplane=''
	kubectl label node $instance node-role.kubernetes.io/etcd=''
	kubectl taint node $instance node-role.kubernetes.io/master=:NoSchedule
	kubectl taint node $instance node-role.kubernetes.io/controlplane=:NoSchedule
	kubectl taint node $instance node-role.kubernetes.io/etcd=:NoSchedule
done

exit 0
