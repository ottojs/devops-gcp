
# External IP Address for Load Balancers
# You probably could add another if needed for redundancy
# https://console.cloud.google.com/networking/addresses/list
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address
# See Also: google_compute_address
resource "google_compute_global_address" "net_ipv4_a" {
  name         = "tf-net-ipv4-a"
  address_type = "EXTERNAL"
}
