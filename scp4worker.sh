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
        install_kuberneres_for_worker.sh \
        uninstall_kuberneres_for_worker.sh \
        containerd/config.toml \
        cert/kubernetes-ca.pem \
        cert/${instance}.pem \
        cert/${instance}-key.pem \
        kubeconfig/${instance}.kubeconfig \
        kubeconfig/kube-proxy.kubeconfig \
        manifest/${instance}/kubelet-config.yaml \
        manifest/worker/kube-proxy-config.yaml \
        service/worker/kubelet.service \
        service/worker/kube-proxy.service \
        service/worker/flanneld.service \
        flanneld/10-flannel.conflist \
        cert/kube-etcd-flanneld-client.pem \
        cert/kube-etcd-flanneld-client-key.pem \
        cert/etcd-ca.pem \
        cert/kubernetes-front-proxy-ca.pem \
        ubuntu@${instance}:/home/ubuntu
done

exit 0
