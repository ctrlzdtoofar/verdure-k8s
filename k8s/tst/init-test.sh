#!/usr/bin/env sh

./init-test-secrets.sh

kubectl apply -f tst-postgres-pvc.yaml
kubectl apply -f tst-postgres.yaml

kubectl delete job tst-db-init-job
kubectl apply -f tst-postgres-init-job.yaml

kubectl delete service vv-admin-be-cluster-ip
kubectl delete service verdure-be-cluster-ip

kubectl delete deployment verdure-be-deployment
kubectl delete deployment vv-admin-deployment

kubectl apply -f ys.yaml
kubectl apply -f verdure.yaml
kubectl apply -f vv-admin.yaml
kubectl apply -f ingress.yaml

pkill -f "kubectl port-forward"
nohup kubectl port-forward service/tst-postgres-cluster-ip-service 5433:5433 > tst-port-forward.log 2>&1 &
