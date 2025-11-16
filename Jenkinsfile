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
                powershell '''
                    python -m venv robotenv
                    .\\robotenv\\Scripts\\activate
                    python -m pip install --upgrade pip
                    pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager robotframework-requests
                '''
            }
        }

        stage('Run Robot UI Tests') {
            when {
                expression { params.TEST_TYPE == 'UI' || params.TEST_TYPE == 'BOTH' }
            }
            steps {
                powershell '''
                    .\\robotenv\\Scripts\\activate
                    mkdir results
                    robot -d results tests\\ui
                '''
            }
        }

        stage('Run Robot API Tests') {
            when {
                expression { params.TEST_TYPE == 'API' || params.TEST_TYPE == 'BOTH' }
            }
            steps {
                powershell '''
                    .\\robotenv\\Scripts\\activate
                    mkdir results
                    robot -d results tests\\api
                '''
            }
        }

        stage('Run k6 Performance Test') {
            when {
                expression { params.TEST_TYPE == 'BOTH' }
            }
            steps {
                powershell '''
                    mkdir k6_results
                    k6 run --out json=k6_results\\perf.json tests\\perf\\load_test.js
                '''
            }
        }

        stage('Publish Reports') {
            steps {
                archiveArtifacts artifacts: 'results/*.html', allowEmptyArchive: true
                archiveArtifacts artifacts: 'k6_results/*.json', allowEmptyArchive: true

                robot outputPath: 'results',
                      outputFileName: 'output.xml',
                      logFileName: 'log.html',
                      reportFileName: 'report.html',
                      passThreshold: 100,
                      unstableThreshold: 80
            }
        }
    }

    post {
        always {
            echo "Build completed. Check results/ folder, Jenkins Robot report, and k6_results/ folder."
        }
    }
}
