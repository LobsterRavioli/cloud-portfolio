variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "app_service_plan_name" {
  type        = string
  description = "Nome dell'App Service Plan (usato per eseguire l'App Service)"
}

variable "client_id" {
  type        = string
  description = "Azure Client ID (appId dello SP)"
}

variable "client_secret" {
  type        = string
  description = "Azure Client Secret (password dello SP)"
  sensitive   = true
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

variable "resource_group_name" {
  type        = string
  description = "Nome del Resource Group dove saranno create le risorse"
}

variable "location" {
  type        = string
  description = "Regione Azure (es: westeurope, eastus, etc.)"
}

variable "container_image_name" {
  type        = string
  description = "Nome completo dell'immagine Docker nel registry (es: docker.io/toms1/flask-healthcheck-backend:latest)"
}

variable "app_service_name" {
  type        = string
  description = "Nome dell'App Service (l'applicazione web in esecuzione)"
}


variable "environment" {
  description = "Ambiente di deploy (es. dev, prod)"
  default     = "dev"
}