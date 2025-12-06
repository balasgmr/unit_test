pipeline {
    agent any

    environment {
        VENV_DIR = "venv"
        TEST_TYPE = "UI"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Chrome + ChromeDriver') {
            steps {
                sh """
                apt-get update
                apt-get install -y wget unzip curl

                echo "Installing Chrome..."
                wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
                apt-get install -y ./google-chrome-stable_current_amd64.deb || apt --fix-broken install -y

                echo "Chrome version:"
                google-chrome --version

                echo "Detecting Chrome major version..."
                CHROME_MAJOR=\$(google-chrome --version | grep -oP '\\d+' | head -1)

                echo "Getting matching ChromeDriver..."
                DRIVER_VERSION=\$(curl -s https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_\$CHROME_MAJOR)

                echo "ChromeDriver version: \$DRIVER_VERSION"

                wget -O chromedriver.zip https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/\$DRIVER_VERSION/linux64/chromedriver-linux64.zip
                unzip chromedriver.zip
                mv chromedriver-linux64/chromedriver /usr/bin/chromedriver
                chmod +x /usr/bin/chromedriver

                /usr/bin/chromedriver --version
                """
            }
        }

        stage('Install Dependencies') {
            steps {
                sh """
                python3 -m venv ${VENV_DIR}
                . ${VENV_DIR}/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                """
            }
        }

        stage('Run UI Tests') {
            steps {
                sh """
                . ${VENV_DIR}/bin/activate
                mkdir -p reports/robot
                robot -d reports/robot tests/ui
                """
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/**', allowEmptyArchive: true
        }
    }
}
