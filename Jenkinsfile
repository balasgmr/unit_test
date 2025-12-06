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
            when {
                expression { return env.TEST_TYPE == "UI" || env.TEST_TYPE == "ALL" }
            }
            steps {
                echo "Running UI Tests..."
                sh '''
                    . ${VENV_DIR}/bin/activate
                    mkdir -p reports/robot/ui
                    robot -d reports/robot/ui tests/ui
                '''
            }
        }

        stage('Run API Tests') {
            when {
                expression { return env.TEST_TYPE == "API" || env.TEST_TYPE == "ALL" }
            }
            steps {
                echo "Running API Tests..."
                sh '''
                    . ${VENV_DIR}/bin/activate
                    mkdir -p reports/robot/api
                    robot -d reports/robot/api tests/api
                '''
            }
        }

        stage('Run Performance Tests') {
            when {
                expression { return env.TEST_TYPE == "PERF" || env.TEST_TYPE == "ALL" }
            }
            steps {
                echo "Running Performance Tests..."
                sh '''
                    . ${VENV_DIR}/bin/activate
                    mkdir -p reports/robot/perf
                    robot -d reports/robot/perf tests/performance
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline completed. Selected TEST_TYPE = ${TEST_TYPE}"

            // Archive all Robot reports
            archiveArtifacts artifacts: 'reports/robot/**/*', allowEmptyArchive: true
        }

        failure {
            echo "Pipeline failed. Reports saved under reports/robot/"
        }

        success {
            echo "Pipeline succeeded!"
        }
    }
}
