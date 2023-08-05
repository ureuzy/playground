# Playground

My k8s cluster playground

# Preparation

Install tools

- [Install Docker](https://www.docker.com/) 
- [Install kind](https://kind.sigs.k8s.io/)
- [Install kubectl](https://kubernetes.io/ja/docs/tasks/tools/install-kubectl/)
- [Install argocd](https://argo-cd.readthedocs.io/en/stable/cli_installation/)


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
$ kubectl kustomize manifests/ingress-controller/nginx/base | kubectl apply -f -
```

wait up for controller

```
$ kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```


# Setup ArgoCD

```
$ kubectl kustomize manifests/argocd/base | kubectl apply -f -
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
127.0.0.1 argocd.local
```

argocd-ui default user is `admin`, get password execute below command

```
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Login with argo cli and add the repository to be synchronized

```
ARGO_PASS=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
argocd login argocd.local --insecure --username admin --password ${ARGO_PASS} --insecure
argocd repo add https://github.com/ureuzy/playground.git --project default
```

## Install all templates

```
$ kubectl apply -f manifests/argocd/applications.yaml
```

`/etc/hosts`

```
127.0.0.1 prometheus.local
127.0.0.1 grafana.local
```
