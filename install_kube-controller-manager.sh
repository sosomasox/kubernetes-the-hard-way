#!/bin/bash

VERSION=v1.20.1

sudo wget -q --show-progress --https-only --timestamping https://dl.k8s.io/${VERSION}/bin/linux/arm64/kube-controller-manager
sudo chmod +x kube-controller-manager
sudo mv kube-controller-manager /usr/local/bin

exit 0
