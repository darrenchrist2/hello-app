//windows
// pipeline {
//     agent any

//     environment {
//         IMAGE_NAME = "darren13/hello-app"
//         TAG = "v${env.BUILD_NUMBER}"  // Tag unik per build
//         CONTAINER_NAME = "hello-app-for-test-container"
//     }

//     stages {
//         stage('Checkout') {
//             steps {
//                 git url: 'https://github.com/salvestacia/hello-app.git', branch: 'main'
//             }
//         }

//         stage('Build Image') {
//             steps {
//                 script {
//                     docker.build("${IMAGE_NAME}:${TAG}")
//                 }
//             }
//         }

//         stage('Test App') {
//             steps {
//                 script {
//                     try {
//                         // Jalankan container untuk testing
//                         bat "docker run -d --name ${CONTAINER_NAME} -p 3000:3000 ${IMAGE_NAME}:${TAG}"
                        
//                         // Tunggu sebentar agar container siap
//                         sleep(time: 5, unit: 'SECONDS')

//                         // Lakukan request ke localhost dan periksa responsnya
//                         def response = bat(script: 'curl -s http://localhost:3000', returnStdout: true).trim()
                        
//                         echo "Response from app: ${response}"
                        
//                         if (!response.contains("Hello World")) {
//                             error("Response tidak sesuai! Testing gagal.")
//                         }
//                     } finally {
//                         // Hapus container setelah test selesai
//                         bat "docker rm -f ${CONTAINER_NAME}"
//                     }
//                 }
//             }
//         }

//         stage('Push Image') {
//             steps {
//                 script {
//                     withCredentials([usernamePassword(
//                         credentialsId: 'dockerhub-cred-id',
//                         usernameVariable: 'DOCKER_USER',
//                         passwordVariable: 'DOCKER_PASS'
//                     )]) {
//                         bat "echo Logging in to DockerHub..."
//                         bat "docker login -u %DOCKER_USER% -p %DOCKER_PASS%"
//                         bat "docker push ${IMAGE_NAME}:${TAG}"
//                     }
//                 }
//             }
//         }

//         stage('Deploy to Kubernetes') {
//             steps {
//                 script {
//                     def deploymentFile = 'k8s/deployment.yaml'
//                     def content = readFile(deploymentFile)
//                     content = content.replaceAll(/image: darren13\/hello-app:.*/, "image: darren13/hello-app:${TAG}")
//                     writeFile(file: deploymentFile, text: content)

//                     withKubeConfig([credentialsId: 'kubeconfig-credential-id']) {
//                         bat 'kubectl apply -f k8s/deployment.yaml'
//                         bat 'kubectl apply -f k8s/service.yaml'
//                     }
//                 }
//             }
//         }
//     }
// }

//linux
pipeline {
    agent any  // Use any available agent for running the pipeline

    environment {
        IMAGE_NAME = "darren13/hello-app"  // Nama image Docker
        TAG = "v${env.BUILD_NUMBER}"  // Tag unik per build berdasarkan BUILD_NUMBER
        CONTAINER_NAME = "hello-app-for-test-container"  // Nama container untuk testing
    }

    stages {
        stage('Checkout') {
            steps {
                // Mengambil kode dari repository GitHub
                git url: 'https://github.com/salvestacia/hello-app.git', branch: 'main'
            }
        }

        stage('Build Image') {
            steps {
                script {
                    // Membangun image Docker dari Dockerfile yang ada
                    docker.build("${IMAGE_NAME}:${TAG}")
                }
            }
        }

        stage('Test App') {
            steps {
                script {
                    try {
                        // Menjalankan container Docker untuk aplikasi yang dibangun
                        sh "docker run -d --name ${CONTAINER_NAME} -p 3000:3000 ${IMAGE_NAME}:${TAG}"
                        
                        // Tunggu beberapa detik agar container siap untuk diuji
                        sleep(time: 5, unit: 'SECONDS')

                        // Melakukan request ke aplikasi yang berjalan di localhost dan memeriksa respons
                        def response = sh(script: 'curl -s http://localhost:3000', returnStdout: true).trim()
                        
                        echo "Response from app: ${response}"
                        
                        // Jika respons tidak sesuai, pipeline akan gagal
                        if (!response.contains("Hello World")) {
                            error("Response tidak sesuai! Testing gagal.")
                        }
                    } finally {
                        // Menghapus container setelah pengujian selesai
                        sh "docker rm -f ${CONTAINER_NAME}"
                    }
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    // Menggunakan kredensial DockerHub untuk login dan push image
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-cred-id',  // ID kredensial DockerHub di Jenkins
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh "echo Logging in to DockerHub..."
                        sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"  // Login ke DockerHub
                        sh "docker push ${IMAGE_NAME}:${TAG}"  // Push image ke DockerHub
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Mengupdate deployment.yaml untuk menggunakan tag image terbaru
                    def deploymentFile = 'k8s/deployment.yaml'
                    def content = readFile(deploymentFile)
                    content = content.replaceAll(/image: darren13\/hello-app:.*/, "image: darren13/hello-app:${TAG}")
                    writeFile(file: deploymentFile, text: content)

                    // Menggunakan kredensial Kubernetes untuk melakukan deploy aplikasi
                    withKubeConfig([credentialsId: 'kubeconfig-credential-id']) {
                        sh 'kubectl apply -f k8s/deployment.yaml'  // Deploy deployment.yaml ke Kubernetes
                        sh 'kubectl apply -f k8s/service.yaml'  // Deploy service.yaml ke Kubernetes
                    }
                }
            }
        }
    }
}
