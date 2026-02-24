discovery.kubernetes "pods" {
  role = "pod"
}

prometheus.scrape "kubernetes" {
  targets = discovery.kubernetes.pods.targets
  forward_to = [prometheus.remote_write.vm.receiver]
}

prometheus.remote_write "vm" {
  endpoint {
    url = "http://victoria-metrics-server.monitoring.svc.cluster.local:8428/api/v1/write"
  }
}