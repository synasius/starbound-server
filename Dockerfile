FROM ubuntu:16.04

MAINTAINER didstopia

# Fixes apt-get warnings
ARG DEBIAN_FRONTEND=noninteractive

# Setup the locales
RUN apt-get clean && apt-get update && apt-get install -y apt-utils locales && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

# Run a quick apt-get update/upgrade
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoremove -y

# Install dependencies, mainly for SteamCMD
RUN apt-get install -y \
    ca-certificates \
    software-properties-common \
    python-software-properties \
    lib32gcc1 \
    libstdc++6 \
    curl \
    wget \
    libvorbisfile3

# Run as root
USER root

# Create and set the steamcmd folder as a volume
RUN mkdir -p /steamcmd/starbound
VOLUME ["/steamcmd/starbound"]

# Add the steamcmd installation script
ADD install.txt /install.txt

# Copy the startup script
ADD start_starbound.sh /start.sh

# Set the current working directory
WORKDIR /

# Expose necessary ports
EXPOSE 21025/tcp

# Setup default environment variables for the server
ENV STEAM_USERNAME ""
ENV STEAM_PASSWORD ""

# Start the server
ENTRYPOINT ["./start.sh"]
