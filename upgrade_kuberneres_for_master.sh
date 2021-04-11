#!/bin/bash

KUBERNETES_VERSION=v1.21.0


wget -q --show-progress --https-only --timestamping https://dl.k8s.io/${KUBERNETES_VERSION}/bin/linux/arm64/kube-apiserver

sudo chmod +x kube-apiserver
sudo mv kube-apiserver /usr/local/bin


wget -q --show-progress --https-only --timestamping https://dl.k8s.io/${KUBERNETES_VERSION}/bin/linux/arm64/kube-controller-manager

sudo chmod +x kube-controller-manager
sudo mv kube-controller-manager /usr/local/bin


wget -q --show-progress --https-only --timestamping https://dl.k8s.io/${KUBERNETES_VERSION}/bin/linux/arm64/kube-scheduler

sudo chmod +x kube-scheduler
sudo mv kube-scheduler /usr/local/bin


wget -q --show-progress --https-only --timestamping https://dl.k8s.io/${KUBERNETES_VERSION}/bin/linux/arm64/kube-scheduler

sudo chmod +x kube-scheduler
sudo mv kube-scheduler /usr/local/bin


sudo systemctl restart \
    kube-apiserver.service \
    kube-controller-manager.service \
    kube-scheduler.service


exit 0
