pipeline {
  agent any
  //Opciones generales del proceso
  options {
    //Si por alguna razón se queda atorado. Se abortara en una hora.
    timeout(time: 1, unit: 'HOURS') 
  }
  stages {
    stage('build') {
      //Puedo establecer variables de ambiente
      environment {
        //AN_ACCESS_KEY = credentials('id-de-la-credencial')
        DEMO_KEY = 'foo_bar'
      }
      steps { 
        sh 'echo $DEMO_KEY'
        sh './buildImage.sh'
      }
    }

    stage('Quality Analysis') {
      //Podemos ejecutar tareas en paralelo
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
      //Este stage solo se ejecutará si cumple la condición definida.
      when {
        //En este caso, solo si el branch se llama develop
        branch "develop"
        //Pero podria ser un tag.
        //buildingTag()
      }
      steps {
        sh 'echo Generar paquete para Develop'
      }
    }
    stage('Branch') {
      //En cualquier otro branch diferente de master
      when { not { branch 'master' } }
      
      parallel {
        stage('paso 1') {
          steps {
            sh './gradlew clean classes'
          }
        }
        stage('paso 2') {
          steps {
            sh 'echo En paralelo esta tarea'
          }
        }
      }
      
    }
    stage ('En un PullRequest') {
      when { changeRequest target: 'master' }
      steps {
        sh 'Esto es un pull PullRequest. Bienvenidas contribuciones'
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