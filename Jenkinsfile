pipeline {

    agent any

    /* ------------ TEST SELECTION (UI / API / K6 / ALL) ------------ */
    parameters {
        choice(
            name: 'TEST_TYPE',
            choices: ['ALL', 'UI_ONLY', 'API_ONLY', 'K6_ONLY'],
            description: 'Select which tests to run'
        )
    }

    stages {

        /* ---------------- CHECKOUT ---------------- */
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        /* ---------------- PYTHON ENV SETUP ---------------- */
        stage('Setup Python Environment') {
            when {
                expression { params.TEST_TYPE in ['ALL', 'UI_ONLY', 'API_ONLY'] }
            }
            steps {
                sh '''
                    python3 -m venv robotenv
                    . robotenv/bin/activate
                    pip install --upgrade pip
                    pip install robotframework robotframework-seleniumlibrary \
                                robotframework-requests selenium webdriver-manager
                '''
            }
        }

        /* ---------------- UI TESTS ---------------- */
        stage('Run UI Tests') {
            when {
                expression { params.TEST_TYPE in ['ALL', 'UI_ONLY'] }
            }
            steps {
                sh '''
                    echo "Running UI Tests..."
                    . robotenv/bin/activate
                    robot -d results/ui tests/ui
                '''
            }
        }

        /* ---------------- API TESTS ---------------- */
        stage('Run API Tests') {
            when {
                expression { params.TEST_TYPE in ['ALL', 'API_ONLY'] }
            }
            steps {
                sh '''
                    echo "Running API Tests..."
                    . robotenv/bin/activate
                    robot -d results/api tests/api
                '''
            }
        }

        /* ---------------- K6 PERFORMANCE TEST ---------------- */
        stage('Run k6 Performance Test') {
            when {
                expression { params.TEST_TYPE in ['ALL', 'K6_ONLY'] }
            }
            steps {
                sh '''
                    echo "Running k6 Performance Test..."

                    mkdir -p k6_results

                    echo "WORKSPACE = $WORKSPACE"
                    ls -R $WORKSPACE/tests/perf

                    # IMPORTANT FIX: k6 CANNOT READ FILE WITHOUT PERMISSIONS
                    chmod -R 755 $WORKSPACE/tests

                    docker run --rm \
                        -v "$WORKSPACE":/workspace \
                        -w /workspace \
                        grafana/k6:latest run \
                        --out json=k6_results/perf.json \
                        /workspace/tests/perf/load_test.js
                '''
            }
        }

        /* ---------------- REPORT PUBLISH ---------------- */
        stage('Publish Reports') {
            steps {
                archiveArtifacts artifacts: 'results/ui/**', allowEmptyArchive: true
                archiveArtifacts artifacts: 'results/api/**', allowEmptyArchive: true
                archiveArtifacts artifacts: 'k6_results/**', allowEmptyArchive: true
            }
        }
    }

    post {
        always {
            echo "Pipeline Finished — Check Results Folder"
        }
    }
}
