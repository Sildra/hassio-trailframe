# Debian (glibc) base pinned to Python 3.12: required by the PyTorch/OpenCV
# wheels used by Trailframe's object-detection scanner.
FROM python:3.12-slim-bookworm

ENV LANG C.UTF-8

# Runtime libraries (libgl/libglib for opencv, libgomp for torch)
RUN apt-get update && apt-get install -y --no-install-recommends \
        tini \
        curl \
        ca-certificates \
        jq \
        libgl1 \
        libglib2.0-0 \
        libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# bashio (Home Assistant add-on scripting library)
RUN curl -sL -o /tmp/bashio.tar.gz https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz \
    && mkdir -p /tmp/bashio \
    && tar zxf /tmp/bashio.tar.gz --strip-components=1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -sf /usr/lib/bashio/bashio /usr/bin/bashio

COPY rootfs /

# Ensure the entrypoint is executable even when the repository was checked
# out on a filesystem that does not preserve permissions (e.g. Windows/NTFS)
RUN chmod 0755 /docker-entrypoint.sh

HEALTHCHECK --interval=1m --timeout=5s --start-period=10m --start-interval=5s \
  CMD curl -f "http://localhost:$(cat /var/run/trailframe.port 2>/dev/null || echo 8000)/" > /dev/null || exit 1

ENTRYPOINT [ "/usr/bin/tini", "--", "/usr/bin/env", "bashio", "/docker-entrypoint.sh" ]
