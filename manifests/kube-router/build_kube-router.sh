#!/bin/bash

git clone https://github.com/cloudnativelabs/kube-router.git
cd kube-router

make gopath-fix GOARCH=arm
cd /src/github.com/cloudnativelabs/kube-router

make kube-router GOARCH=arm CGO_ENABLED=0 BUILD_IN_DOCKER=true DOCKER_BUILD_IMAGE=golang:1.8

# docker run -v `pwd`:/src/github.com/cloudnativelabs/kube-router -e GOPATH=`pwd`/vendor golang:1.8 go get google.golang.org/grpc
# docker run -v `pwd`:/src/github.com/cloudnativelabs/kube-router -e GOPATH=`pwd`/vendor golang:1.8 go get github.com/osrg/gobgp/gobgp/cmd

docker run -it -v `pwd`:/go/src/github.com/cloudnativelabs/kube-router -w /go/src/github.com/cloudnativelabs/kube-router -e GOARCH=arm golang make gobgp

docker build -t kube-router-arm .
docker tag kube-router-arm us.gcr.io/jeefme-185614/kube-router:v0.2.0-beta.2-3-g71d16bf4