pipeline {
    agent any

    environment {
        IMAGE_NAME = "darren13/hello-app"
        TAG = "v${env.BUILD_NUMBER}"  // Tag unik per build
        CONTAINER_NAME = "hello-app-test-container"
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

        stage('Test App') {
            steps {
                script {
                    try {
                        // Jalankan container untuk testing
                        bat "docker run -d --name ${CONTAINER_NAME} -p 3000:3000 ${IMAGE_NAME}:${TAG}"
                        
                        // Tunggu sebentar agar container siap
                        sleep(time: 5, unit: 'SECONDS')

                        // Lakukan request ke localhost dan periksa responsnya
                        def response = bat(script: 'curl -s http://localhost:3000', returnStdout: true).trim()
                        
                        echo "Response from app: ${response}"
                        
                        if (!response.contains("Hello World")) {
                            error("Response tidak sesuai! Testing gagal.")
                        }
                    } finally {
                        // Hapus container setelah test selesai
                        bat "docker rm -f ${CONTAINER_NAME}"
                    }
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
                        bat "docker push ${IMAGE_NAME}:${TAG}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    def deploymentFile = 'k8s/deployment.yaml'
                    def content = readFile(deploymentFile)
                    content = content.replaceAll(/image: darren13\/hello-app:.*/, "image: darren13/hello-app:${TAG}")
                    writeFile(file: deploymentFile, text: content)

                    withKubeConfig([credentialsId: 'kubeconfig-credential-id']) {
                        bat 'kubectl apply -f k8s/deployment.yaml'
                        bat 'kubectl apply -f k8s/service.yaml'
                    }
                }
            }
        }
    }
}
