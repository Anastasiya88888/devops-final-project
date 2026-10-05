terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "todoapp_network" {
  name = "${var.container_name}_network"
}

resource "docker_image" "todoapp_image" {
  name = var.docker_image
}

resource "docker_container" "todoapp" {
  name  = var.container_name
  image = docker_image.todoapp_image.image_id

  env = [
    "DB_HOST=${var.container_name}-db",
    "DB_USER=postgres",
    "DB_PASSWORD=postgres",
    "DB_NAME=tododb"
  ]

  ports {
    internal = 3000
    external = var.app_port
  }

  networks_advanced {
    name = docker_network.todoapp_network.name
  }

  depends_on = [docker_container.todoapp_db]
}

resource "docker_image" "postgres_image" {
  name = "postgres:15"
}

resource "docker_container" "todoapp_db" {
  name  = "${var.container_name}-db"
  image = docker_image.postgres_image.image_id

  env = [
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=postgres",
    "POSTGRES_DB=tododb"
  ]

  networks_advanced {
    name = docker_network.todoapp_network.name
  }
}
