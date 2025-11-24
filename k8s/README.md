# TaskFlow Kubernetes Deployment

## Prerequisites
- Kubernetes cluster (minikube or Docker Desktop)
- Docker images built

## Deploy

```bash
# Build images (for minikube users)
eval $(minikube docker-env)
docker build -t taskflow-backend:1.0.0 ./backend
docker build -t taskflow-frontend:1.0.0 ./frontend

# Deploy to Kubernetes
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/mongodb.yaml
kubectl apply -f k8s/backend.yaml
kubectl apply -f k8s/frontend.yaml

# Verify
kubectl get all -n taskflow
```

## Access Application

```bash
# Minikube
minikube service frontend-service -n taskflow --url

# Or port-forward
kubectl port-forward -n taskflow service/frontend-service 8080:80
```

## Useful Commands

```bash
# View pods
kubectl get pods -n taskflow

# View logs
kubectl logs -n taskflow -l app=backend

# Scale deployment
kubectl scale deployment backend --replicas=5 -n taskflow

# Delete everything
kubectl delete namespace taskflow
