# My Local Cluster Setup

## Preparation

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


# Deploy Nginx Ingress Controller

```
$ kustomize build manifests/infra/ingress-controller/base | kubectl apply -f -
```

Deploy test resources

```
$ kustomize build manifests/infra/ingress/base | kubectl apply -f -
```


```
curl -I http://localhost                                                                                       ?main
HTTP/1.1 200 OK
Date: Sat, 10 Sep 2022 23:31:40 GMT
Content-Type: text/html
Content-Length: 615
Connection: keep-alive
Last-Modified: Tue, 19 Jul 2022 14:05:27 GMT
ETag: "62d6ba27-267"
Accept-Ranges: bytes
```

# Install Prometheus Operator

use [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus)

```
The CustomResourceDefinition "prometheuses.monitoring.coreos.com" is invalid: metadata.annotations: Too long: must have at most 262144 bytes
```

```
$ kustomize build manifests/infra/prometheus-operator-setup/base | k create -f -
```

```
$ kubectl wait \
	--for condition=Established \
	--all CustomResourceDefinition \
	--namespace=monitoring
```    

```
$ kustomize build manifests/infra/prometheus-operator/overlays/local | k apply -f -
```