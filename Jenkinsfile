pipeline {
    agent any

    stages {

        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Setup Python Environment') {
            steps {
                sh '''
                    python3 -m venv robotenv
                    . robotenv/bin/activate
                    pip install --upgrade pip
                    pip install robotframework robotframework-seleniumlibrary selenium \
                                webdriver-manager robotframework-requests
                '''
            }
        }

        stage('Run Robot UI Tests') {
            steps {
                sh '''
                    . robotenv/bin/activate
                    robot -d results/ui tests/ui
                '''
            }
        }

        stage('Run Robot API Tests') {
            steps {
                sh '''
                    . robotenv/bin/activate
                    robot -d results/api tests/api
                '''
            }
        }

        stage('Run k6 Performance Test') {
            steps {
                sh '''
                    mkdir -p k6_results
                    docker run --rm \
                        -v "$WORKSPACE":/workspace \
                        -w /workspace \
                        grafana/k6:latest run \
                        --out json=k6_results/perf.json \
                        tests/perf/load_test.js
                '''
            }
        }

        stage('Publish Results') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                echo "Publishing Results..."
                archiveArtifacts artifacts: 'results/ui/**'
                archiveArtifacts artifacts: 'results/api/**'
                archiveArtifacts artifacts: 'k6_results/**'
            }
        }
    }

    post {
        always {
            echo "Build completed. Check results/ui, results/api, and k6_results folders."
            archiveArtifacts artifacts: 'results/ui/**', allowEmptyArchive: true
            archiveArtifacts artifacts: 'results/api/**', allowEmptyArchive: true
            archiveArtifacts artifacts: 'k6_results/**', allowEmptyArchive: true
        }
    }
}
