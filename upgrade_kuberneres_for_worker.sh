#!/bin/bash

KUBERNETES_VERSION=v1.21.0

wget -q --show-progress --https-only --timestamping \
    https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/arm64/kubelet
chmod +x kubelet
sudo mv kubelet /usr/local/bin/

wget -q --show-progress --https-only --timestamping \
   https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/arm64/kube-proxy
chmod +x kube-proxy
sudo mv kube-proxy /usr/local/bin/

sudo systemctl restart  \
    kubelet.service \
    kube-proxy.service

exit 0
