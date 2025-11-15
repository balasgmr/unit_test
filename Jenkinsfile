pipeline {
    agent any

    environment {
        VENV_DIR = "${WORKSPACE}/robotenv"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/balasgmr/robot_jenkins_poc.git', branch: 'main'
            }
        }

        stage('Setup Python Environment') {
            steps {
                sh """
                    python3 -m venv ${VENV_DIR}
                    . ${VENV_DIR}/bin/activate
                    pip install --upgrade pip --break-system-packages
                    pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager --break-system-packages
                """
            }
        }

        stage('Run Robot Tests') {
            steps {
                sh """
                    . ${VENV_DIR}/bin/activate
                    mkdir -p results
                    robot -d results tests/
                """
            }
        }

        stage('Publish Reports') {
            steps {
                // 1️⃣ Archive HTML reports so they are downloadable
                archiveArtifacts artifacts: 'results/*.html', allowEmptyArchive: true

                // 2️⃣ Optional: Publish Robot Framework test summary in Jenkins
                // Requires "Robot Framework Plugin" installed
                robot outputPath: 'results', 
                      outputFileName: 'output.xml', 
                      logFileName: 'log.html', 
                      reportFileName: 'report.html', 
                      passThreshold: 100, 
                      unstableThreshold: 80
            }
        }
    }

    post {
        always {
            echo "Build finished. Check results/ folder and Jenkins Robot report."
        }
    }
}
