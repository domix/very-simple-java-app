pipeline {
  agent any
  stages {
    stage('build') {
      steps { 
        withCredentials([
          [$class: 'UsernamePasswordMultiBinding',
            credentialsId: 'docker_registry_domix',
            usernameVariable: 'CONTAINER_REGISTRY_USERNAME',
            passwordVariable: 'CONTAINER_REGISTRY_PASSWORD']
          ]) {
            sh './buildImage.sh'
            //sh './gradlew pushImage'
            sh 'echo Hola'
          }
        }
      }
      stage ('Deploy on production') {
          //agent {label 'slave01'}
          steps {
            timeout (time: 2, unit: 'MINUTES') {
              //input message
              input message : 'Approve PRODUCTION environment?'
            }
            sh 'echo Apribacion a produccion  '
          }
          post {
            success {
              echo 'Deployment on PRODUCTION is successful'
            }
            failure {
              echo 'Deployment failure on PRODUCTION'
            }
          }
        }
      /*stage('deploy') {
        steps {
          withCredentials([
            file(credentialsId: 'minikube', variable: 'KUBECONFIG'),
            file(credentialsId: 'minikube_ca', variable: 'CA'),
            file(credentialsId: 'minikube_cert', variable: 'CERT'),
            file(credentialsId: 'minikube_key', variable: 'KEY')
          ]) {
            sh './k8s_deploy.sh'
          }
        }
      }*/
    }
}