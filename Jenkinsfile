pipeline {
    agent any

    stages {
        stage('Setup') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y python3-pip curl unzip wget gnupg

                    # Install Chromium manually for Debian Bookworm
                    apt-get install -y chromium chromium-driver

                    # Upgrade pip & install Robot Framework dependencies
                    pip install --upgrade pip
                    pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    mkdir -p results
                    export PATH=$PATH:/usr/bin
                    export CHROME_BIN=/usr/bin/chromium
                    export CHROMEDRIVER=/usr/bin/chromedriver

                    # Run Robot Framework tests in headless mode
                    robot -v BROWSER:headlesschrome -d results tests/
                '''
            }
        }

        stage('Archive Reports') {
            steps {
                archiveArtifacts artifacts: 'results/*', fingerprint: true
                publishHTML(target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'results',
                    reportFiles: 'report.html',
                    reportName: 'Robot Framework Report'
                ])
            }
        }
    }
}
