FROM jenkins/jenkins:lts

USER root

# Install Python, pip, Chromium, drivers, curl, gnupg
RUN apt-get update && \
    apt-get install -y python3 python3-venv python3-pip chromium chromium-driver \
                       curl gnupg software-properties-common

# Install k6
RUN curl -s https://dl.k6.io/key.gpg | apt-key add - && \
    echo "deb https://dl.k6.io/deb stable main" | tee /etc/apt/sources.list.d/k6.list && \
    apt-get update && apt-get install -y k6

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y docker.io && \
    usermod -aG docker jenkins

# Permissions
RUN chown -R jenkins:jenkins /var/jenkins_home

USER jenkins
