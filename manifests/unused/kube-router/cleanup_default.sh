#!/bin/bash

kubectl -n kube-system delete ds kube-proxy
docker run --privileged --net=host gcr.io/google_containers/kube-proxy-arm:v1.7.3 kube-proxy --cleanup-iptables
