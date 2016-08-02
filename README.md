# rnd.feide.no

A blog about identity, technology etc.

This repository holds the `Dockerfile` building the blog environment, as well as kubernetes config files, and build and deployment scripts.

## Initial setup

Setting up rnd.feide.on on Google Container Engine.

```
kubectl create -f etc-kube/deployment.json
kubectl create -f etc-kube/service.yaml
kubectl create -f etc-kube/ingress.yaml
```
