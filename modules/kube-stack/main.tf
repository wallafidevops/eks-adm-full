

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.kube_stack_version
  namespace  = "monitoring"
  create_namespace = true

  values = [
    file("modules/kube-stack/values.yaml")
  ]
}

