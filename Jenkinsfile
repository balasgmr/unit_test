pipeline {
    agent any

    parameters {
        choice(
            name: 'TEST_TYPE',
            choices: ['UI', 'API', 'BOTH'],
            description: 'Select which tests to run'
        )
    }

    stages {

        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/balasgmr/robot_jenkins_poc.git', branch: 'main'
            }
        }

        stage('Run Robot Tests') {
            steps {
                script {
                    def testTypes = []
                    if (params.TEST_TYPE == 'UI' || params.TEST_TYPE == 'BOTH') {
                        testTypes << 'ui'
                    }
                    if (params.TEST_TYPE == 'API' || params.TEST_TYPE == 'BOTH') {
                        testTypes << 'api'
                    }

                    for (t in testTypes) {
                        sh """
                        docker run --rm -v \$WORKSPACE:/workspace -w /workspace python:3.11-slim bash -c '
                            python3 -m venv robotenv &&
                            . robotenv/bin/activate &&
                            pip install --upgrade pip &&
                            pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager robotframework-requests &&
                            robot -d results/${t} tests/${t}
                        '
                        """
                    }
                }
            }
        }

        stage('Run k6 Performance Test') {
            when {
                expression { params.TEST_TYPE == 'BOTH' }
            }
            steps {
                sh """
                docker run --rm -v \$WORKSPACE:/workspace -w /workspace loadimpact/k6:latest \
                    k6 run --out json=k6_results/perf.json tests/perf/load_test.js
                """
            }
        }

        stage('Publish Results') {
            steps {
                // Only archive Robot Framework XML and k6 JSON, no extra HTML reports
                archiveArtifacts artifacts: 'results/**/*.xml', allowEmptyArchive: true
                archiveArtifacts artifacts: 'k6_results/*.json', allowEmptyArchive: true
            }
        }
    }

    post {
        always {
            echo "Build completed. Check results/ folder and k6_results/ folder."
        }
    }
}
