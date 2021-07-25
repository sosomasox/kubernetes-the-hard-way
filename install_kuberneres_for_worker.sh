#!/bin/bash

KUBERNETES_VERSION=v1.21.0


sudo apt update
sudo apt -y install socat conntrack ipset


cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

sudo mkdir -p \
    /etc/cni/net.d/ \
    /etc/containerd/ \
    /etc/etcd/ \
    /opt/cni/bin/ \
    /var/lib/kubelet/ \
    /var/lib/kube-proxy/ \
    /var/lib/kubernetes/ 


wget -q --show-progress --https-only --timestamping \
  https://github.com/containernetworking/plugins/releases/download/v0.9.1/cni-plugins-linux-arm64-v0.9.1.tgz
sudo tar -xvf cni-plugins-linux-arm64-v0.9.1.tgz -C /opt/cni/bin/


wget -q --show-progress --https-only --timestamping \
    https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.20.0/crictl-v1.20.0-linux-arm64.tar.gz
tar -xvf crictl-v1.20.0-linux-arm64.tar.gz
chmod +x crictl
sudo mv crictl /usr/local/bin/
rm crictl-v1.20.0-linux-arm64.tar.gz cni-plugins-linux-arm64-v0.9.1.tgz


sudo apt -y install containerd=1.5.2-0ubuntu1~20.04.2 runc=1.0.0~rc10-0ubuntu1


wget -q --show-progress --https-only --timestamping \
    https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/arm64/kubelet
chmod +x kubelet
sudo mv kubelet /usr/local/bin/


wget -q --show-progress --https-only --timestamping \
   https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/arm64/kube-proxy
chmod +x kube-proxy
sudo mv kube-proxy /usr/local/bin/


wget https://github.com/flannel-io/flannel/releases/download/v0.13.0/flannel-v0.13.0-linux-arm64.tar.gz
tar -zxvf flannel-v0.13.0-linux-arm64.tar.gz
sudo mv flanneld /usr/local/bin/
rm flannel-v0.13.0-linux-arm64.tar.gz README.md mk-docker-opts.sh


sudo mv  \
    kube-etcd-flanneld-client.pem \
    kube-etcd-flanneld-client-key.pem \
    etcd-ca.pem \
    /etc/etcd/

sudo mv \
    config.toml \
    /etc/containerd/

sudo mv \
    kubernetes-ca.pem \
    kubernetes-front-proxy-ca.pem \
    /var/lib/kubernetes/

sudo mv \
    `hostname`.kubeconfig \
    /var/lib/kubelet/kubeconfig

sudo mv \
    `hostname`.pem \
    `hostname`-key.pem \
    kubelet-config.yaml \
    /var/lib/kubelet/

sudo mv \
    kube-proxy.kubeconfig \
    /var/lib/kube-proxy/

sudo mv \
    kube-proxy-config.yaml \
    /var/lib/kube-proxy/

sudo mv \
    kubelet.service \
    kube-proxy.service  \
    flanneld.service \
    /etc/systemd/system/

sudo systemctl daemon-reload

sudo systemctl enable \
    kubelet.service \
    kube-proxy.service \
    flanneld.service

sudo systemctl restart  \
    kubelet.service \
    kube-proxy.service \
    flanneld.service

sudo mv \
    10-flannel.conflist \
    /etc/cni/net.d/


sudo systemctl enable flanneld.service
sudo systemctl restart flanneld.service


exit 0
