# Build with:
#   docker build -t linuxdroid/mininix-package-builder .
# Push to docker hub with:
#   docker push mininix/mininix-package-builder
# This is done after changing this file or any of the
# scripts/setup-{ubuntu,android-sdk}.sh setup scripts.
FROM ubuntu:18.10

# Fix locale to avoid warnings:
ENV LANG C.UTF-8

# Needed for setup:
COPY ./setup-ubuntu.sh /tmp/setup-ubuntu.sh
COPY ./setup-android-sdk.sh /tmp/setup-android-sdk.sh
COPY ./properties.sh /tmp/properties.sh

# Setup needed packages and the Android SDK and NDK:
RUN apt-get update && \
    apt-get -yq upgrade && \
    apt-get install -yq sudo && \
    adduser --disabled-password --shell /bin/bash --gecos "" builder && \
    echo "builder ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/builder && \
    chmod 0440 /etc/sudoers.d/builder && \
    su - builder -c /tmp/setup-ubuntu.sh && \
    su - builder -c /tmp/setup-android-sdk.sh && \
    # Removed unused parts to make a smaller Docker image:
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    cd /home/builder/lib/android-ndk/ && \
    rm -Rf sources/cxx-stl/system && \
    cd /home/builder/lib/android-sdk/tools && \
    rm -Rf emulator* lib* proguard templates && \
    /usr/sbin/update-ccache-symlinks && \
    echo 'export PATH="/usr/lib/ccache:$PATH"' | tee -a /home/builder/.bashrc && \
    export CPUS=$(grep -c ^processor /proc/cpuinfo) && export CPUS=$(($CPUS + 1)) && \
    sed -i "s/JOBS\=\"\"/JOBS\=\"${CPUS}\"/g" /etc/default/distcc && \
    sed -i "s/STARTDISTCC\=\"false\"/STARTDISTCC\=\"true\"/g" /etc/default/distcc && \
    sed -i "s/ALLOWEDNETS\=\"127.0.0.1\"/ALLOWEDNETS\=\"0.0.0.0\/0\"/g" /etc/default/distcc


# We expect this to be mounted with '-v $PWD:/home/builder/mininix-packages':
WORKDIR /home/builder/mininix-packages
