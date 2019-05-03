pipeline {
  agent any
  stages {
    stage('build') {
      steps { 
        sh './buildImage.sh'
      }
    }

    stage('Quality Analysis') {
      parallel {
        stage ('Integration Test') {
          agent any
          steps {
            echo 'Run integration tests here...'
          }
        }
        stage('Sonar Scan') {
          steps {
            sh 'echo Publicando reportes a Sonar'
          }
        }
      }
    }
    stage('push') {
      steps {
        script {
          env.RELEASE_SCOPE = input message: 'User input required', ok: 'Release!',
          parameters: [choice(name: 'RELEASE_SCOPE', choices: 'patch\nminor\nmajor', description: 'What is the release scope?')]
        }
        echo "scope ${env.RELEASE_SCOPE}"
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker_registry_domix', usernameVariable: 'CONTAINER_REGISTRY_USERNAME', passwordVariable: 'CONTAINER_REGISTRY_PASSWORD']]) {
          //sh './gradlew pushImage'
          sh 'echo Publicación de la imagen en Container Registry'
        }
      }
    }
    stage('develop') {
      when {
        branch "develop"
      }
      steps {
        sh 'echo Generar paquete para Develop'
      }
    }
    stage ('Deploy on production') {
      steps {
        //Con este timeout, si no se da una respuesta en el tiempo definido.
        //Se aborta la ejecución
        timeout (time: 1, unit: 'MINUTES') {
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