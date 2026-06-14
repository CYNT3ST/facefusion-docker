FaceFusion Docker
=================

> Industry leading face manipulation platform.

[![Build Status](https://img.shields.io/github/actions/workflow/status/facefusion/facefusion-docker/ci.yml.svg?branch=master)](https://github.com/facefusion/facefusion-docker/actions?query=workflow:ci)
[![Docker Hub](https://img.shields.io/docker/v/facefusion/facefusion/3.6.1-cpu?label=docker-hub)](https://hub.docker.com/r/facefusion/facefusion/tags?name=3.6.1-cpu)
[![Docker Hub](https://img.shields.io/docker/v/facefusion/facefusion/3.6.1-cuda?label=docker-hub)](https://hub.docker.com/r/facefusion/facefusion/tags?name=3.6.1-cuda)
[![Docker Hub](https://img.shields.io/docker/v/facefusion/facefusion/3.6.1-tensorrt?label=docker-hub)](https://hub.docker.com/r/facefusion/facefusion/tags?name=3.6.1-tensorrt)
[![Docker Hub](https://img.shields.io/docker/v/facefusion/facefusion/3.6.1-rocm?label=docker-hub)](https://hub.docker.com/r/facefusion/facefusion/tags?name=3.6.1-rocm)
![License](https://img.shields.io/badge/license-OpenRAIL--S-green)


Installation
------------

Clone the repository:

```
git clone https://github.com/facefusion/facefusion-docker.git
```

Run the `CPU` container:

```
docker compose -f docker-compose.cpu.yml up
```

Run the `CUDA` container:

```
docker compose -f docker-compose.cuda.yml up
```

Run the `TensorRT` container:

```
docker compose -f docker-compose.tensorrt.yml up
```

Run the `ROCm` container:

```
docker compose -f docker-compose.rocm.yml up
```

Run the `CPU` container in `hardened` mode:

```
docker compose -f docker-compose.cpu.yml -f docker-compose.cpu.hardened.yml up
```

Run the `CUDA` container in `hardened` mode:

```
docker compose -f docker-compose.cuda.yml -f docker-compose.cuda.hardened.yml up
```

Run the `TensorRT` container in `hardened` mode:

```
docker compose -f docker-compose.tensorrt.yml -f docker-compose.tensorrt.hardened.yml up
```

Run the `ROCm` container in `hardened` mode:

```
docker compose -f docker-compose.rocm.yml -f docker-compose.rocm.hardened.yml up
```

`hardened` mode changes:

- Binds UI ports to `127.0.0.1` only.
- Drops all Linux capabilities and blocks privilege escalation.
- Uses a read-only root filesystem and a tmpfs for `/tmp`.
- Uses an internal Docker network (no outbound internet access).

If this is your first run, start once without the hardened overlay to allow model downloads into `.assets`, then switch back to the hardened overlay.

Use the bootstrap and offline lock script for this workflow:

```
powershell -ExecutionPolicy Bypass -File .\bootstrap-offline-lock.ps1 -Runtime cpu
```

Choose a runtime with `-Runtime cpu|cuda|tensorrt|rocm`.

Optional flags:

- `-Build` builds images before bootstrap and startup.
- `-SkipBootstrap` skips the online download step and starts hardened mode directly.
- `-Foreground` runs `docker compose up` in foreground mode.

What the script does:

1. Stops existing containers for the selected runtime.
2. Runs an explicit online `force-download` step to populate `.assets`.
3. Starts the hardened profile with outbound networking disabled.


Usage
-----

Browse the `CPU` container:

```
http://localhost:7865
```

Browse the `CUDA` container:

```
http://localhost:7870
```

Browse the `TensorRT` container:

```
http://localhost:7875
```

Browse the `ROCm` container:

```
http://localhost:7880
```


Documentation
-------------

Read the [documentation](https://docs.facefusion.io) for a deep dive.
