#!/bin/sh

set -e

ROOT_DIR=$(git rev-parse --show-toplevel)

# create namespace
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: logiq
EOF

# set kubectl namespace
kubectl config set-context --current --namespace=logiq

# deploy logiq 
kubectl apply -f "$ROOT_DIR"/stacks/logiq/yaml/logiq.yaml

# ensure services are running
kubectl rollout status -w deployment/coffee-worker
kubectl rollout status -w deployment/coffee-server
kubectl rollout status -w deployment/beetle-worker
kubectl rollout status -w deployment/beetle-coordinator
kubectl rollout status -w deployment/pithos
kubectl rollout status -w deployment/logiq-kubernetes-ingress
kubectl rollout status -w deployment/logiq-kubernetes-ingress-backend
kubectl rollout status -w statefulset/flash-discovery
kubectl rollout status -w statefulset/logiq-flash
kubectl rollout status -w statefulset/postgres
kubectl rollout status -w statefulset/redis-master
kubectl rollout status -w statefulset/redis-slave
