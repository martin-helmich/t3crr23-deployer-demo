terraform {
  required_providers {
    mittwald = {
      source = "registry.terraform.io/mittwald/mittwald"
    }
  }
}

provider "mittwald" {}

variable "server_id" {
    type = string
}

variable "database_password" {
    type = string
    sensitive = true
}

resource "mittwald_project" "t3crr_demo" {
    description = "T3CRR Demo"
    server_id = var.server_id
}

resource "mittwald_mysql_database" "t3crr_demo" {
    project_id = mittwald_project.t3crr_demo.id
    version = "8.0"
    description = "T3CRR Demo"

    character_settings = {
        character_set = "utf8mb4"
        collation = "utf8mb4_general_ci"
    }

    user = {
        access_level = "full"
        password = var.database_password
        external_access = false
    }
}

resource "mittwald_app" "t3crr_demo" {
    project_id = mittwald_project.t3crr_demo.id
    database_id = mittwald_mysql_database.t3crr_demo.id

    app = "php"
    version = "1.0.0"

    description = "T3CRR Demo"
    document_root = "/public"
    update_policy = "none"

    dependencies = {
        "php" = {
            version = "8.2.8"
            update_policy = "patchLevel"
        }
        "composer" = {
            update_policy = "patchLevel"
            version       = "2.3.10"
        },
        "mysql" = {
            update_policy = "patchLevel"
            version       = "8.0.28"
        },
    }

}