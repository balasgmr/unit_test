FROM jenkins/jenkins:lts

USER root

# Install Chrome + dependencies
RUN apt-get update && apt-get install -y wget gnupg unzip xvfb \
    libnss3 libgconf-2-4 fonts-liberation libxss1 libappindicator3-1 xdg-utils

# Install Google Chrome
RUN wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install -y /tmp/google-chrome.deb \
    && rm /tmp/google-chrome.deb

# Install Python and venv
RUN apt-get install -y python3 python3-venv python3-pip git curl

# Copy requirements and install venv
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install -r /tmp/requirements.txt

ENV PATH="/opt/venv/bin:$PATH"

USER jenkins
