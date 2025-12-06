pipeline {
    agent {
        docker {
            image 'selenium/standalone-chrome:latest'
            args '-u root:root'  
        }
    }

    environment {
        TEST_TYPE = "UI"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup Python Environment') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run UI Tests') {
            steps {
                sh '''
                    . venv/bin/activate
                    mkdir -p reports/robot
                    robot -d reports/robot tests/ui/Sampletest.robot
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline completed. Selected TEST_TYPE = ${TEST_TYPE}"
            robot outputPath: 'reports/robot'
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
