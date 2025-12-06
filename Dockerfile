FROM jenkins/jenkins:lts

USER root

# Install system dependencies
RUN apt-get update && \
    apt-get install -y python3 python3-venv python3-pip git curl wget unzip xvfb

# Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt install -y ./google-chrome-stable_current_amd64.deb

# Copy requirements
COPY requirements.txt /tmp/requirements.txt

# Create virtual environment and install Python packages
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install -r /tmp/requirements.txt

# Add virtual environment to PATH
ENV PATH="/opt/venv/bin:$PATH"

USER jenkins
