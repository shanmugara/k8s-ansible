#!/bin/bash

SECRET_NAME="admin-kubeconfig"
NAMESPACE="kube-system"
KUBECONFIG_PATH="/etc/kubernetes/admin.conf"

# Check if the kubeconfig file exists
if [ ! -f "$KUBECONFIG_PATH" ]; then
    echo "Error: $KUBECONFIG_PATH does not exist!"
    exit 1
fi

# Check if the secret already exists
if kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" &>/dev/null; then
    echo "Deleting existing secret $SECRET_NAME..."
    kubectl delete secret "$SECRET_NAME" -n "$NAMESPACE" --ignore-not-found=true
    echo "Creating new secret $SECRET_NAME..."
    kubectl create secret generic "$SECRET_NAME" \
    --namespace "$NAMESPACE" \
    --from-file=kubeconfig="$KUBECONFIG_PATH"
else
    echo "Creating new secret $SECRET_NAME..."
    kubectl create secret generic "$SECRET_NAME" \
        --namespace "$NAMESPACE" \
        --from-file=kubeconfig="$KUBECONFIG_PATH"
fi

echo "Secret $SECRET_NAME updated successfully."