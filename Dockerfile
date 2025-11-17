FROM jenkins/jenkins:lts

USER root

# ---------------------------------------------------------
# Install Python, pip, Selenium dependencies, Chromium
# ---------------------------------------------------------
RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-venv \
        python3-pip \
        chromium \
        chromium-driver \
        curl \
        gnupg \
        software-properties-common \
        docker.io && \
    rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------
# Install k6
# ---------------------------------------------------------
RUN curl -s https://dl.k6.io/key.gpg | apt-key add - && \
    echo "deb https://dl.k6.io/deb stable main" | tee /etc/apt/sources.list.d/k6.list && \
    apt-get update && \
    apt-get install -y k6 && \
    rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------
# Add Jenkins user to docker group (IMPORTANT!)
# Allows Jenkins pipeline to run: docker run ...
# ---------------------------------------------------------
RUN groupadd -f docker && \
    usermod -aG docker jenkins

# Fix permissions
RUN chown -R jenkins:jenkins /var/jenkins_home

USER jenkins
