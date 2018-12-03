variable "name" {}
variable "swarm_address" {}
variable "app_name" {}

resource "heroku_app" "pinner" {
  name   = "${var.name}"
  region = "us"
  acm = true

  config_vars {
    PEER_STAR_SWARM_ADDRESS = "${var.swarm_address}"
    PEER_STAR_APP_NAME = "${var.app_name}"
  }
}
