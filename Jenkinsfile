pipeline {
  agent any
  stages {
    stage('build') {
      steps { 
        sh './buildImage.sh'
      }
    }
    stage('push') {
      steps { 
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker_registry_domix', usernameVariable: 'CONTAINER_REGISTRY_USERNAME', passwordVariable: 'CONTAINER_REGISTRY_PASSWORD']]) {
          //sh './gradlew pushImage'
          sh 'echo Publicación de la imagen en Container Registry'
        }
      }
    }
    stage ('Deploy on production') {
      steps {
        timeout (time: 5, unit: 'MINUTES') {
          input message : 'Despliegue en Kubernetes?'
        }
        withCredentials([
          file(credentialsId: 'minikube', variable: 'KUBECONFIG'),
          file(credentialsId: 'minikube_ca', variable: 'CA'),
          file(credentialsId: 'minikube_cert', variable: 'CERT'),
          file(credentialsId: 'minikube_key', variable: 'KEY')
          ]) {
          sh './k8s_deploy.sh'
        }
      }
      post {
        success {
          echo 'Deployment en Kubernetes is successful'
        }
        failure {
          echo 'Deployment failure en Kubernetes'
        }
      }
    }
  }
}