# Playground

My k8s cluster playground

# Preparation

Install tools

- [Install Docker](https://www.docker.com/) 
- [Install kind](https://kind.sigs.k8s.io/)
- [Install kubectl](https://kubernetes.io/ja/docs/tasks/tools/install-kubectl/)  
- [Install kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/)


clone repository
```
$ git clone git@github.com:ureuzy/playground.git
```

# Create Cluster

```
$ kind create cluster --config kind/cluster.yaml
```

# Setup Ingress Controller

## Ingress NGINX

```
$ kustomize build manifests/ingress-controller/nginx/base | kubectl apply -f -
```

wait up for controller

```
$ kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```

## Contour

```
$ kustomize build manifests/ingress-controller/contour/base | kubectl apply -f -
```


# Setup ArgoCD

```
$ kustomize build manifests/argocd/base | k apply -f -
```

wait up for argo-server

```
$ kubectl wait --namespace argocd \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/name=argocd-server \
  --timeout=120s
```

`/etc/hosts`

```
127.0.0.1 argocd.local.com
```

argocd-ui default user is `admin`, get password execute below command

```
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Install all templates

```
$ kubectl apply -f manifests/argocd/applications.yaml
```

`/etc/hosts`

```
127.0.0.1 prometheus.local.com
127.0.0.1 grafana.local.com
```
