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
$ kustomize build manifests/infra/ingress-controller/base | kubectl apply -f -
```

`/etc/hosts`

```
127.0.0.1 argocd.local.com
127.0.0.1 grafana.local.com
```

## Install Prometheus + Grafana with Operator (Optional)

use [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus)

```
$ kustomize build manifests/infra/prometheus-operator/overlays/local | k create -f -
```

## Install ArgoCD (Optional)

```
$  kustomize build manifests/infra/argocd/base | k apply -f -
```

argocd-ui default user is `admin`, get password execute below command

```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```