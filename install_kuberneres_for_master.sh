#!/bin/bash

ETCD_VER=v3.4.14
KUBERNETES_VERSION=v1.20.4

GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}


rm -f /tmp/etcd-${ETCD_VER}-linux-arm64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

wget -q --show-progress --https-only --timestamping ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-arm64.tar.gz
tar xzvf etcd-${ETCD_VER}-linux-arm64.tar.gz
sudo mv etcd-${ETCD_VER}-linux-arm64/etcd* /usr/local/bin/

rm -rf etcd-${ETCD_VER}-linux-arm64
rm -f etcd-${ETCD_VER}-linux-arm64.tar.gz

mkdir -p \
    /etc/etcd/ \
    /var/lib/etcd/

chmod 700 /var/lib/etcd


wget -q --show-progress --https-only --timestamping https://dl.k8s.io/${KUBERNETES_VERSION}/bin/linux/arm64/kube-apiserver

sudo chmod +x kube-apiserver
sudo mv kube-apiserver /usr/local/bin

sudo mkdir -p \
    /etc/kubernetes/config/ \
    /var/lib/kubernetes/

wget -q --show-progress --https-only --timestamping https://dl.k8s.io/${KUBERNETES_VERSION}/bin/linux/arm64/kube-controller-manager


sudo chmod +x kube-controller-manager
sudo mv kube-controller-manager /usr/local/bin


wget -q --show-progress --https-only --timestamping https://dl.k8s.io/${KUBERNETES_VERSION}/bin/linux/arm64/kube-scheduler


sudo chmod +x kube-scheduler
sudo mv kube-scheduler /usr/local/bin


wget -q --show-progress --https-only --timestamping https://dl.k8s.io/${KUBERNETES_VERSION}/bin/linux/arm64/kubectl

sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin


mkdir -p \
    .kube/

chown ubuntu:ubuntu .kube/

mv admin.kubeconfig .kube/config


sudo mv \
    etcd-ca.pem \
    etcd-ca-key.pem \
    kube-etcd-`hostname`.pem \
    kube-etcd-`hostname`-key.pem \
    kube-etcd-peer-`hostname`.pem \
    kube-etcd-peer-`hostname`-key.pem \
    kube-apiserver-etcd-client.pem \
    kube-apiserver-etcd-client-key.pem \
    kube-etcd-healthcheck-client-key.pem \
    kube-etcd-healthcheck-client.pem \
    /etc/etcd/


sudo mv \
    kubernetes-ca.pem \
    kubernetes-ca-key.pem \
    kube-apiserver-`hostname`.pem \
    kube-apiserver-`hostname`-key.pem \
    kube-apiserver-kubelet-client.pem \
    kube-apiserver-kubelet-client-key.pem \
    kubernetes-front-proxy-ca.pem \
    front-proxy-client.pem \
    front-proxy-client-key.pem \
    service-account.pem \
    service-account-key.pem \
    encryption-config.yaml \
    kube-controller-manager.kubeconfig \
    kube-scheduler.kubeconfig \
    /var/lib/kubernetes/


sudo mv  \
    kube-scheduler.yaml \
    /etc/kubernetes/config/


sudo mv \
    etcd.service \
    kube-apiserver.service \
    kube-controller-manager.service \
    kube-scheduler.service \
    /etc/systemd/system/


sudo systemctl daemon-reload


sudo systemctl enable \
    etcd.service \
    kube-apiserver.service \
    kube-controller-manager.service \
    kube-scheduler.service


sudo systemctl restart \
    etcd.service \
    kube-apiserver.service \
    kube-controller-manager.service \
    kube-scheduler.service


exit 0
