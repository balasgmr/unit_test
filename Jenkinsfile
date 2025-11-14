pipeline {
    agent any

    stages {

        stage('Install Dependencies') {
            steps {
                sh '''
                    pip install --upgrade pip
                    pip install robotframework
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    robot -d results tests/
                '''
            }
        }

        stage('Publish Reports') {
            steps {
                publishHTML([
                    reportDir: 'results',
                    reportFiles: 'report.html',
                    reportName: 'Robot Report'
                ])
            }
        }
    }
}
