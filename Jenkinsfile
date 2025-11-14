pipeline {
    agent any

    stages {

        stage('Setup Environment') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y chromium chromium-driver python3-pip

                    pip install --upgrade pip
                    pip install robotframework selenium robotframework-seleniumlibrary
                '''
            }
        }

        stage('Run Headless UI Tests') {
            steps {
                sh '''
                    robot -d results tests/
                '''
            }
        }

        stage('Publish Report') {
            steps {
                publishHTML([
                    reportDir: 'results',
                    reportFiles: 'report.html',
                    reportName: 'Robot Report',
                    allowMissing: false,
                    keepAll: true,
                    alwaysLinkToLastBuild: true
                ])
            }
        }
    }
}
