
##########################################
##### TLS SSL Certificates for HTTPS #####
##########################################

# TLS SSL Cipher Policy
# https://console.cloud.google.com/net-services/ssl-policies/list
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ssl_policy
# See Also: google_compute_region_ssl_policy
resource "google_compute_ssl_policy" "lb" {
  name            = "tf-lb-${var.name}-tls-ssl-policy"
  min_tls_version = "TLS_1_2"
  profile         = "CUSTOM"
  custom_features = [
    "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
    "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
    "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256",
    "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
    "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
    "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256",
  ]
}

# TLS SSL Certificate
# https://console.cloud.google.com/security/ccm/list/lbCertificates
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate
# See Also: google_compute_region_ssl_certificate
resource "google_compute_managed_ssl_certificate" "lb" {
  name = replace("tf-lb-${var.name}-tls-ssl-certs", ".", "-")
  managed {
    domains = var.hosts
  }
}
