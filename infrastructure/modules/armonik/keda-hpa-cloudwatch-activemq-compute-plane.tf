resource "helm_release" "keda_hpa_cloudwatch_activemq_compute_plane" {
  count      = length(var.compute_plane)
  name       = "hpa-cloudwatch-${var.compute_plane[count.index].name}"
  namespace  = var.namespace
  chart      = "keda-hpa-cloudwatch-activemq"
  repository = "${path.module}/charts"
  version    = "0.1.0"

  dynamic set {
    for_each = flatten(concat(local.hpa_common_parameters[count.index], local.hpa_cloudwtach_parameters[count.index]))
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}