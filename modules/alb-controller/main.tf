resource "kubernetes_service_account_v1" "alb_sa" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.service_account_name      # "aws-load-balancer-controller"
    namespace = var.namespace                 # "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.kubernetes_alb_controller[0].arn
    }
    labels = {
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }
  }
}


resource "helm_release" "alb_controller" {
  count = var.enabled ? 1 : 0

  # Garante ordem: IRSA + SA antes do Helm
  depends_on = [
    aws_iam_role_policy_attachment.kubernetes_alb_controller,
    kubernetes_service_account_v1.alb_sa,
  ]

  name       = var.helm_chart_name                 # "aws-load-balancer-controller"
  chart      = var.helm_chart_release_name         # "aws-load-balancer-controller"
  repository = var.helm_chart_repo                 # "https://aws.github.io/eks-charts"
  version    = var.alb_version                     # sua versão do chart
  namespace  = var.namespace                       # "kube-system"

  values = [yamlencode({
    clusterName = var.cluster_name                 # ex.: "cluster-prd"
    ingressClass = "alb"



    rbac = {
      create = true
    }

    serviceAccount = {
      create = false                               
      name   = var.service_account_name

    }

    enableServiceMutatorWebhook = false
  })]
}
