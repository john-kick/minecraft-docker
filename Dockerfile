# Lightweight Ubuntu base
FROM ubuntu:24.04

# Environment variables
ENV MINECRAFT_VERSION=latest \
	  SERVER_DIR=/minecraft \
		MIN_MEMORY=4G \
		MAX_MEMORY=4G \
		EULA=TRUE

# Install only base tools, not Java yet
RUN apt-get update && \
    apt-get install -y wget curl unzip jq apt-utils gnupg software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# Create server directory
WORKDIR ${SERVER_DIR}

# Download Minecraft server
RUN wget -O server.jar https://piston-data.mojang.com/v1/objects/6bce4ef400e4efaa63a13d5e6f6b500be969ef81/server.jar

# Accept EULA
RUN echo "eula=${EULA}" > eula.txt

# Expose default Minecraft port
EXPOSE 25565

# Copy optional server.properties file if exists
VOLUME ["${SERVER_DIR}"]

# Copy entrypoint script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Start Minecraft server
ENTRYPOINT ["/start.sh"]
