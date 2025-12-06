pipeline {
    agent {
        docker {
            image 'jenkins-chrome-agent:latest'   // Your custom image
            args '-u root:root'                   // Run as root inside container
        }
    }

    environment {
        TEST_TYPE = "UI"
        ROBOT_REPORT_DIR = "reports/robot"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Python Dependencies') {
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
                echo "Running UI Tests..."
                sh '''
                mkdir -p ${ROBOT_REPORT_DIR}
                . venv/bin/activate
                robot -d ${ROBOT_REPORT_DIR} tests/ui
                '''
            }
        }

        stage('Run API Tests') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                echo "Running API Tests..."
                sh '''
                . venv/bin/activate
                robot -d ${ROBOT_REPORT_DIR} tests/api
                '''
            }
        }

        stage('Run Performance Tests') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                echo "Running Performance Tests..."
                sh 'k6 run tests/performance/test.js'
            }
        }
    }

    post {
        always {
            echo "Publishing Robot Framework Results..."
            robot outputPath: "${ROBOT_REPORT_DIR}/output.xml",
                  logPath: "${ROBOT_REPORT_DIR}/log.html",
                  reportPath: "${ROBOT_REPORT_DIR}/report.html"
        }

        success {
            echo "Pipeline completed successfully!"
        }

        failure {
            echo "Pipeline failed!"
        }
    }
}
