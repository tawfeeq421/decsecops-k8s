pipeline {
  agent any
  tools {
    jdk 'JDK17'
    maven 'MAVEN3.9'
  }
  environment {
    DOCKER_IMAGE = "tawfeeq421/devsecops"
    DOCKER_TAG = "${BUILD_NUMBER}"
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
          ${scannerHome}/bin/sonar-scanner
          -Dsonar.projectKey=java-app \
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
          withDockerRegistry([credentialsId: 'docker-cred']){
            sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
          }
        }
      }
    }
    stage('Image Scan'){
      steps{
        sh "trivy image ${DOCKER_IMAGE}:${DOCKER_TAG}"
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
        message: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}\nReport generated."
      )
    }
    failure {
      slackSend(
        channel: '#devops',
        color: 'danger',
        message: "FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}\nCheck trivy report.\n${env.BUILD_URL}"
      )
    }
  }
}