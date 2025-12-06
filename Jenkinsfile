pipeline {
    agent {
        docker {
            image 'sambacha/robotframework-chrome:latest'  // prebuilt Robot + Chrome image
            args '--shm-size=2g'  // prevents Chrome crashes in Docker
        }
    }

    environment {
        TEST_TYPE = "UI"
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
            steps {
                echo "Running UI Tests..."
                sh """
                mkdir -p reports/robot
                . venv/bin/activate
                robot -d reports/robot tests/ui
                """
            }
        }

        stage('Run API Tests') {
            steps {
                echo "Running API Tests..."
                sh """
                . venv/bin/activate
                robot -d reports/robot tests/api
                """
            }
        }

        stage('Run Performance Tests') {
            steps {
                echo "Running Performance Tests..."
                sh """
                . venv/bin/activate
                robot -d reports/robot tests/performance
                """
            }
        }
    }

    post {
        always {
            echo "Publishing Robot results..."
            robot outputPath: 'reports/robot'
        }
    }
}
