pipeline {
    agent {
        docker {
            image 'python:3.10'
            args '-u root'
        }
    }

    stages {

        stage('Setup') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y curl unzip wget gnupg

                    # Install Chromium & ChromeDriver
                    apt-get install -y chromium chromium-driver

                    # Upgrade pip + Install Robot Dependencies
                    pip install --upgrade pip
                    pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    mkdir -p results

                    export CHROME_BIN=/usr/bin/chromium
                    export CHROMEDRIVER=/usr/bin/chromedriver

                    # Run Robot Framework tests
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
