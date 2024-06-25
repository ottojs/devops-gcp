
##########################################
##### TLS SSL Certificates for HTTPS #####
##########################################

# TLS SSL Cipher Policy
# https://console.cloud.google.com/net-services/ssl-policies/list
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ssl_policy
# See Also: google_compute_region_ssl_policy
resource "google_compute_ssl_policy" "project" {
  name            = var.ssl_policy_name
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
resource "google_compute_managed_ssl_certificate" "cdn" {
  name = replace("cert-${var.cdn_domain}", ".", "-")
  managed {
    domains = [var.cdn_domain]
  }
}
resource "google_compute_managed_ssl_certificate" "files" {
  name = replace("cert-${var.files_domain}", ".", "-")
  managed {
    domains = [var.files_domain]
  }
}

