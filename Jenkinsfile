pipeline {
    agent any

    parameters {
        choice(
            name: 'TEST_TYPE',
            choices: ['UI', 'API', 'PERFORMANCE'],
            description: 'Choose test suite to run'
        )
    }

    environment {
        ROBOT_REPORT_DIR = "reports/robot"
        K6_REPORT_DIR    = "reports/k6"
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
            when { expression { params.TEST_TYPE == 'UI' } }
            steps {
                echo "Running UI Tests..."
                sh """
                    mkdir -p ${ROBOT_REPORT_DIR}
                    . venv/bin/activate
                    robot -d ${ROBOT_REPORT_DIR} tests/ui
                """
            }
            post {
                always {
                    robot outputPath: "${ROBOT_REPORT_DIR}"
                }
            }
        }

        stage('Run API Tests') {
            when { expression { params.TEST_TYPE == 'API' } }
            steps {
                echo "Running API Tests..."
                sh """
                    mkdir -p ${ROBOT_REPORT_DIR}
                    . venv/bin/activate
                    robot -d ${ROBOT_REPORT_DIR} tests/api
                """
            }
            post {
                always {
                    robot outputPath: "${ROBOT_REPORT_DIR}"
                }
            }
        }

        stage('Run Performance Tests') {
            when { expression { params.TEST_TYPE == 'PERFORMANCE' } }
            steps {
                echo "Running k6 load test..."
                sh """
                    mkdir -p ${K6_REPORT_DIR}
                    k6 run tests/perf/load_test.js --out json=${K6_REPORT_DIR}/k6.json
                """
            }
            post {
                always {
                    archiveArtifacts artifacts: "${K6_REPORT_DIR}/*.json"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline completed. Selected TEST_TYPE = ${params.TEST_TYPE}"
        }
    }
}
