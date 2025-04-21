pipeline {
    agent any

    environment {
        IMAGE_NAME = "darren13/hello-app"
        TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/salvestacia/hello-app.git', branch: 'main'
            }
        }

        stage('Build Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${TAG}")
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-cred-id') {
                        docker.image("${IMAGE_NAME}:${TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig-credential-id']) {
                    sh 'kubectl apply -f k8s\\deployment.yaml'
                    sh 'kubectl apply -f k8s\\service.yaml'
                }
            }
        }
    }
}
