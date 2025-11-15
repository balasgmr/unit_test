FROM jenkins/jenkins:lts

USER root

# Install Python3, pip, virtualenv, Chromium browser, and drivers
RUN apt-get update && \
    apt-get install -y python3 python3-venv python3-pip chromium chromium-driver && \
    rm -rf /var/lib/apt/lists/*

USER jenkins
