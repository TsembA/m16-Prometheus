
# 🧠 Kubernetes Monitoring with Prometheus, Grafana & Redis Exporter

This project demonstrates how to deploy microservices to an EKS cluster and monitor them using the Prometheus Operator stack, Grafana, Alertmanager, and Redis Exporter. It also includes CPU stress tests to trigger custom alerts.

---

## 🚀 Deploy Microservices in EKS

```bash
eksctl create cluster
kubectl create namespace monitoring
kubectl apply -f config-micro.yaml
```

---

## 📦 Deploy Prometheus Operator Stack

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring
```

---

## 📊 Access Monitoring Dashboards

### 🔸 Prometheus UI

```bash
kubectl port-forward svc/monitoring-kube-prometheus-prometheus 9090:9090 -n monitoring &
```

Access at: [http://localhost:9090](http://localhost:9090)

---

### 🔸 Grafana

```bash
kubectl port-forward svc/monitoring-grafana 8080:80 -n monitoring &
```

Access at: [http://localhost:8080](http://localhost:8080)

- **Username:** `admin`  
- **Password:** `prom-operator`

---

### 🔸 Alertmanager UI

```bash
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-alertmanager 9093:9093 &
```

Access at: [http://localhost:9093](http://localhost:9093)

---

## 🔬 Trigger CPU Alerts (Stress Test)

### Step 1: Deploy a Curl Pod (to test endpoints)

```bash
kubectl run curl-test --image=radial/busyboxplus:curl -i --tty --rm
```

### Step 2: Trigger a CPU spike

```bash
kubectl delete pod cpu-test
kubectl run cpu-test --image=containerstack/cpustress -- --cpu 4 --timeout 60s --metrics-brief
```

This will simulate high CPU load and trigger an alert if rules are configured correctly.

---

## 📡 Deploy Redis Exporter

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update

helm install redis-exporter prometheus-community/prometheus-redis-exporter -f redis-values.yaml
```

Make sure your `redis-values.yaml` includes proper target configuration for your Redis instance.

---

## 📁 Project Structure

```
.
├── config-micro.yaml                  # Microservices deployment manifest
├── prometheus-rules.yaml             # Custom PrometheusRule definitions
├── redis-values.yaml                 # Helm values for Redis exporter
└── comands.txt                        # This file

```

---

## ✅ Useful Commands

```bash
# List all Prometheus rules
kubectl get prometheusrule -n monitoring

# View active alerts
kubectl port-forward svc/monitoring-kube-prometheus-prometheus 9090:9090 -n monitoring
# Visit: http://localhost:9090/alerts
```

---

## 📌 Requirements

- eksctl
- kubectl
- Helm
- AWS CLI (for EKS auth)
- An existing EKS cluster (or provision via this guide)