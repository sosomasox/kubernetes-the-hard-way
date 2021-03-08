#!/bin/bash

VERSION=v1.20.1

sudo wget -q --show-progress --https-only --timestamping https://dl.k8s.io/${VERSION}/bin/linux/arm64/kube-apiserver
sudo chmod +x kube-apiserver
sudo mv kube-apiserver /usr/local/bin
sudo mkdir -p /var/lib/kubernetes
sudo mkdir -p /etc/kubernetes/config

exit 0
