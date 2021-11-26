locals {

}
variable bigip_username{}
variable bigip_password{}
variable bigip_private_address {}
variable bigip_external_address{}
variable bigip_management_address{}
variable bigip_k8s_partition{}
variable bigip_tunnel_name{}
#variable bigip_tunnel_mac{}
variable bigip_tunnel_overlay_address{}
variable bigip_default_gateway_address{}
variable bigip_internal_gateway_address{}
variable cidr{}
variable nameserver{}
variable k8s_podsubnet{}
variable infra_private_key{}
variable infra_private_key_path{}
variable k8s_controller_address{}
variable k8s_controller_username{}

resource null_resource cis_init {
  # copy base manifests for CIS to the controller
  provisioner "file" {
    source      = "${path.module}/cismanifests"
    destination = "/home/ubuntu"
  }
  # copy the values manifest for the CIS helm chart to the controller
  provisioner "file" {
    content = templatefile("${path.module}/templates/values.yaml.tmpl",
    { 
      bigip_private_address = var.bigip_private_address
      bigip_k8s_partition   = var.bigip_k8s_partition
    })
    destination = "/home/ubuntu/cismanifests/value.yaml"
  }
  # copy the CIS deployment manifest to the controller
  # this is a duplicate of what the helm chart does and so
  # I should make up my mind
  provisioner "file" {
    content = templatefile("${path.module}/templates/f5-cis-deployment.yaml.tmpl",
    { 
      bigip_private_address = var.bigip_private_address
      bigip_k8s_partition   = var.bigip_k8s_partition
    })
    destination = "/home/ubuntu/cismanifests/f5-cis-deployment.yaml"
  }
  # copy the manifest to add the BIG-IP as a node to the cluster
  provisioner "file" {
    content = templatefile("${path.module}/templates/bigip-node.yaml",
    { 
      bigip-internal   = var.bigip_private_address
      bigip-tunnel-mac = data.external.tunnelmac.result.mac
      podsubnet        = var.k8s_podsubnet
    })
    destination = "/home/ubuntu/cismanifests/bigip-node.yaml"
  }

  # Setup CIS in the cluster
  # 1. create the secret containing the BIG-IP credentials
  # 2. create the service account for use by the CIS controller
  # 3. bind the service account to the cluster-admin role
  # 4. setup the bigip cluster role
  # 5. load the custom resource definitions required by CIS
  # 6. install CIS
  # 7. add the BIG-IP as a node to the cluster
  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "kubectl create secret generic bigip-login -n kube-system --from-literal=username=${var.bigip_username} --from-literal=password=${var.bigip_password}",
      "kubectl create serviceaccount bigip-ctlr -n kube-system",
      "kubectl create clusterrolebinding k8s-bigip-ctlr-clusteradmin --clusterrole=cluster-admin --serviceaccount=kube-system:k8s-bigip-ctlr",
      "kubectl create -f /home/ubuntu/cismanifests/bigip-ctlr-clusterrole.yaml",
      "kubectl create -f /home/ubuntu/cismanifests/cis-customresourcedefinition.yaml",
      "helm repo add f5-stable https://f5networks.github.io/charts/stable",
      "helm install -f /home/ubuntu/cismanifests/value.yaml f5-stable/f5-bigip-ctlr --generate-name",
      "kubectl create -f /home/ubuntu/cismanifests/bigip-node.yaml"
      ]
  }
  connection {
    host = var.k8s_controller_address
    type = "ssh"
    user = var.k8s_controller_username
    private_key = var.infra_private_key
  }
}

# use Declarative Onboarding to setup selfips and vxlan tunnel
# requirements for CIS
module "postbuild-config-do" {
  source           = "github.com/mjmenger/terraform-bigip-postbuild-config//do?ref=v0.5.1"
  bigip_user       = var.bigip_username
  bigip_password   = var.bigip_password
  bigip_address    = var.bigip_management_address
  bigip_do_payload = templatefile("${path.module}/templates/do.json",
      { 
        nameserver               = var.nameserver,
        tunnel_name              = var.bigip_tunnel_name,
        internal_self            = var.bigip_private_address
        internal_remote_self     = "0.0.0.0",
        external_self            = var.bigip_external_address
        tunnel_overlay_address   = var.bigip_tunnel_overlay_address
        default_gateway_address  = var.bigip_default_gateway_address
        internal_gateway_address = var.bigip_internal_gateway_address
        network_cidr             = var.cidr
        bigip_k8s_partition      = var.bigip_k8s_partition
      }
  )
}

# setup the partition expected by CIS
module "postbuild-config-as3" {
  source            = "github.com/mjmenger/terraform-bigip-postbuild-config//as3?ref=v0.5.1"
  bigip_user        = var.bigip_username
  bigip_password    = var.bigip_password
  bigip_address     = var.bigip_management_address
  bigip_as3_payload = templatefile("${path.module}/templates/as3.json",
      { 
        bigip_k8s_partition      = var.bigip_k8s_partition
      }
  )
  depends_on = [
    module.postbuild-config-do
  ]
}

# retrieve the MAC address of the tunnel interface 
# on the BIG-IP
data external tunnelmac {
    program = ["bash", "${path.module}/tunnel_mac.sh"]
    query = {
        bigip_address = var.bigip_management_address
        bigip_user    = var.bigip_username
        sshkeypath    = var.infra_private_key_path
        tunnel_name   = var.bigip_tunnel_name
    }

    depends_on = [
      module.postbuild-config-do
    ]
}

output tunnelmac {
    value = data.external.tunnelmac.result
}