#!/bin/sh

#helm is used to install ingress-nginx
# be sure to not install nginx-ingress, it is the wrong tech

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx
