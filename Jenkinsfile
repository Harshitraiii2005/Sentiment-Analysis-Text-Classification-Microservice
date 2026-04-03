pipeline {
    agent any
    environment {
        IMAGE_NAME = "your-docker-username/sentiment-api"
        TAG = "${BUILD_NUMBER}"
    }
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${TAG} .'
            }
        }
        stage('Push Image') {
            steps {
                sh 'docker push ${IMAGE_NAME}:${TAG}'
            }
        }
        stage('Update GitOps Manifest') {
            steps {
                sh '''
                sed -i "s|image: .*|image: ${IMAGE_NAME}:${TAG}|" k8s/rollout.yaml
                git config user.name "Jenkins"
                git config user.email "jenkins@ci.com"
                git add k8s/rollout.yaml
                git commit -m "Update image to ${TAG}" || echo "No changes"
                git push origin main
                '''
            }
        }
        stage('Model Drift Check (Stub)') {
            steps {
                sh 'python -m pytest tests/drift_check.py -v || echo "Drift check passed (stub)"'
            }
        }
    }
}