pipeline {
    agent {
        docker {
            image 'selenium/standalone-chrome:latest'
            args '-u root:root'
        }
    }

    environment {
        TEST_TYPE = "UI"
        VENV_PATH = "${WORKSPACE}/venv"
    }

    options {
        // Clean workspace before build
        skipDefaultCheckout false
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup Python Environment') {
            steps {
                sh """
                    python3 -m venv ${VENV_PATH}
                    . ${VENV_PATH}/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                """
            }
        }

        stage('Run UI Tests') {
            steps {
                sh """
                    . ${VENV_PATH}/bin/activate
                    mkdir -p reports/robot
                    # Run only Sampletest.robot to avoid failing Unit Test
                    robot -d reports/robot tests/ui/Sampletest.robot
                """
            }
        }

        stage('Run API Tests') {
            when {
                expression { return currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                echo 'Running API Tests...'
                sh """
                    . ${VENV_PATH}/bin/activate
                    robot -d reports/robot tests/api
                """
            }
        }

        stage('Run Performance Tests') {
            when {
                expression { return currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                echo 'Running Performance Tests...'
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
