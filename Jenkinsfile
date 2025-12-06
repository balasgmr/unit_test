pipeline {
    agent {
        docker {
            image 'python:3.11-slim'
            args '--shm-size=2g'  // Required for Chrome headless
        }
    }

    environment {
        TEST_TYPE = "UI"
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                apt-get update && apt-get install -y wget unzip curl gnupg
                # Install Chrome
                wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
                echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
                apt-get update && apt-get install -y google-chrome-stable
                # Install matching ChromeDriver
                CHROME_VERSION=$(google-chrome --version | grep -oP '\\d+\\.\\d+\\.\\d+')
                LATEST_DRIVER=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION")
                wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/$LATEST_DRIVER/chromedriver_linux64.zip"
                unzip /tmp/chromedriver.zip -d /usr/local/bin/

                python3 -m venv venv
                . venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                '''
            }
        }

        stage('Run UI Tests') {
            steps {
                sh '''
                . venv/bin/activate
                mkdir -p reports/robot
                robot -d reports/robot tests/ui
                '''
            }
        }

        stage('Run API Tests') {
            steps {
                sh '''
                . venv/bin/activate
                robot -d reports/robot tests/api
                '''
            }
        }

        stage('Run Performance Tests') {
            steps {
                sh '''
                . venv/bin/activate
                robot -d reports/robot tests/performance
                '''
            }
        }
    }

    post {
        always {
            robot outputPath: 'reports/robot'
        }
    }
}
