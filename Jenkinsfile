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

        stage('Setup Python Environment') {
            steps {
                sh '''
                python3 -m venv robotenv
                . robotenv/bin/activate
                pip install --upgrade pip
                pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager robotframework-requests
                '''
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
                        . robotenv/bin/activate
                        robot -d results/${t} tests/${t}
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
                sh '''
                mkdir -p k6_results
                docker run --rm -v $WORKSPACE:/workspace -w /workspace loadimpact/k6:latest \
                    k6 run --out json=k6_results/perf.json tests/perf/load_test.js
                '''
            }
        }

        stage('Publish Results') {
            steps {
                // Archive only XML for Robot and JSON for k6
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
