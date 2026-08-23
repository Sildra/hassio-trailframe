ARG BUILD_FROM
FROM $BUILD_FROM AS base

ENV LANG C.UTF-8
ARG BUILD_VERSION

RUN apt-get update && apt-get install -y --no-install-recommends \
        tini \
        curl \
        ca-certificates \
        jq \
        libgl1 \
        libglib2.0-0 \
        libgomp1 \
    && rm -rf /var/lib/apt/lists/* \
    # Validation to confirm that curl and jq are installed.
    && curl --version > /dev/null \
    && jq --version

# Install bashio (Home Assistant add-on scripting library)
RUN curl -sL -o /tmp/bashio.tar.gz https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz \
    && mkdir -p /tmp/bashio \
    && tar zxf /tmp/bashio.tar.gz --strip-components=1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -sf /usr/lib/bashio/bashio /usr/bin/bashio

# Dependencies and build
FROM base AS dependencies_and_build

ARG BUILD_VERSION

# Node.js is required to build the web UI when installing the edge version.
ARG NODE_VERSION=22.14.0

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        xz-utils \
        build-essential \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONUNBUFFERED=1
# Virtualenv shared with the release stage
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app

RUN if [ "${BUILD_VERSION}" = "edge" ]; \
    then \
        echo "Installing Edge version" \
        && TARGETARCH=$(uname -m | sed 's/x86_64/x64/;s/aarch64/arm64/') \
        && curl -sL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${TARGETARCH}.tar.gz" \
            | tar zxC /usr/local --strip-components=1 \
        && git clone --single-branch --depth 1 \
            https://github.com/sildra/trailframe.git /app \
        && cd frontend \
        && npm ci --unsafe-perm \
        && npm run build \
        && cd /app \
        && pip install --no-cache-dir . ; \
    else \
        TRAILFRAME_VERSION="${BUILD_VERSION%-*}" \
        && echo "Installing Stable version ${TRAILFRAME_VERSION} from PyPI" \
        && pip install --no-cache-dir "trailframe==${TRAILFRAME_VERSION}" ; \
    fi

# Release
FROM base AS release

COPY rootfs /

COPY --from=dependencies_and_build /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /app

HEALTHCHECK --interval=1m --timeout=5s --start-period=2m --start-interval=5s \
  CMD curl -f "http://localhost:$(cat /var/run/trailframe.port 2>/dev/null || echo 8000)/" > /dev/null || exit 1

ENTRYPOINT [ "/usr/bin/tini", "--", "/docker-entrypoint.sh" ]
