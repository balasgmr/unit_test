pipeline {
    agent any

    stages {

        stage('Setup Environment') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y chromium chromium-driver python3-venv

                    # Create a virtual environment
                    python3 -m venv robotenv

                    # Activate venv
                    . robotenv/bin/activate

                    # Install dependencies inside venv
                    pip install --upgrade pip --break-system-packages
                    pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager --break-system-packages
                '''
            }
        }

        stage('Run Headless UI Tests') {
            steps {
                sh '''
                    . robotenv/bin/activate

                    export BROWSER=chromium

                    robot -d results tests/
                '''
            }
        }

        stage('Publish Report') {
            steps {
                publishHTML([
                    reportDir: 'results',
                    reportFiles: 'report.html',
                    reportName: 'Robot Report',
                    allowMissing: false,
                    keepAll: true,
                    alwaysLinkToLastBuild: true
                ])
            }
        }
    }
}
