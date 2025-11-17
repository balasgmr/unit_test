FROM jenkins/jenkins:lts

USER root

# -----------------------------------------------------
# Install Python3, pip, venv, Chromium browser & driver
# -----------------------------------------------------
RUN apt-get update && \
    apt-get install -y \
        python3 python3-venv python3-pip \
        chromium chromium-driver \
        curl gnupg software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------
# Install k6 performance testing tool
# -----------------------------------------------------
RUN curl -s https://dl.k6.io/key.gpg | apt-key add - && \
    echo "deb https://dl.k6.io/deb stable main" | tee /etc/apt/sources.list.d/k6.list && \
    apt-get update && \
    apt-get install -y k6 && \
    rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------
# Add Jenkins user to group 0 so it can access docker.sock
# -----------------------------------------------------
RUN usermod -aG 0 jenkins

# -----------------------------------------------------
# Give docker.sock group read/write access (ignore if fails)
# -----------------------------------------------------
RUN chmod 660 /var/run/docker.sock || true

# Fix possible permission issues on Jenkins home
RUN chown -R jenkins:jenkins /var/jenkins_home

USER jenkins
