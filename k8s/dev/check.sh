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
kubectl logs job/db-init-job
kubectl logs translator-deployment-5f547fb789-6zp68 --previous

nohup kubectl port-forward service/postgres-cluster-ip-service 5432:5432 > port-forward.log 2>&1 &
nohup kubectl port-forward service/tst-postgres-cluster-ip-service 5433:5433 > port-forward.log 2>&1 &

# to turn off port forwarding:
ps -ef | grep kubectl
# kill -9 <pid>

# Rolling restarts
kubectl rollout restart deployment palabras-be-deployment
kubectl rollout restart deployment translator-deployment

# delete
# kubectl config delete-context minikube
kubectl delete deployment ys-deployment
kubectl delete deployment postgres-deployment

kubectl delete deployment tst-postgres-deployment
kubectl delete service tst-postgres-cluster-ip-service
kubectl delete job tst-db-init-job

kubectl delete deployment palabras-be-deployment
kubectl delete deployment translator-deployment
kubectl delete pod ys-pod
kubectl delete pvc database-persistent-volume-claim

kubectl service ys-test

