#!/bin/bash
echo "Starting Minecraft server for version: ${MINECRAFT_VERSION}"

MANIFEST_URL="https://launchermeta.mojang.com/mc/game/version_manifest.json"
VERSION_MANIFEST=$(curl -s $MANIFEST_URL)

if [ "$MINECRAFT_VERSION" == "latest" ]; then
		VERSION=$(echo $VERSION_MANIFEST | jq -r '.latest.release')
else
		VERSION=$MINECRAFT_VERSION
fi

echo "Resolved version: $VERSION"

VERSION_URL=$(echo $VERSION_MANIFEST | jq -r --arg v "$VERSION" '.versions[] | select(.id==$v) | .url')
if [ -z "$VERSION_URL" ]; then
    echo "Error: Could not find version $VERSION"
    exit 1
fi

# Get server + Java version
VERSION_JSON=$(curl -s $VERSION_URL)
SERVER_URL=$(echo $VERSION_JSON | jq -r '.downloads.server.url')
JAVA_VERSION=$(echo $VERSION_JSON | jq -r '.javaVersion.majorVersion')

echo "Server requires Java $JAVA_VERSION"

# Install Java dynamically if not present
if ! command -v java >/dev/null || ! java -version 2>&1 | grep -q "openjdk version \"$JAVA_VERSION"; then
    echo "Installing OpenJDK $JAVA_VERSION..."
    apt-get update
    apt-get install -y openjdk-${JAVA_VERSION}-jre-headless
fi

# Figure out path to installed java
JAVA_BIN=$(update-alternatives --list java | grep "java-${JAVA_VERSION}-" | head -n 1)
if [ -z "$JAVA_BIN" ]; then
    echo "Could not find java binary for version $JAVA_VERSION"
    exit 1
fi

if [ ! -f "server-${VERSION}.jar" ]; then
		echo "Downloading server jar for $VERSION..."
		curl -o server-${VERSION}.jar $SERVER_URL
		ln -sf server-${VERSION}.jar server.jar
fi

echo "eula=${EULA}" > eula.txt

exec java -Xmx${MAX_MEMORY} -Xms${MIN_MEMORY} -jar server.jar nogui