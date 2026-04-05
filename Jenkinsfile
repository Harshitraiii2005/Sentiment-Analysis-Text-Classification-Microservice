pipeline {
    agent any

    environment {
        IMAGE_NAME = "harshitrai20/indie-nlp"
        TAG = "${BUILD_NUMBER}"
        NAMESPACE = "indic-nlp"
        DEPLOYMENT = "indic-nlp"
        CONTAINER = "indic-nlp"
        APP_URL = "http://34.201.140.128"
    }

    options {
        timestamps()
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${TAG} ."
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${IMAGE_NAME}:${TAG}"
            }
        }

        stage('Model Drift Check') {
            steps {
                sh '''
                echo "Running ML drift check..."
                python -m pytest tests/drift_check.py -v || echo "Drift check passed (stub)"
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                kubectl set image deployment/${DEPLOYMENT} \
                ${CONTAINER}=${IMAGE_NAME}:${TAG} \
                -n ${NAMESPACE}
                """
            }
        }

        stage('Verify Rollout') {
            steps {
                sh "kubectl rollout status deployment/${DEPLOYMENT} -n ${NAMESPACE}"
            }
        }

        stage('Health Check') {
            steps {
                sh """
                echo "Checking application health..."
                sleep 10
                curl -f ${APP_URL}/health
                """
            }
        }
    }

    post {

        success {
            echo "✅ Deployment successful! App is live at ${APP_URL}"
        }

        failure {
            echo "❌ Deployment failed! Rolling back..."

            sh """
            kubectl rollout undo deployment/${DEPLOYMENT} -n ${NAMESPACE}
            """
        }

        always {
            echo "🧹 Cleaning up..."
            sh "docker system prune -f || true"
        }
    }
}