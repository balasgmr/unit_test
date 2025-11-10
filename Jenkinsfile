pipeline {
    agent any

    stages {
        stage('Setup') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y chromium chromium-driver
                    pip install --upgrade pip
                    pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    mkdir -p results
                    robot -d results tests/
                '''
            }
        }

        stage('Archive Reports') {
            steps {
                archiveArtifacts artifacts: 'results/*', fingerprint: true
                publishHTML(target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'results',
                    reportFiles: 'report.html',
                    reportName: 'Robot Framework Report'
                ])
            }
        }
    }
}
