terraform {
  backend "s3" {
    bucket = "peer-star-infra"
    key    = "tf/terraform.tfstate"
    region = "us-east-1"
  }
}

variable "heroku_api_key" {}

provider "heroku" {
  email   = "infra-accounts@protocol.ai"
  api_key = "${var.heroku_api_key}"
}

module "peer-pad-pinner" {
  source  = "./pinner"
  name = "peer-pad-pinner"
  swarm_address = "/dns4/ws-star1.par.dwebops.pub/tcp/443/wss/p2p-websocket-star"
  app_name = "peer-pad/2"
}

# TODO pending right values
# https://github.com/protocol/infra/issues/407
# module "discussify-pinner" {
#   source  = "./pinner"
#   name = "discussify-pinner"
#   swarm_address = "/dns4/ws-star1.par.dwebops.pub/tcp/443/wss/p2p-websocket-star"
#   app_name = "discussify"
# }
