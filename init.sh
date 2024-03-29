# Setup ArgoCD
helm install -n argocd argocd argo/argo-cd --create-namespace

kubectl wait --namespace argocd \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/name=argocd-server \
  --timeout=120s

sleep 10

ARGO_PASS=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
argocd login localhost:8080 --insecure --username admin --password ${ARGO_PASS} --insecure --grpc-web
argocd repo add https://github.com/ureuzy/playground.git --project default --grpc-web

# Install Argo Apps
kubectl apply -f applications.yaml

