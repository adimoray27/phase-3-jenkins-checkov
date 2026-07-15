pipeline {
    agent any

    parameters {
        booleanParam(name: 'ENABLE_TRIVY', defaultValue: false, description: 'Enable Trivy security scan')
        booleanParam(name: 'ENABLE_CHECKOV', defaultValue: true, description: 'Enable Checkov IaC scan')
    }

    environment {
        IMAGE_NAME = "adi144/hello-world-demo:${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Checkov Scan') {
            when {
                expression { params.ENABLE_CHECKOV == true }
            }
            steps {
                sh '''
                    docker run --rm \
                      -v "$PWD:/tf" \
                      -w /tf \
                      bridgecrew/checkov:latest \
                      checkov -d . --framework terraform,kubernetes,dockerfile
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Test Website') {
            steps {
                sh '''
                    docker rm -f hello-test || true
                    docker run -d --name hello-test -p 8090:8080 $IMAGE_NAME
                    sleep 5
                    curl -f http://localhost:8090
                    docker rm -f hello-test || true
                '''
            }
        }

        stage('Trivy Scan') {
            when {
                expression { params.ENABLE_TRIVY == true }
            }
            steps {
                sh 'trivy image --severity HIGH,CRITICAL --exit-code 1 --no-progress $IMAGE_NAME'
            }
        }

        stage('Docker Hub Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: '479a3a5b-2771-4615-b7b2-5b6c76e6aa22', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_NAME'
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker pull $IMAGE_NAME
                    docker rm -f hello-app || true
                    docker run -d --name hello-app -p 8085:8080 $IMAGE_NAME
                '''
            }
        }
    }
}
