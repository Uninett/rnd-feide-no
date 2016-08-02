# rnd.feide.no

A blog about identity, technology etc.

This repository holds the `Dockerfile` building the blog environment, as well as kubernetes config files, and build and deployment scripts.

## Initial setup

Setting up rnd.feide.on on Google Container Engine.

```
kubectl create --namespace production -f etc-kube/secrets.yaml
kubectl create --namespace production -f etc-kube/deployment.json
kubectl create --namespace production -f etc-kube/service.json
kubectl create --namespace production -f etc-kube/ingress-ssl.yaml
kubectl create --namespace production -f etc-kube/ingress.yaml
```



```
kubectl --namespace production get pods
kubectl --namespace production get ing
kubectl --namespace production describe ingress uninett-ingress

kubectl --namespace production logs -f feidernd-2511762231-jl76h

Update ingress
kubectl --namespace production replace -f etc-kube/ingress.yaml
```
