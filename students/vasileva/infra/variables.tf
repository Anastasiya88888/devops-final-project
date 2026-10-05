variable "docker_image" {
  description = "Docker image to deploy"
  type        = string
  default     = "anastaisha/todoapp:latest"
}

variable "container_name" {
  description = "Name of the deployed container"
  type        = string
  default     = "todoapp"
}

variable "app_port" {
  description = "External port to expose the app on"
  type        = number
  default     = 3000
}
