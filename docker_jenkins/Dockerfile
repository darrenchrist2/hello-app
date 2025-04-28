FROM jenkins/jenkins:2.492.3-jdk21

USER root

# Install docker CLI
RUN apt-get update && apt-get install -y lsb-release curl gnupg apt-transport-https ca-certificates

# Add Docker official GPG key and repo
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Install docker-ce-cli
RUN apt-get update && apt-get install -y docker-ce-cli

# Install kubectl using the official Kubernetes binary download
RUN curl -LO "https://dl.k8s.io/release/v1.27.3/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Verify kubectl installation
RUN kubectl version --client

# Switch back to Jenkins user
USER jenkins

# Install Jenkins plugins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
