# Expensy CI/CD Pipeline

This GitHub Actions workflow automatically builds Docker images for the frontend and backend, pushes them to Docker Hub, and deploys the Kubernetes manifests to an AWS EKS cluster.

---

## Workflow Trigger

- Runs on every push to the `main` branch.

---

## Environment Variables and Secrets

Make sure to add the following GitHub Secrets in your repository settings:

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION` (e.g., `eu-north-1`)

---

## What this workflow does

1. Checks out the repository.
2. Sets up Node.js (version 20) for dependency resolution.
3. Logs in to Docker Hub using provided secrets.
4. Builds Docker images for:
   - Frontend (`./expensy_frontend`)
   - Backend (`./expensy_backend`)
5. Pushes both Docker images to Docker Hub.
6. Configures AWS credentials for deployment.
7. Configures `kubectl` to connect to the EKS cluster `marline-expensy-cluster`.
8. Deploys Kubernetes manifests from the `k8s/` directory:
   - mongo.yaml
   - redis.yaml
   - backend.yaml
   - frontend.yaml
   - ingress.yaml

---

## Usage

Simply push to the `main` branch and the workflow will trigger automatically.

---

## Kubernetes manifests location

All Kubernetes YAML files must be placed inside the `k8s/` folder at the root of the repository.
