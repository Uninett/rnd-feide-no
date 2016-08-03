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


Setup testing:

```
kubectl create --namespace production -f etc-kube/secrets-testing.yaml
kubectl create --namespace production -f etc-kube/deployment-testing.json
kubectl create --namespace production -f etc-kube/service-testing.json
kubectl create --namespace production -f etc-kube/ingress-testing.yaml
```

### Setting up firewall on GKE_SERVICE_TOKEN

```
export TAG=$(gcloud compute instances describe $NODE --format="value(tags.items[0])")
export NODE_PORT=$(kubectl --namespace production get -o jsonpath="{.spec.ports[0].nodePort}" services feidernd-testing)
gcloud compute firewall-rules create feidernd-testing-allow-130-211-0-0-22 --source-ranges 130.211.0.0/22 --target-tags $TAG --allow tcp:$NODE_PORT


export NODE_PORTP=$(kubectl --namespace production get -o jsonpath="{.spec.ports[0].nodePort}" services feidernd)
gcloud compute firewall-rules create feidernd-allow-130-211-0-0-22 --source-ranges 130.211.0.0/22 --target-tags $TAG --allow tcp:$NODE_PORTP
```


## Perform deployment configuration updates

Comit changes to test in master branch.

When verified:

```
git checkout stable && git merge master
git push
```

----


Create service account: (not used yet)
```
kubectl --namespace production create -f etc-kube/serviceAccount.yaml
```


```
kubectl --namespace production get pods
kubectl --namespace production get ing
kubectl --namespace production describe ingress uninett-ingress

kubectl --namespace production logs -f feidernd-2511762231-jl76h

Update ingress
kubectl --namespace production replace -f etc-kube/ingress.yaml
```


Get service account:

```
kubectl --namespace production get serviceaccounts/circleci -o yaml
kubectl --namespace production get secrets/circleci-token-e78a4 -o yaml
```
