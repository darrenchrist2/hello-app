pipeline {
    agent any

    environment {
        IMAGE_NAME = "darren13/hello-app"
        TAG = "v${env.BUILD_NUMBER}"  // Menggunakan BUILD_NUMBER untuk tag unik per build
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
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-cred-id',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        bat "echo Logging in to DockerHub..."
                        bat "docker login -u %DOCKER_USER% -p %DOCKER_PASS%"
                        bat "docker push ${IMAGE_NAME}:${TAG}"  // Push dengan tag unik
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Update tag image secara dinamis di deployment.yaml (Windows-safe)
                    def deploymentFile = 'k8s/deployment.yaml'
                    def content = readFile(deploymentFile)
                    content = content.replaceAll(/image: darren13\/hello-app:.*/, "image: darren13/hello-app:${TAG}")
                    writeFile(file: deploymentFile, text: content)
                    // Deploy ke Kubernetes
                    withKubeConfig([credentialsId: 'kubeconfig-credential-id']) {
                        bat 'kubectl apply -f k8s/deployment.yaml'
                        bat 'kubectl apply -f k8s/service.yaml'
                    }
                }
            }
        }
    }
}
