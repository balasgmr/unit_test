pipeline {
    agent any

    environment {
        TEST_TYPE = "UI"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh """
                python3 -m venv venv
                . venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                """
            }
        }

        stage('Run UI Tests') {
            when { expression { env.TEST_TYPE == "UI" } }
            steps {
                echo "Running UI Tests..."
                sh """
                . venv/bin/activate
                mkdir -p reports/robot
                robot -d reports/robot --variable HEADLESS:True tests/ui
                """
            }
        }

        stage('Run API Tests') {
            when { expression { env.TEST_TYPE == "API" } }
            steps {
                sh """
                . venv/bin/activate
                robot -d reports/robot tests/api
                """
            }
        }

        stage('Run Performance Tests') {
            when { expression { env.TEST_TYPE == "PERF" } }
            steps {
                sh """
                . venv/bin/activate
                robot -d reports/robot tests/perf
                """
            }
        }
    }

    post {
        always {
            echo "Pipeline completed. Selected TEST_TYPE = ${TEST_TYPE}"
            robot outputPath: 'reports/robot'
        }
    }
}
