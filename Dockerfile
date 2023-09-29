FROM jenkins/agent:latest-jdk11

USER root
WORKDIR /home/jenkins

# Install Flutter
RUN apt-get update && \
    apt-get install -y bash curl file git unzip xz-utils zip libglu1-mesa cmake ninja-build clang libgtk-3-dev && \
    git clone https://github.com/flutter/flutter.git -b master

ENV PATH="$PATH:/home/jenkins/flutter/bin"

RUN flutter config --no-analytics && \
    flutter precache
RUN flutter --disable-analytics

RUN chown -R jenkins:jenkins /home/jenkins/flutter

USER jenkins

WORKDIR /home/jenkins

#ENTRYPOINT ["/bin/bash", "-c"]