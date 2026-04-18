pipeline {
  agent any
  tools {
    jdk 'JDK17'
    maven 'MAVEN3.9'
  }
  environment {
    DOCKER_IMAGE = "tawfeeq421/devsecops"
    DOCKER_TAG = "${BUILD_NUMBER}"
    AWS_REGION = 'us-west-2'
    CLUSTER_NAME = 'my-cluster'
    NAMESPACE = 'devops'
    IMAGE = "${DOCKER_IMAGE}:${DOCKER_TAG}"
  }
  stages{
    stage('Clean Workspace'){
      steps{
        cleanWs()
      }
    }
    stage('Git Checkout'){
      steps{
        git branch: 'main', url: 'https://github.com/tawfeeq421/decsecops-k8s.git'
      }
    }
    stage('Build'){
      steps{
        sh 'mvn clean package -DskipTests'
      }
    }
    stage('Test'){
      steps{
        sh 'mvn test'
      }
    }
    stage('Checkstyle Analysis'){
      steps{
        sh 'mvn checkstyle:checkstyle'
      }
    }
    stage('SonarQube Analysis'){
      environment {
        scannerHome = tool 'sonar'
      }
      steps{
        withSonarQubeEnv('sonarserver'){
          sh """
          ${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=java-app \
          -Dsonar.projectName=java-app \
          -Dsonar.projectVersion=1.0 \
          -Dsonar.sources=src/ \
          -Dsonar.java.binaries=target/classes \
          -Dsonar.junit.reportPaths=target/surefire-reports \
          -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco.xml
          """
        }

      }
    }
    stage('Quality Gate'){
      steps{
        timeout(time: 1, unit: 'HOURS'){
          waitForQualityGate abortPipeline: true
        }
      }
    }
    stage('Trivy File Scan'){
      steps{
        sh '''
        trivy fs \
        --severity HIGH,CRITICAL \
        --format table \
        -o trivyfs-report.txt .
        '''
      }
    }
    stage('Docker Build & Push'){
      steps{
        script{
          docker.withRegistry('https://index.docker.io/v1/', "docker-cred"){
            def app = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
            app.push()
          }
        }
      }
    }
    stage('Trivy Image Scan'){
      steps{
        sh """
        trivy image \
        --severity HIGH,CRITICAL \
        --format table \
        -o trivy_image-report.txt \
        ${DOCKER_IMAGE}:${DOCKER_TAG} || true
        """
      }
    }
    stage('Deploy to EKS'){
      steps{
        withCredentials([[
          $class 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-creds'
        ]]){
          sh '''
          set -e 
          aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME
          kubectl apply -f k8s/namespace.yml

          kubectl apply -f k8s/app-deployment.yml
          kubectl apply -f k8s/app-service.yml
          kubectl apply -f k8s/ingress.yml

          kubectl set image deployment/app-deployment myapp=$IMMAGE -n $NAMESPACE
          kubectl rollout status deployment/app-depolyment -n $NAMESPACE
          '''
        }
      }
    }
  }
  post {
    always{
      archiveArtifacts artifacts: 'trivyfs-report.txt', fingerprint: true 
    }
    success {
      slackSend(
        channel: '#devops',
        color: 'good',
        message: "✅ SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}\nReport generated."
      )
    }
    failure {
      slackSend(
        channel: '#devops',
        color: 'danger',
        message: "❌ FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}\nCheck trivy report.\n${env.BUILD_URL}"
      )
    }
  }
}
