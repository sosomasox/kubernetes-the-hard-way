#!/bin/bash

MASTER1_HOSTNAME=k8s-master1
MASTER2_HOSTNAME=k8s-master2
MASTER3_HOSTNAME=k8s-master3
WORKER1_HOSTNAME=k8s-worker1
WORKER2_HOSTNAME=k8s-worker2
WORKER3_HOSTNAME=k8s-worker3
WORKER4_HOSTNAME=k8s-worker4
WORKER5_HOSTNAME=k8s-worker5


for instance in ${MASTER1_HOSTNAME} ${MASTER2_HOSTNAME} ${MASTER3_HOSTNAME} ${WORKER1_HOSTNAME} ${WORKER2_HOSTNAME} ${WORKER3_HOSTNAME} ${WORKER4_HOSTNAME} ${WORKER5_HOSTNAME}; do
    scp \
        ./upgrade_kuberneres_for_master.sh \
        ./upgrade_kuberneres_for_worker.sh \
        ubuntu@${instance}:/home/ubuntu
done

exit 0
