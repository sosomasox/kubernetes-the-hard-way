#!/bin/bash

sudo systemctl stop \
    containerd \
    kubelet \
    kube-proxy \
    flanneld

sudo rm -rf \
    /etc/cni/net.d/ \
    /etc/containerd/ \
    /etc/etcd/ \
    /opt/cni/bin/ \
    /var/lib/cni/ \
    /var/lib/kubelet/ \
    /var/lib/kube-proxy/ \
    /var/lib/kubernetes/ \
    /etc/modules-load.d/containerd.conf \
    /etc/sysctl.d/99-kubernetes-cri.conf \
    /etc/systemd/system/flanneld.service \
    /etc/systemd/system/kubelet.service \
    /etc/systemd/system/kube-proxy.service \
    /usr/local/bin/crictl \
    /usr/local/bin/flanneld \
    /usr/local/bin/kubelet \
    /usr/local/bin/kube-proxy \
    /run/flannel/subnet.env

sudo systemctl daemon-reload


sudo apt remove --purge -y containerd runc
sudo apt remove --purge -y socat conntrack ipset


exit 0
