# Minecraft Server

- A lightweight, Ubuntu-based Docker image for running a customizable Minecraft server.
- Dynamic version support – specify MINECRAFT_VERSION (release or snapshot) when starting a container, and the correct server JAR will be downloaded automatically.
- Automatic Java installation – the container fetches and installs the required Java version based on Mojang’s metadata.
- Persistent worlds – mount a host directory to /minecraft to store worlds and configs outside the container.

## Quick start

```bash
docker run -d \
  -p 25565:25565 \
  -v ~/minecraft-data:/minecraft \
  --name mc-server \
  andrel0104/minecraft-server:latest
```

This makes it easy to spin up different Minecraft versions on demand, keep your worlds safe, and share your setup across machines.

## Environment Variables

| Name              | Description                                                                                   | Type    | Default      |
| ----------------- | --------------------------------------------------------------------------------------------- | ------- | ------------ |
| MINECRAFT_VERSION | The Minecraft version to use. Can be a full version or a snapshot (e.g. `1.21.8` or `25w33a`) | string  | `latest`     |
| SERVER_DIR        | The directory inside the container containing the server files                                | string  | `/minecraft` |
| MIN_MEMORY        | The minimum amount of RAM the server should use                                               | string  | `4g`         |
| MAX_MEMORY        | The maximum amount of RAM the server should use                                               | string  | `4g`         |
| EULA              | Wether to accept the EULA. Should be set to true                                              | boolean | `true`       |
