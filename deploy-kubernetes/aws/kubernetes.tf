terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}


provider "kubernetes" {
   config_path = "/home/pouellet/.kube/config"
}

resource "kubernetes_service" "flask" {
  metadata {
    name = "flask-app-service"
  }
  spec {
    selector = {
      App = kubernetes_deployment.flask.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 8079
      target_port = 8079
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "flask" {
  metadata {
    name = "flask-app-deployment"
    labels = {
      App = "ScalableFlaskApp"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        App = "ScalableFlaskApp"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableFlaskApp"
        }
      }
      spec {
        container {
          image = "pouellette123/flask-app-c2:latest"
          name  = "flask-app-c2"

          port {
            container_port = 8079
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

