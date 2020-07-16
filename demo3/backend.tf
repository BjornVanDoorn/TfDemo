terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "webinar"

    workspaces {
      name = "demo"
    }
  }
}
