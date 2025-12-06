FROM jenkins/jenkins:lts

USER root

# Install essential tools
RUN apt-get update && \
    apt-get install -y python3 python3-pip git curl wget unzip xvfb

# Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb



# Install Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

USER jenkins
