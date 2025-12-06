FROM jenkins/jenkins:lts

USER root

# Install Python + pip + git
RUN apt-get update && apt-get install -y python3 python3-venv python3-pip git

# Copy requirements and install them in a global venv
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install -r /tmp/requirements.txt

ENV PATH="/opt/venv/bin:$PATH"

USER jenkins
