pipeline {
    agent any

    environment {
        TEST_TYPE = "UI"
        VENV_DIR = "venv"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv ${VENV_DIR}
                    . ${VENV_DIR}/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run UI Tests') {
            steps {
                echo "Running UI Tests..."
                sh '''
                    . ${VENV_DIR}/bin/activate
                    mkdir -p reports/robot
                    robot -d reports/robot tests/ui
                '''
            }
        }

        stage('Run API Tests') {
            steps {
                echo "Running API Tests..."
                sh '''
                    . ${VENV_DIR}/bin/activate
                    mkdir -p reports/api
                    robot -d reports/api tests/api
                '''
            }
            when {
                expression { return env.TEST_TYPE == "API" || env.TEST_TYPE == "ALL" }
            }
        }

        stage('Run Performance Tests') {
            steps {
                echo "Running Performance Tests..."
                sh '''
                    . ${VENV_DIR}/bin/activate
                    mkdir -p reports/perf
                    robot -d reports/perf tests/performance
                '''
            }
            when {
                expression { return env.TEST_TYPE == "PERF" || env.TEST_TYPE == "ALL" }
            }
        }
    }

    post {
        always {
            echo "Pipeline completed. Selected TEST_TYPE = ${TEST_TYPE}"
            archiveArtifacts artifacts: 'reports/**', allowEmptyArchive: true
        }
        failure {
            echo "Pipeline failed. Check Robot Framework reports in reports/ folder."
        }
        success {
            echo "Pipeline succeeded!"
        }
    }
}
