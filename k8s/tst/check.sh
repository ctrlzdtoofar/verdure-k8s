#!/usr/bin/env sh

kubectl config get-contexts
#kubectl config use-context docker-desktop
#kubectl config set-context --current --namespace=default

kubectl cluster-info

kubectl get deployment
kubectl get pods
kubectl get services
kubectl get secrets
kubectl get storageclass
kubectl describe storageclass
kubectl get jobs
kubectl get ingress

# View logs
kubectl logs translator-deployment-5f547fb789-6zp68 --previous

pkill -f "kubectl port-forward"
nohup kubectl port-forward service/tst-postgres-cluster-ip-service 5433:5433 > tst-port-forward.log 2>&1 &

exit 0 # don't continue by accident, it gets destructive



