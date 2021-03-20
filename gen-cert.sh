#!/bin/bash

MASTER1_HOSTNAME=k8s-master1
MASTER2_HOSTNAME=k8s-master2
MASTER3_HOSTNAME=k8s-master3
WORKER1_HOSTNAME=k8s-worker1
WORKER2_HOSTNAME=k8s-worker2
WORKER3_HOSTNAME=k8s-worker3
WORKER4_HOSTNAME=k8s-worker4
WORKER5_HOSTNAME=k8s-worker5
MASTER1_ADDRESS=172.29.156.11
MASTER2_ADDRESS=172.29.156.12
MASTER3_ADDRESS=172.29.156.13
WORKER1_ADDRESS=172.29.156.14
WORKER2_ADDRESS=172.29.156.15
WORKER3_ADDRESS=172.29.156.16
WORKER4_ADDRESS=172.29.156.17
WORKER5_ADDRESS=172.29.156.18
LOADBALANCER_ADDRESS=172.29.156.10
KUBERNETES_SVC_ADDRESS=10.96.0.1
KUBERNETES_HOSTNAMES=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.default.svc.cluster.local


mkdir cert && cd cert
if [ $? != 0 ]; then
  exit
fi


echo "---> Generate etcd ca certificate"
cfssl gencert \
    -initca ../config/etcd-ca-csr.json | cfssljson -bare etcd-ca


echo "---> Generate kubernetes ca certificate"
cfssl gencert \
    -initca ../config/kubernetes-ca-csr.json | cfssljson -bare kubernetes-ca


echo "---> Generate kubernetes front proxy ca certificate"
cfssl gencert \
    -initca ../config/kubernetes-front-proxy-ca-csr.json | cfssljson -bare kubernetes-front-proxy-ca


echo "---> Generate certificate kube-etcd"
cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem \
    -config=../config/etcd-ca-config.json \
    -profile=peer \
    -hostname="${MASTER1_HOSTNAME},${MASTER2_HOSTNAME},${MASTER3_HOSTNAME},${MASTER1_ADDRESS},${MASTER2_ADDRESS},${MASTER3_ADDRESS},localhost,127.0.0.1" \
    ../config/kube-etcd-k8s-master1-csr.json | cfssljson -bare kube-etcd-k8s-master1

cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem \
    -config=../config/etcd-ca-config.json \
    -profile=peer \
    -hostname="${MASTER1_HOSTNAME},${MASTER2_HOSTNAME},${MASTER3_HOSTNAME},${MASTER1_ADDRESS},${MASTER2_ADDRESS},${MASTER3_ADDRESS},localhost,127.0.0.1" \
    ../config/kube-etcd-k8s-master2-csr.json | cfssljson -bare kube-etcd-k8s-master2

cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem \
    -config=../config/etcd-ca-config.json \
    -profile=peer \
    -hostname="${MASTER1_HOSTNAME},${MASTER2_HOSTNAME},${MASTER3_HOSTNAME},${MASTER1_ADDRESS},${MASTER2_ADDRESS},${MASTER3_ADDRESS},localhost,127.0.0.1" \
    ../config/kube-etcd-k8s-master3-csr.json | cfssljson -bare kube-etcd-k8s-master3


echo "---> Generate certificate kube-etcd-peer"
cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem \
    -config=../config/etcd-ca-config.json \
    -profile=peer \
    -hostname="${MASTER1_HOSTNAME},${MASTER2_HOSTNAME},${MASTER3_HOSTNAME},${MASTER1_ADDRESS},${MASTER2_ADDRESS},${MASTER3_ADDRESS},localhost,127.0.0.1" \
    ../config/kube-etcd-peer-k8s-master1-csr.json | cfssljson -bare kube-etcd-peer-k8s-master1

cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem  \
    -config=../config/etcd-ca-config.json \
    -profile=peer \
    -hostname="${MASTER1_HOSTNAME},${MASTER2_HOSTNAME},${MASTER3_HOSTNAME},${MASTER1_ADDRESS},${MASTER2_ADDRESS},${MASTER3_ADDRESS},localhost,127.0.0.1" \
    ../config/kube-etcd-peer-k8s-master2-csr.json | cfssljson -bare kube-etcd-peer-k8s-master2

cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem \
    -config=../config/etcd-ca-config.json \
    -profile=peer \
    -hostname="${MASTER1_HOSTNAME},${MASTER2_HOSTNAME},${MASTER3_HOSTNAME},${MASTER1_ADDRESS},${MASTER2_ADDRESS},${MASTER3_ADDRESS},localhost,127.0.0.1" \
    ../config/kube-etcd-peer-k8s-master3-csr.json | cfssljson -bare kube-etcd-peer-k8s-master3


echo "---> Generate certificate kube-etcd-healthcheck-client"
cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem \
    -config=../config/etcd-ca-config.json \
    -profile=client \
    ../config/kube-etcd-healthcheck-client-csr.json | cfssljson -bare kube-etcd-healthcheck-client


echo "---> Generate certificate kube-etcd-flanneld-client"
cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem \
    -config=../config/etcd-ca-config.json \
    -profile=client \
    ../config/kube-etcd-flanneld-client-csr.json | cfssljson -bare kube-etcd-flanneld-client


echo "---> Generate certificate kube-apiserver-etcd-client"
cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem \
    -config=../config/etcd-ca-config.json \
    -profile=client \
    ../config/kube-apiserver-etcd-client-csr.json | cfssljson -bare kube-apiserver-etcd-client


echo "---> Generate certificate for kubernetes admin user"
cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=client \
    ../config/admin-csr.json | cfssljson -bare admin


echo "---> Generate certificate for kube-apiserver"
cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=server \
    -hostname="${MASTER1_HOSTNAME},${MASTER2_HOSTNAME},${MASTER3_HOSTNAME},${WORKER1_HOSTNAME},${WORKER2_HOSTNAME},${WORKER3_HOSTNAME},${WORKER4_HOSTNAME},${WORKER5_HOSTNAME},${MASTER1_ADDRESS},${MASTER2_ADDRESS},${MASTER3_ADDRESS},${WORKER1_ADDRESS},${WORKER2_ADDRESS},${WORKER3_ADDRESS},${WORKER4_ADDRESS},${WORKER5_ADDRESS},${LOADBALANCER_ADDRESS},${KUBERNETES_SVC_ADDRESS},${KUBERNETES_HOSTNAMES},localhost,127.0.0.1" \
    ../config/kube-apiserver-k8s-master1-csr.json | cfssljson -bare kube-apiserver-k8s-master1

cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=server \
    -hostname="${MASTER1_HOSTNAME},${MASTER2_HOSTNAME},${MASTER3_HOSTNAME},${WORKER1_HOSTNAME},${WORKER2_HOSTNAME},${WORKER3_HOSTNAME},${WORKER4_HOSTNAME},${WORKER5_HOSTNAME},${MASTER1_ADDRESS},${MASTER2_ADDRESS},${MASTER3_ADDRESS},${WORKER1_ADDRESS},${WORKER2_ADDRESS},${WORKER3_ADDRESS},${WORKER4_ADDRESS},${WORKER5_ADDRESS},${LOADBALANCER_ADDRESS},${KUBERNETES_SVC_ADDRESS},${KUBERNETES_HOSTNAMES},localhost,127.0.0.1" \
    ../config/kube-apiserver-k8s-master2-csr.json | cfssljson -bare kube-apiserver-k8s-master2

cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=server \
    -hostname="${MASTER1_HOSTNAME},${MASTER2_HOSTNAME},${MASTER3_HOSTNAME},${WORKER1_HOSTNAME},${WORKER2_HOSTNAME},${WORKER3_HOSTNAME},${WORKER4_HOSTNAME},${WORKER5_HOSTNAME},${MASTER1_ADDRESS},${MASTER2_ADDRESS},${MASTER3_ADDRESS},${WORKER1_ADDRESS},${WORKER2_ADDRESS},${WORKER3_ADDRESS},${WORKER4_ADDRESS},${WORKER5_ADDRESS},${LOADBALANCER_ADDRESS},${KUBERNETES_SVC_ADDRESS},${KUBERNETES_HOSTNAMES},localhost,127.0.0.1" \
    ../config/kube-apiserver-k8s-master3-csr.json | cfssljson -bare kube-apiserver-k8s-master3


echo "---> Generate certificate for kube-apiserver-kubelet-client"
cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=client \
    -hostname="${WORKER1_HOSTNAME},${WORKER2_HOSTNAME},${WORKER3_HOSTNAME},${WORKER4_HOSTNAME},${WORKER5_HOSTNAME},${WORKER1_ADDRESS},${WORKER2_ADDRESS},${WORKER3_ADDRESS},${WORKER4_ADDRESS},${WORKER5_ADDRESS}" \
    ../config/kube-apiserver-kubelet-client-csr.json | cfssljson -bare kube-apiserver-kubelet-client


echo "---> Generate certificate for kube-controller-manager"
cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=client \
    ../config/kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager


echo "---> Generate certificate for kube-scheduler"
cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=client \
    ../config/kube-scheduler-csr.json | cfssljson -bare kube-scheduler


echo "---> Generate certificate for kubelet"
cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=peer \
    -hostname="${MASTER1_HOSTNAME},${MASTER1_ADDRESS}" \
    ../config/${MASTER1_HOSTNAME}-csr.json | cfssljson -bare ${MASTER1_HOSTNAME}

cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=peer \
    -hostname="${MASTER2_HOSTNAME},${MASTER2_ADDRESS}" \
    ../config/${MASTER2_HOSTNAME}-csr.json | cfssljson -bare ${MASTER2_HOSTNAME}

cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=peer \
    -hostname="${MASTER3_HOSTNAME},${MASTER3_ADDRESS}" \
    ../config/${MASTER3_HOSTNAME}-csr.json | cfssljson -bare ${MASTER3_HOSTNAME}

cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=peer \
    -hostname="${WORKER1_HOSTNAME},${WORKER1_ADDRESS}" \
    ../config/${WORKER1_HOSTNAME}-csr.json | cfssljson -bare ${WORKER1_HOSTNAME}

cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=peer \
    -hostname="${WORKER2_HOSTNAME},${WORKER2_ADDRESS}" \
    ../config/${WORKER2_HOSTNAME}-csr.json | cfssljson -bare ${WORKER2_HOSTNAME}

cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=peer \
    -hostname="${WORKER3_HOSTNAME},${WORKER3_ADDRESS}" \
    ../config/${WORKER3_HOSTNAME}-csr.json | cfssljson -bare ${WORKER3_HOSTNAME}

cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=peer \
    -hostname="${WORKER4_HOSTNAME},${WORKER4_ADDRESS}" \
    ../config/${WORKER4_HOSTNAME}-csr.json | cfssljson -bare ${WORKER4_HOSTNAME}

cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=peer \
    -hostname="${WORKER5_HOSTNAME},${WORKER5_ADDRESS}" \
    ../config/${WORKER5_HOSTNAME}-csr.json | cfssljson -bare ${WORKER5_HOSTNAME}


echo "---> Generate certificate for kube-proxy"
cfssl gencert \
  -ca=kubernetes-ca.pem \
  -ca-key=kubernetes-ca-key.pem \
  -config=../config/kubernetes-ca-config.json \
  -profile=client \
  ../config/kube-proxy-csr.json | cfssljson -bare kube-proxy


echo "---> Generate certificate for front-proxy-client"
cfssl gencert \
    -ca=kubernetes-front-proxy-ca.pem \
    -ca-key=kubernetes-front-proxy-ca-key.pem \
    -config=../config/kubernetes-front-proxy-ca-config.json \
    -profile=client \
    ../config/front-proxy-client-csr.json | cfssljson -bare front-proxy-client


echo "---> Generate certificate for generating token of ServiceAccount"
cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/kubernetes-ca-config.json \
    -profile=service-account \
    ../config/service-account-csr.json | cfssljson -bare service-account


echo "---> Complete to generate certificate"

exit 0
