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
git clone git@github.com:ureuzy/my_local_cluster_setup.git
```

# Boot Cluster

```
$ kind create cluster --config kind/cluster.yaml
```

# Setup


## Install Nginx Ingress Controller

```
$ kustomize build manifests/init/ingress-controller/base | kubectl apply -f -
```

wait up for controller

```
$ kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```  

## Install ArgoCD

```
$ kustomize build manifests/init/argocd/base | k apply -f -
```

wait up for argo-server

```
kubectl wait --namespace argocd \
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


## Monitoring

### Install Prometheus

`/etc/hosts`

```
127.0.0.1 prometheus.local.com
```

```
$ kubectl apply -f manifests/argo-apps/prometheus/application.yaml
```

### Install Grafana

`/etc/hosts`

```
127.0.0.1 grafana.local.com
```

```
$ kubectl apply -f manifests/argo-apps/grafana/application.yaml
```

### Install loki-stack

```
$ kubectl apply -f manifests/argo-apps/loki-stack/application.yaml
```