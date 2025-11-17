pipeline {
    agent any

    parameters {
        choice(
            name: 'TEST_TYPE',
            choices: ['UI', 'API', 'PERFORMANCE'],
            description: 'Choose which test suite to run'
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

        /* -------------------------------------------------------
                        ROBOT FRAMEWORK - UI
        -------------------------------------------------------- */
        stage('Run UI Tests') {
            when {
                expression { params.TEST_TYPE == "UI" }
            }
            steps {
                echo "Running UI Tests..."
                sh """
                    mkdir -p ${ROBOT_REPORT_DIR}
                    robot -d ${ROBOT_REPORT_DIR} tests/ui
                """
            }
            post {
                always {
                    echo "Publishing Robot Framework UI Reports"
                    robot outputPath: "${ROBOT_REPORT_DIR}"
                }
            }
        }

        /* -------------------------------------------------------
                        ROBOT FRAMEWORK - API
        -------------------------------------------------------- */
        stage('Run API Tests') {
            when {
                expression { params.TEST_TYPE == "API" }
            }
            steps {
                echo "Running API Tests..."
                sh """
                    mkdir -p ${ROBOT_REPORT_DIR}
                    robot -d ${ROBOT_REPORT_DIR} tests/api
                """
            }
            post {
                always {
                    echo "Publishing Robot Framework API Reports"
                    robot outputPath: "${ROBOT_REPORT_DIR}"
                }
            }
        }

        /* -------------------------------------------------------
                        PERFORMANCE - K6
        -------------------------------------------------------- */
        stage('Run k6 Performance Test') {
            when {
                expression { params.TEST_TYPE == "PERFORMANCE" }
            }
            steps {
                echo "Running k6 Load Test..."
                sh """
                    mkdir -p ${K6_REPORT_DIR}
                    k6 run load_test.js --out json=${K6_REPORT_DIR}/k6_results.json
                """
            }
            post {
                always {
                    echo "Archiving k6 Results"
                    archiveArtifacts artifacts: "${K6_REPORT_DIR}/*.json", allowEmptyArchive: true
                }
            }
        }

    }

    post {
        always {
            echo "Pipeline finished for TEST_TYPE = ${params.TEST_TYPE}"
        }
    }

}
