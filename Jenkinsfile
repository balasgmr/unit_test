pipeline {
    agent any

    parameters {
        choice(
            name: 'TEST_TYPE',
            choices: ['UI', 'API', 'BOTH'],
            description: 'Select which tests to run'
        )
    }

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
                    pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager robotframework-requests --break-system-packages
                """
            }
        }

        stage('Run Robot Tests') {
            steps {
                script {
                    if (params.TEST_TYPE == 'UI') {
                        sh """
                            . ${VENV_DIR}/bin/activate
                            mkdir -p results
                            robot -d results tests/ui
                        """
                    } else if (params.TEST_TYPE == 'API') {
                        sh """
                            . ${VENV_DIR}/bin/activate
                            mkdir -p results
                            robot -d results tests/api
                        """
                    } else {
                        sh """
                            . ${VENV_DIR}/bin/activate
                            mkdir -p results
                            robot -d results tests
                        """
                    }
                }
            }
        }

        stage('Publish Reports') {
            steps {
                archiveArtifacts artifacts: 'results/*.html', allowEmptyArchive: true

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
            echo "Build completed. Check results/ folder and Jenkins Robot report."
        }
    }
}
