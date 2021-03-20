#!/bin/bash

sudo systemctl stop \
    etcd \
    kube-apiserver \
    kube-controller-manager \
    kube-scheduler
    
sudo rm -rf \
    /etc/etcd/ \
    /var/lib/etcd/ \
    /usr/local/bin/etcd \
    /usr/local/bin/etcdctl \
    /etc/systemd/system/etcd.service

sudo rm -rf \
    /etc/kubernetes/config/ \
    /var/lib/kubernetes/ \
    /usr/local/bin/kube-apiserver \
    /usr/local/bin/kube-controller-manager \
    /usr/local/bin/kube-scheduler \
    /etc/systemd/system/kube-apiserver.service \
    /etc/systemd/system/kube-controller-manager.service \
    /etc/systemd/system/kube-scheduler.service
    
rm -rf .kube/

sudo systemctl daemon-reload

exit 0
