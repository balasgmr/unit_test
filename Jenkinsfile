pipeline {
    agent any

    environment {
        TEST_TYPE = "UI"
    }

    stages {

        stage('Checkout') {
            steps {
                // Checkout your repository
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                # Create Python virtual environment
                python3 -m venv venv
                . venv/bin/activate

                # Upgrade pip and install requirements
                pip install --upgrade pip
                pip install -r requirements.txt
                '''
            }
        }

        stage('Run UI Tests') {
            steps {
                echo "Running UI Tests..."
                sh '''
                # Make sure report folder exists
                mkdir -p reports/robot

                # Activate virtual environment and run Robot tests
                . venv/bin/activate

                # Run Robot Framework UI tests
                robot -d reports/robot tests/ui
                '''
            }
        }

        stage('Run API Tests') {
            when {
                expression { return false } // Skipped for now, can enable later
            }
            steps {
                echo "Running API Tests..."
            }
        }

        stage('Run Performance Tests') {
            when {
                expression { return false } // Skipped for now, can enable later
            }
            steps {
                echo "Running Performance Tests..."
            }
        }
    }

    post {
        always {
            echo "Pipeline completed. Selected TEST_TYPE = ${TEST_TYPE}"
            // Archive reports
            archiveArtifacts artifacts: 'reports/robot/**', allowEmptyArchive: true
        }
        success {
            echo "All tests passed!"
        }
        failure {
            echo "Some tests failed. Check the reports for details."
        }
    }
}
