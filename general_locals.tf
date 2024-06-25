
locals {
  # DELETE, ABANDON, and sometimes DISABLE
  deletion_policy = var.deletion_protection == true ? "ABANDON" : "DELETE"
}
