#!/bin/bash

kubectl -n kube-system create configmap kubernetes-front-proxy-ca --from-file=kubernetes-front-proxy-ca.pem=/var/lib/kubernetes/kubernetes-front-proxy-ca.pem -o yaml | kubectl -nkube-system replace configmap kubernetes-front-proxy-ca -f -

exit 0
