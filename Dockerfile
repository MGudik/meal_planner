FROM jenkins/agent:latest-jdk11

USER root

ENV ANDROID_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip"
ENV ANDROID_VERSION="29"
ENV ANDROID_BUILD_TOOLS_VERSION="29.0.3"
ENV ANDROID_ARCHITECTURE="x86_64"
ENV ANDROID_SDK_ROOT="/home/jenkins/android"
ENV PATH="$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/platforms:/home/jenkins/flutter/bin:$PATH"

# install all dependencies
ENV DEBIAN_FRONTEND="noninteractive"

# Install necessary packages
RUN apt-get update && apt-get install -y openjdk-17-jdk

RUN apt-get update && \
    apt-get install -y bash curl file git unzip xz-utils zip libglu1-mesa cmake ninja-build clang libgtk-3-dev

WORKDIR /home/jenkins

# android sdk
RUN mkdir -p $ANDROID_SDK_ROOT \
  && mkdir -p /home/$USER/.android \
  && touch /home/$USER/.android/repositories.cfg \
  && curl -o android_tools.zip $ANDROID_TOOLS_URL \
  && unzip -qq -d "$ANDROID_SDK_ROOT" android_tools.zip \
  && rm android_tools.zip \
  && mkdir -p $ANDROID_SDK_ROOT/cmdline-tools/tools \
  && mv $ANDROID_SDK_ROOT/cmdline-tools/bin $ANDROID_SDK_ROOT/cmdline-tools/tools \
  && mv $ANDROID_SDK_ROOT/cmdline-tools/lib $ANDROID_SDK_ROOT/cmdline-tools/tools \
  && yes "y" | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
  && yes "y" | sdkmanager "platforms;android-$ANDROID_VERSION" \
  && yes "y" | sdkmanager "platform-tools" \
  && yes "y" | sdkmanager "emulator" \
  && yes "y" | sdkmanager "system-images;android-$ANDROID_VERSION;google_apis_playstore;$ANDROID_ARCHITECTURE"

RUN sdkmanager --install "cmdline-tools;latest"

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b master

RUN flutter doctor --android-licenses

RUN flutter doctor 

RUN flutter config --no-analytics && \
    flutter precache
RUN flutter --disable-analytics

RUN chown -R jenkins:jenkins /home/jenkins/flutter
RUN chown -R jenkins:jenkins /home/jenkins/android

USER jenkins
WORKDIR /home/jenkins


CMD ["/bin/bash"]