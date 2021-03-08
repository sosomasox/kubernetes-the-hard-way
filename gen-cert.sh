#!/bin/bash

MASTER1_HOSTNAME="k8s-master1"
MASTER2_HOSTNAME="k8s-master2"
MASTER3_HOSTNAME="k8s-master3"
WORKER1_HOSTNAME="k8s-worker1"
WORKER2_HOSTNAME="k8s-worker2"
WORKER3_HOSTNAME="k8s-worker3"
WORKER4_HOSTNAME="k8s-worker4"
WORKER5_HOSTNAME="k8s-worker5"

MASTER1_ADDRESS="172.29.156.11"
MASTER2_ADDRESS="172.29.156.12"
MASTER3_ADDRESS="172.29.156.13"
WORKER1_ADDRESS="172.29.156.14"
WORKER2_ADDRESS="172.29.156.15"
WORKER3_ADDRESS="172.29.156.16"
WORKER4_ADDRESS="172.29.156.17"
WORKER5_ADDRESS="172.29.156.18"


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
    -config=../config/ca-config.json \
    -profile=etcd \
    -hostname=k8s-master1,k8s-master2,k8s-master3,172.29.156.11,172.29.156.12,172.29.156.13,localhost,127.0.0.1 \
    ../config/kube-etcd-m1-csr.json | cfssljson -bare kube-etcd-m1

cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem \
    -config=../config/ca-config.json \
    -profile=etcd \
    -hostname=k8s-master1,k8s-master2,k8s-master3,172.29.156.11,172.29.156.12,172.29.156.13,localhost,127.0.0.1 \
    ../config/kube-etcd-m2-csr.json | cfssljson -bare kube-etcd-m2

cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem \
    -config=../config/ca-config.json \
    -profile=etcd \
    -hostname=k8s-master1,k8s-master2,k8s-master3,172.29.156.11,172.29.156.12,172.29.156.13,localhost,127.0.0.1 \
    ../config/kube-etcd-m3-csr.json | cfssljson -bare kube-etcd-m3


echo "---> Generate certificate kube-etcd-peer"
cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem \
    -config=../config/ca-config.json \
    -profile=etcd \
    -hostname=k8s-master1,k8s-master2,k8s-master3,172.29.156.11,172.29.156.12,172.29.156.13,localhost,127.0.0.1 \
    ../config/kube-etcd-peer-m1-csr.json | cfssljson -bare kube-etcd-peer-m1

cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem  \
    -config=../config/ca-config.json \
    -profile=etcd \
    -hostname=k8s-master1,k8s-master2,k8s-master3,172.29.156.11,172.29.156.12,172.29.156.13,localhost,127.0.0.1 \
    ../config/kube-etcd-peer-m2-csr.json | cfssljson -bare kube-etcd-peer-m2

cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem \
    -config=../config/ca-config.json \
    -profile=etcd \
    -hostname=k8s-master1,k8s-master2,k8s-master3,172.29.156.11,172.29.156.12,172.29.156.13,localhost,127.0.0.1 \
    ../config/kube-etcd-peer-m3-csr.json | cfssljson -bare kube-etcd-peer-m3


echo "---> Generate certificate kube-etcd-healthcheck-client"
cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem \
    -config=../config/ca-config.json \
    -profile=etcd \
    ../config/kube-etcd-healthcheck-client-csr.json | cfssljson -bare kube-etcd-healthcheck-client


echo "---> Generate certificate kube-apiserver-etcd-client"
cfssl gencert \
    -ca=etcd-ca.pem \
    -ca-key=etcd-ca-key.pem \
    -config=../config/ca-config.json \
    -profile=etcd \
    ../config/kube-apiserver-etcd-client-csr.json | cfssljson -bare kube-apiserver-etcd-client


echo "---> Generate certificate for kubernetes admin user"
cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/ca-config.json \
    -profile=kubernetes \
    ../config/admin-csr.json | cfssljson -bare admin


echo "---> Generate certificate for kube-apiserver"
cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/ca-config.json \
    -profile=kubernetes \
    -hostname=k8s-master1,172,29.156.11,172.29.156.10,kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.default.svc.cluster.local,localhost,127.0.0.1 \
    ../config/kube-apiserver-m1-csr.json | cfssljson -bare kube-apiserver-m1

cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/ca-config.json \
    -profile=kubernetes \
    -hostname=k8s-master2,172,29.156.12,172.29.156.10,kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.default.svc.cluster.local,localhost,127.0.0.1 \
    ../config/kube-apiserver-m2-csr.json | cfssljson -bare kube-apiserver-m2

cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/ca-config.json \
    -profile=kubernetes \
    -hostname=k8s-master3,172,29.156.13,172.29.156.10,kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.default.svc.cluster.local,localhost,127.0.0.1 \
    ../config/kube-apiserver-m3-csr.json | cfssljson -bare kube-apiserver-m3


echo "---> Generate certificate for kube-apiserver-kubelet-client"
cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/ca-config.json \
    -profile=kubernetes \
    ../config/kube-apiserver-kubelet-client-csr.json | cfssljson -bare kube-apiserver-kubelet-client


echo "---> Generate certificate for kube-controller-manager"
cfssl gencert \
  -ca=kubernetes-ca.pem \
  -ca-key=kubernetes-ca-key.pem \
  -config=../config/ca-config.json \
  -profile=kubernetes \
  ../config/kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager


echo "---> Generate certificate for kube-scheduler"
cfssl gencert \
  -ca=kubernetes-ca.pem \
  -ca-key=kubernetes-ca-key.pem \
  -config=../config/ca-config.json \
  -profile=kubernetes \
  ../config/kube-scheduler-csr.json | cfssljson -bare kube-scheduler


echo "---> Generate certificate for kubelet"
cfssl gencert \
  -ca=kubernetes-ca.pem \
  -ca-key=kubernetes-ca-key.pem \
  -config=../config/ca-config.json \
  -hostname=${MASTER1_HOSTNAME},${MASTER1_ADDRESS} \
  -profile=kubernetes \
  ../config/${MASTER1_HOSTNAME}-csr.json | cfssljson -bare ${MASTER1_HOSTNAME}

cfssl gencert \
  -ca=kubernetes-ca.pem \
  -ca-key=kubernetes-ca-key.pem \
  -config=../config/ca-config.json \
  -hostname=${MASTER2_HOSTNAME},${MASTER2_ADDRESS} \
  -profile=kubernetes \
  ../config/${MASTER2_HOSTNAME}-csr.json | cfssljson -bare ${MASTER2_HOSTNAME}

cfssl gencert \
  -ca=kubernetes-ca.pem \
  -ca-key=kubernetes-ca-key.pem \
  -config=../config/ca-config.json \
  -hostname=${MASTER3_HOSTNAME},${MASTER3_ADDRESS} \
  -profile=kubernetes \
  ../config/${MASTER3_HOSTNAME}-csr.json | cfssljson -bare ${MASTER3_HOSTNAME}

cfssl gencert \
  -ca=kubernetes-ca.pem \
  -ca-key=kubernetes-ca-key.pem \
  -config=../config/ca-config.json \
  -hostname=${WORKER1_HOSTNAME},${WORKER1_ADDRESS} \
  -profile=kubernetes \
  ../config/${WORKER1_HOSTNAME}-csr.json | cfssljson -bare ${WORKER1_HOSTNAME}

cfssl gencert \
  -ca=kubernetes-ca.pem \
  -ca-key=kubernetes-ca-key.pem \
  -config=../config/ca-config.json \
  -hostname=${WORKER2_HOSTNAME},${WORKER2_ADDRESS} \
  -profile=kubernetes \
  ../config/${WORKER2_HOSTNAME}-csr.json | cfssljson -bare ${WORKER2_HOSTNAME}

cfssl gencert \
  -ca=kubernetes-ca.pem \
  -ca-key=kubernetes-ca-key.pem \
  -config=../config/ca-config.json \
  -hostname=${WORKER3_HOSTNAME},${WORKER3_ADDRESS} \
  -profile=kubernetes \
  ../config/${WORKER3_HOSTNAME}-csr.json | cfssljson -bare ${WORKER3_HOSTNAME}

cfssl gencert \
  -ca=kubernetes-ca.pem \
  -ca-key=kubernetes-ca-key.pem \
  -config=../config/ca-config.json \
  -hostname=${WORKER4_HOSTNAME},${WORKER4_ADDRESS} \
  -profile=kubernetes \
  ../config/${WORKER4_HOSTNAME}-csr.json | cfssljson -bare ${WORKER4_HOSTNAME}

cfssl gencert \
  -ca=kubernetes-ca.pem \
  -ca-key=kubernetes-ca-key.pem \
  -config=../config/ca-config.json \
  -hostname=${WORKER5_HOSTNAME},${WORKER5_ADDRESS} \
  -profile=kubernetes \
  ../config/${WORKER5_HOSTNAME}-csr.json | cfssljson -bare ${WORKER5_HOSTNAME}


echo "---> Generate certificate for kube-proxy"
cfssl gencert \
  -ca=kubernetes-ca.pem \
  -ca-key=kubernetes-ca-key.pem \
  -config=../config/ca-config.json \
  -profile=kubernetes \
  ../config/kube-proxy-csr.json | cfssljson -bare kube-proxy


echo "---> Generate certificate for front-proxy-client"
cfssl gencert \
    -ca=kubernetes-front-proxy-ca.pem \
    -ca-key=kubernetes-front-proxy-ca-key.pem \
    -config=../config/ca-config.json \
    -profile=kubernetes-front-proxy \
    ../config/front-proxy-client-csr.json | cfssljson -bare front-proxy-client


echo "---> Generate certificate for generating token of ServiceAccount"
cfssl gencert \
    -ca=kubernetes-ca.pem \
    -ca-key=kubernetes-ca-key.pem \
    -config=../config/ca-config.json \
    -profile=kubernetes \
    ../config/service-account-csr.json | cfssljson -bare service-account


echo "---> Complete to generate certificate"


exit 0
