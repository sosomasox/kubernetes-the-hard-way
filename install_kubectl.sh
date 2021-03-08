#!/bin/bash

VERSION=v1.20.1

sudo wget -q --show-progress --https-only --timestamping https://dl.k8s.io/${VERSION}/bin/linux/arm64/kubectl
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin

exit 0
