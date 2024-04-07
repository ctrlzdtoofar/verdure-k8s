#!/usr/bin/env sh

kubectl apply -f ys.yaml

kubectl apply -f palabras.yaml
kubectl apply -f translator.yaml

kubectl apply -f ingress.yaml

kubectl apply -f tst-postgres-pvc.yaml
kubectl apply -f tst-postgres.yaml
kubectl apply -f tst-postgres-init-job.yaml
