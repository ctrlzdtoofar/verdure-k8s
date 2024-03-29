#!/usr/bin/env sh

kubectl apply -f ys.yaml
kubectl apply -f postgres-pvc.yaml
kubectl apply -f postgres.yaml
kubectl apply -f postgres-init-job.yaml

kubectl apply -f palabras.yaml
kubectl apply -f translator.yaml

