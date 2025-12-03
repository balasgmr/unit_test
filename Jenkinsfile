pipeline {
    agent any

    environment {
        VENV = "${WORKSPACE}/venv"
        ROBOT_REPORT_DIR = "${WORKSPACE}/reports/robot"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out code from Git..."
                git branch: 'main', url: 'https://github.com/balasgmr/robot_jenkins_poc.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "Setting up Python virtual environment and installing dependencies..."
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
                echo "Running Robot Framework UI tests..."
                sh '''
                    . venv/bin/activate
                    mkdir -p reports/robot
                    robot -d reports/robot tests/ui
                '''
            }
        }

        stage('Publish Robot Results') {
            steps {
                echo "Publishing Robot Framework test results..."
                robot outputPath: 'reports/robot'
            }
        }

        stage('Run API Tests') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                echo "Running API tests..."
                sh '''
                    . venv/bin/activate
                    mkdir -p reports/api
                    robot -d reports/api tests/api
                '''
            }
        }

        stage('Run Performance Tests') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                echo "Running Performance tests..."
                sh '''
                    . venv/bin/activate
                    mkdir -p reports/perf
                    robot -d reports/perf tests/performance
                '''
            }
        }
    }

    post {
        always {
            echo "Cleaning up virtual environment..."
            sh '''
                deactivate || true
                rm -rf venv
            '''
            echo "Pipeline finished."
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check Robot test reports for details."
        }
    }
}
