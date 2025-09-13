resource "helm_release" "karpenter" {
  count      = var.enabled ? 1 : 0
  name       = var.helm_chart_name
  repository = var.helm_chart_repo

  chart      = var.helm_chart_release_name
  version    = var.karpenter_version
  namespace  = var.namespace

  values = [
    templatefile("${path.module}/values.yml", {
      NODEGROUP = var.nodegroup_name
    })
  ]  

  set {
    name  = "settings.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.clusterEndpoint"
    value = var.eks_cluster_endpoint
  }

  set {
    name  = "settings.interruptionQueueName"
    value = "${var.cluster_name}-karpenter-interruption"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = var.service_account_name
  }

  set {
    name  = "controller.replicas"
    value = "1"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_controller.arn
  }

  depends_on = [aws_iam_role.karpenter_controller]

}



resource "kubectl_manifest" "karpenter_crd_provisioners" {
  yaml_body = file("${path.module}/crds/provisioners.yaml")
}

resource "kubectl_manifest" "ec2nodeclass" {
  yaml_body = templatefile("${path.module}/ec2nodeclass.yaml.tpl", {
    name         = var.ec2nodeclass_name
    cluster_name = var.cluster_name
    node_role    = "KarpenterNodeRole-${var.cluster_name}"
  })
  depends_on = [helm_release.karpenter]
}

resource "kubectl_manifest" "nodepool" {
  yaml_body = templatefile("${path.module}/nodepool.yaml.tpl", {
    name         = var.nodepool_name
    ec2nodeclass_ref = var.ec2nodeclass_name
  })

  depends_on = [kubectl_manifest.ec2nodeclass]
}
