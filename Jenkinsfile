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
            timeout(time: 5, unit: "MINUTES") {
              def userInput = input message: '¿Quieres crear la imagen de Docker?', ok: 'No'

              println userInput.dump()
            }
            //sh './gradlew pushImage'
            //sh 'echo Hola'
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