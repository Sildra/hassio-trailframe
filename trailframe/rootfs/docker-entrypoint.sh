#!/usr/bin/env bashio

DATA_PATH=$(bashio::config 'data_path')
PHOTOS_PATH=$(bashio::config 'photos_path')
PORT=$(bashio::config 'port')

# Check if HA supervisor started
# Workaround for supervisor race conditions on boot
bashio::config.require 'data_path'

if ! bashio::var.has_value "${PORT}"; then
    PORT=8000
fi

mkdir -p "${DATA_PATH}" || bashio::exit.nok "Could not create ${DATA_PATH}"

# Expose the configured photos folder as <data_path>/photos
# (--folder sets every library folder relative to the data folder)
if ! mkdir -p "${PHOTOS_PATH}" 2>/dev/null || [ ! -d "${PHOTOS_PATH}" ]; then
    bashio::log.warning "Photos folder ${PHOTOS_PATH} does not exist or is not writable."
fi
ln -sfn "${PHOTOS_PATH}" "${DATA_PATH}/photos" \
    || bashio::exit.nok "Could not link ${PHOTOS_PATH} into ${DATA_PATH}"

# Persistent virtualenv: Trailframe and its dependencies are installed from
# PyPI on first start and survive add-on updates (only the pinned version
# changes). The pin follows the add-on version: X.Y.Z-A -> trailframe==X.Y.Z.
VENV="${DATA_PATH}/venv"
ADDON_VERSION=$(bashio::addon.version 2>/dev/null || true)
if [ -n "${ADDON_VERSION}" ]; then
    PIN="trailframe==${ADDON_VERSION%%-*}"
else
    PIN="trailframe"
fi

bashio::log.info "Preparing Trailframe data folder..."

python -m venv "${VENV}" || bashio::exit.nok "Could not create ${VENV}"

# Guarded against strict-mode (set -e/-o pipefail): 'pip show' exits
# non-zero when the package is not installed yet.
INSTALLED=""
if "${VENV}/bin/pip" show trailframe > /dev/null 2>&1; then
    INSTALLED=$("${VENV}/bin/pip" show trailframe | awk '/^Version:/{print $2}')
fi
WANTED=${PIN#trailframe==}

if [ "${INSTALLED}" != "${WANTED}" ]; then
    bashio::log.info "Installing ${PIN} into ${VENV} (this can take a while on first start)..."
    "${VENV}/bin/pip" install --no-cache-dir --upgrade "${PIN}" \
        || bashio::exit.nok "Failed to install ${PIN}"
else
    bashio::log.info "Trailframe ${INSTALLED} already installed"
fi

export PATH="${VENV}/bin:${PATH}"
# Guarded against strict-mode: the supervisor API call can fail transiently
TIMEZONE=$(bashio::supervisor.timezone 2>/dev/null || true)
export TZ="${TIMEZONE:-UTC}"

# Publish the listening port for the container healthcheck
printf '%s' "${PORT}" > /var/run/trailframe.port

# Trailframe generates its own config.yaml on first start and manages it
# afterwards; all further settings are changed from its web UI.
cd "${DATA_PATH}" || bashio::exit.nok "Could not enter ${DATA_PATH}"
bashio::log.info "Starting Trailframe on port ${PORT}..."
exec python -m trailframe.main \
    --config "${DATA_PATH}/config.yaml" \
    --folder "${DATA_PATH}" \
    --port "${PORT}" \
    --database "${DATA_PATH}/gallery.db"
