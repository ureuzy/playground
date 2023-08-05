# Setup Nginx ingress controller
kubectl kustomize manifests/ingress-controller/nginx/base | kubectl apply -f -

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# Setup ArgoCD
kubectl kustomize manifests/argocd/base | kubectl apply -f -

kubectl wait --namespace argocd \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/name=argocd-server \
  --timeout=120s

sleep 10

ARGO_PASS=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
argocd login argocd.local --insecure --username admin --password ${ARGO_PASS} --insecure --grpc-web
argocd repo add https://github.com/ureuzy/playground.git --project default --grpc-web

# Install Argo Apps
kubectl apply -f manifests/argocd/applications.yaml

