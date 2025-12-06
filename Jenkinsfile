pipeline {
    agent any

    environment {
        VENV_DIR = "venv"
        TEST_TYPE = "ALL"   // UI / API / PERF / ALL
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Chrome') {
            steps {
                sh """
                apt-get update
                apt-get install -y wget gnupg2
                wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
                apt-get install -y ./google-chrome-stable_current_amd64.deb || apt --fix-broken install -y
                google-chrome --version
                """
            }
        }

        stage('Install Dependencies') {
            steps {
                sh """
                python3 -m venv ${VENV_DIR}
                . ${VENV_DIR}/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                """
            }
        }

        stage('Run UI Tests') {
            when {
                expression { env.TEST_TYPE == "UI" || env.TEST_TYPE == "ALL" }
            }
            steps {
                echo "Running UI Tests..."
                sh """
                . ${VENV_DIR}/bin/activate
                mkdir -p reports/ui
                robot -d reports/ui tests/ui
                """
            }
        }

        stage('Run API Tests') {
            when {
                expression { env.TEST_TYPE == "API" || env.TEST_TYPE == "ALL" }
            }
            steps {
                echo "Running API Tests..."
                sh """
                . ${VENV_DIR}/bin/activate
                mkdir -p reports/api
                robot -d reports/api tests/api
                """
            }
        }

        stage('Run Performance Tests') {
            when {
                expression { env.TEST_TYPE == "PERF" || env.TEST_TYPE == "ALL" }
            }
            steps {
                echo "Running Performance Tests..."
                sh """
                . ${VENV_DIR}/bin/activate
                mkdir -p reports/perf
                robot -d reports/perf tests/performance
                """
            }
        }
    }

    post {
        always {
            echo "Pipeline completed. TEST_TYPE = ${TEST_TYPE}"
            archiveArtifacts artifacts: 'reports/**', allowEmptyArchive: true
        }
    }
}
