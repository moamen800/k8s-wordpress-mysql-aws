#!/bin/bash

# Define variables
SECRET_NAME="mysql-pass"
PASSWORD="myrootpassword"
SECRET_FILE="../k8s-yaml/MySQL-secret.yaml"

# Encode password using base64
ENCODED_PASSWORD=$(echo -n "$PASSWORD" | openssl base64)

echo "🚀 Preparing MySQL Secret file..."

# Update MySQL-secret.yaml dynamically
cat <<EOF > $SECRET_FILE
apiVersion: v1
kind: Secret
metadata:
  name: $SECRET_NAME
type: Opaque
data:
  password: $ENCODED_PASSWORD
EOF

echo "✅ Secret file '$SECRET_FILE' updated with an encoded password."

# Apply Kubernetes configurations
echo "🚀 Applying Kubernetes YAML files..."
kubectl apply -f k8s-yaml/SC.yaml
kubectl apply -f k8s-yaml/PVC.yaml
kubectl apply -f k8s-yaml/MySQL-secret.yaml
kubectl apply -f k8s-yaml/Deployment.yaml
kubectl apply -f k8s-yaml/MySQL-service.yaml 

echo "✅ MySQL deployment applied successfully!"

# Verify deployment status
echo "🔍 Checking MySQL Pod status..."
kubectl get pods
kubectl get pvc
kubectl get deployments
