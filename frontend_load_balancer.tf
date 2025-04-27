
module "frontend_load_balancer" {
  source      = "./modules/load_balancer"
  name        = "frontend"
  hosts       = [var.domain_app]
  bucket_id   = module.frontend_bucket.id
  bucket_name = module.frontend_bucket.domain
  cdn_enabled = true
  content_security_policy = [
    "default-src 'none'",
    "base-uri 'self'",
    "connect-src 'self' https://storage.googleapis.com https://fonts.gstatic.com",
    "font-src 'self' fonts.gstatic.com",
    "form-action 'self'",
    "frame-ancestors 'none'",
    "frame-src 'none'",
    "img-src 'self' https: data:",
    "manifest-src 'self'",
    "media-src 'self'",
    "object-src 'none'",
    "require-trusted-types-for 'script'",
    "script-src 'self'",
    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
  ]
}
