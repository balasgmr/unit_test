FROM jenkins/jenkins:lts

USER root

# Install Python3, pip, virtualenv, Chromium, drivers, and k6
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-venv \
        python3-pip \
        chromium \
        chromium-driver \
        curl \
        gnupg \
        software-properties-common && \
    curl -s https://dl.k6.io/key.gpg | apt-key add - && \
    echo "deb https://dl.k6.io/deb stable main" | tee /etc/apt/sources.list.d/k6.list && \
    apt-get update && apt-get install -y k6 && \
    rm -rf /var/lib/apt/lists/*

# Selenium environment variables
ENV CHROME_BIN=/usr/bin/chromium
ENV CHROME_PATH=/usr/lib/chromium/

USER jenkins
