FROM node:10-stretch

# versions
ARG ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
ARG ANDROID_SYSTEM_PACKAGE="android-28"
ARG ANDROID_BUILD_TOOLS_PACKAGE="build-tools;28.0.3"
ARG NATIVESCRIPT="nativescript@5.3.4"

# java 8
RUN apt-get update && \
    apt-get install -y unzip openjdk-8-jdk-headless vim usbutils --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/lib/apt/*

# android sdk tools
RUN cd /tmp && \
    wget --quiet $ANDROID_SDK_URL && \
    unzip -q sdk* && \
    mkdir -p /android-sdk && \
    mv tools /android-sdk/tools && \
    cd /android-sdk && \
    yes | tools/bin/sdkmanager --licenses >/dev/null && \
    tools/bin/sdkmanager \
        "tools" \
        "platform-tools" \
        "platforms;$ANDROID_SYSTEM_PACKAGE" \
        "$ANDROID_BUILD_TOOLS_PACKAGE" \
        "extras;google;m2repository" \
        "extras;android;m2repository" && \
    rm -rf /tmp/*

# nativescript
RUN npm install -g $NATIVESCRIPT && \
    tns usage-reporting disable && \
    tns error-reporting disable

ENV ANDROID_HOME=/android-sdk
