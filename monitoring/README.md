# Monitoring Setup for Expensy on EKS

This README documents the complete monitoring setup implemented for the **Expensy** application running on AWS EKS. The stack includes **Prometheus**, **Grafana**, and **Loki** for full observability of metrics and logs across the application.

---

## 📦 Tools Used

| Tool                  | Purpose                                     |
| --------------------- | ------------------------------------------- |
| Prometheus            | Metrics collection                          |
| Grafana               | Metrics and log visualization               |
| kube-prometheus-stack | Unified Helm chart for Prometheus & Grafana |
| Loki                  | Centralized log aggregation                 |
| Promtail              | Agent to ship logs from pods to Loki        |
| Node Exporter         | Node-level metrics (CPU, memory, etc.)      |

---

## ✅ Features Implemented

### 📊 Metrics (Prometheus + Grafana)

- Deployed **kube-prometheus-stack** via Helm.
- Enabled metrics scraping from:
  - Kubernetes system components (kubelet, coredns, API server, etc.)
  - Application backend via `/metrics` endpoint exposed on port `8706`
  - Node-level metrics via **node-exporter**
- Created **custom Grafana dashboards** for:
  - **Backend CPU Usage** (from `process_cpu_user_seconds_total`)
  - **Total HTTP Requests** (from `http_requests_total`)
  - **HTTP Error Rate** (4xx/5xx status codes)
- Saved dashboards in JSON format in `/monitoring/dashboards/`

### 🛠️ Configuration Files

- **ServiceMonitor** created to scrape backend metrics
- Frontend removed from metrics collection as per updated project scope
- Prometheus targets confirmed active via `/targets` UI
- Used port `8706` to expose metrics from backend containers

---

## 📉 Grafana Dashboards

- Exported JSON versions committed for reproducibility

# Add Prometheus & Grafana via Helm

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring -f monitoring/kube-prometheus-stack-values.yaml

# Install Loki and Promtail

helm repo add grafana https://grafana.github.io/helm-charts
helm upgrade --install loki grafana/loki-stack -n monitoring --set promtail.enabled=true

# Apply custom ServiceMonitor

kubectl apply -f k8s/monitoring/service-monitor.yaml
