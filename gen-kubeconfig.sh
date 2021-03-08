#!/bin/bash

MASTER1_HOSTNAME="k8s-master1"
MASTER2_HOSTNAME="k8s-master2"
MASTER3_HOSTNAME="k8s-master3"

WORKER1_HOSTNAME="k8s-worker1"
WORKER2_HOSTNAME="k8s-worker2"
WORKER3_HOSTNAME="k8s-worker3"
WORKER4_HOSTNAME="k8s-worker4"
WORKER5_HOSTNAME="k8s-worker5"

MASTER_ADDRESS="172.29.156.10"

CERT_DIR="../cert"

ls cert >/dev/null 2>&1
if [ $? != 0 ]; then
  echo "Please run in the same directory as cert" 
  exit
fi

mkdir kubeconfig && cd kubeconfig
if [ $? != 0 ]; then
  exit
fi

echo "---> Generate kubelet kubeconfig"
for instance in ${MASTER1_HOSTNAME} ${MASTER2_HOSTNAME} ${MASTER3_HOSTNAME} ${WORKER1_HOSTNAME} ${WORKER2_HOSTNAME} ${WORKER3_HOSTNAME} ${WORKER4_HOSTNAME} ${WORKER5_HOSTNAME}; do
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=${CERT_DIR}/kubernetes-ca.pem \
    --embed-certs=true \
    --server=https://${MASTER_ADDRESS}:9000 \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=${CERT_DIR}/${instance}.pem \
    --client-key=${CERT_DIR}/${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${instance} \
    --kubeconfig=${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=${instance}.kubeconfig
done


echo "---> Generate kube-proxy kubeconfig"
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=${CERT_DIR}/kubernetes-ca.pem \
  --embed-certs=true \
  --server=https://${MASTER_ADDRESS}:9000 \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
  --client-certificate=${CERT_DIR}/kube-proxy.pem \
  --client-key=${CERT_DIR}/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:kube-proxy \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig


echo "---> Generate kube-controller-manager kubeconfig"
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=${CERT_DIR}/kubernetes-ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
  --client-certificate=${CERT_DIR}/kube-controller-manager.pem \
  --client-key=${CERT_DIR}/kube-controller-manager-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:kube-controller-manager \
  --kubeconfig=kube-controller-manager.kubeconfig

kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig


echo "---> Generate kube-scheduler kubeconfig"
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=${CERT_DIR}/kubernetes-ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=kube-scheduler.kubeconfig

kubectl config set-credentials system:kube-scheduler \
  --client-certificate=${CERT_DIR}/kube-scheduler.pem \
  --client-key=${CERT_DIR}/kube-scheduler-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-scheduler.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:kube-scheduler \
  --kubeconfig=kube-scheduler.kubeconfig

kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig


echo "---> Generate admin user kubeconfig"
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=${CERT_DIR}/kubernetes-ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=admin.kubeconfig

kubectl config set-credentials admin \
  --client-certificate=${CERT_DIR}/admin.pem \
  --client-key=${CERT_DIR}/admin-key.pem \
  --embed-certs=true \
  --kubeconfig=admin.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=admin \
  --kubeconfig=admin.kubeconfig

kubectl config use-context default --kubeconfig=admin.kubeconfig


echo "---> Complete to generate kubeconfig"


exit 0
