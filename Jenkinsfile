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

        // ------------------------------
        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/balasgmr/robot_jenkins_poc.git', branch: 'main'
            }
        }

        // ------------------------------
        stage('Run Robot Tests') {
            steps {
                script {
                    if (params.TEST_TYPE == 'UI' || params.TEST_TYPE == 'BOTH') {
                        sh '''
                        docker run --rm -v $WORKSPACE:/workspace -w /workspace python:3.11-slim bash -c "
                            python3 -m venv robotenv &&
                            . robotenv/bin/activate &&
                            pip install --upgrade pip &&
                            pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager robotframework-requests &&
                            mkdir -p results &&
                            robot -d results tests/ui
                        "
                        '''
                    }

                    if (params.TEST_TYPE == 'API' || params.TEST_TYPE == 'BOTH') {
                        sh '''
                        docker run --rm -v $WORKSPACE:/workspace -w /workspace python:3.11-slim bash -c "
                            python3 -m venv robotenv &&
                            . robotenv/bin/activate &&
                            pip install --upgrade pip &&
                            pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager robotframework-requests &&
                            mkdir -p results &&
                            robot -d results tests/api
                        "
                        '''
                    }
                }
            }
        }

        // ------------------------------
        stage('Run k6 Performance Test') {
            when {
                expression { return params.TEST_TYPE == 'BOTH' }
            }
            steps {
                // Run k6 test and save JSON summary
                sh '''
                mkdir -p k6_results
                docker run --rm -v $WORKSPACE:/workspace -w /workspace loadimpact/k6:latest \
                    k6 run --summary-export=k6_results/perf_summary.json tests/perf/load_test.js
                '''

                // Convert JSON summary to nicer HTML report
                sh '''
                python3 - <<EOF
import json
summary_file = 'k6_results/perf_summary.json'
html_file = 'k6_results/perf_report.html'

with open(summary_file) as f:
    data = json.load(f)

html = "<html><head><title>k6 Performance Report</title></head><body>"
html += "<h2>k6 Performance Summary</h2>"
html += "<table border='1' cellpadding='5' cellspacing='0'>"
html += "<tr><th>Metric</th><th>Value</th></tr>"

# Show important metrics in a readable format
metrics_to_show = ['iterations', 'vus_max', 'http_reqs', 'http_req_failed', 'http_req_duration']

for key in metrics_to_show:
    value = data.get(key, 'N/A')
    html += f"<tr><td>{key}</td><td>{value}</td></tr>"

html += "</table></body></html>"

with open(html_file, 'w') as f:
    f.write(html)
EOF
                '''
            }
        }

        // ------------------------------
        stage('Publish Reports') {
            steps {
                // Archive Robot Framework reports
                archiveArtifacts artifacts: 'results/*.html', allowEmptyArchive: true
                // Archive k6 report
                archiveArtifacts artifacts: 'k6_results/*.html', allowEmptyArchive: true

                // Jenkins Robot plugin integration
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
