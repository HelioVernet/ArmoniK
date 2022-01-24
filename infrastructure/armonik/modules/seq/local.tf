# Node IP of seq pod
data "external" "seq_node_ip" {
  depends_on  = [kubernetes_service.seq]
  program     = ["bash", "get_node_ip.sh", "seq", var.namespace]
  working_dir = "../utils/scripts"
}

locals {
  seq_node_ip  = lookup(tomap(data.external.seq_node_ip.result), "node_ip", "")
  seq_host     = (kubernetes_service.seq.spec.0.type == "LoadBalancer" ? kubernetes_service.seq.status.0.load_balancer.0.ingress.0.ip : (kubernetes_service.seq.spec.0.type == "NodePort" && local.seq_node_ip != "" ? local.seq_node_ip : kubernetes_service.seq.spec.0.cluster_ip))
  seq_port     = (kubernetes_service.seq.spec.0.type == "NodePort" && local.seq_node_ip != "" ? kubernetes_service.seq.spec.0.port.0.node_port : kubernetes_service.seq.spec.0.port.0.port)
  seq_web_port = (kubernetes_service.seq.spec.0.type == "NodePort" && local.seq_node_ip != "" ? kubernetes_service.seq.spec.0.port.1.node_port : kubernetes_service.seq.spec.0.port.1.port)
  seq_url      = "http://${local.seq_host}:${local.seq_port}"
  seq_web_url  = "http://${local.seq_host}:${local.seq_web_port}"
}