[![GitHub Release](https://img.shields.io/github/release/sildra/hassio-trailframe.svg?style=for-the-badge)](https://github.com/sildra/hassio-trailframe/releases)
[![GitHub Activity](https://img.shields.io/github/commit-activity/y/sildra/hassio-trailframe.svg?style=for-the-badge)](https://github.com/sildra/hassio-trailframe/commits/main)
[![License](https://img.shields.io/github/license/sildra/hassio-trailframe.svg?style=for-the-badge)](LICENSE)

# Trailframe Home Assistant app

Home Assistant app for [Trailframe](https://github.com/sildra/trailframe), a
self-hosted photo gallery for people who move: photos and GPS activities
(Garmin Connect / GPX) live side by side, linked by time and place.

The app has no published images and no CI: Home Assistant builds it locally
on your device at install time, and Trailframe itself (with all its Python
dependencies) is installed from PyPI into a virtualenv stored in the app's
persistent data folder on first start.

## Installation

1. In Home Assistant go to **Settings → Apps → App Store**, click **⋮ →
   Repositories**, fill in `https://github.com/sildra/hassio-trailframe` and
   click **Add → Close**.
2. Click on the **Trailframe** app and press **Install**. The image build
   is quick; the bulk of the work happens at first start.
3. Configure the app (at minimum the `photos_path` option) and start it.
   The first start takes several minutes: the dependencies include PyTorch
   and are installed into `/data/trailframe/venv` (an internet connection is
   required).
4. The web UI is available on port `8000` (default) of your Home Assistant
   host: `http://homeassistant.local:8000` — the port is configurable via the
   app's `port` option and *Network* settings.

For more information see the [documentation](trailframe/DOCS.md).

## Updating Trailframe

The `version` of the app (`X.Y.Z-A`) pins the packaged Trailframe version:
the part before the dash is what gets installed from PyPI. To ship a new
Trailframe release, bump `version` in [`trailframe/config.json`](trailframe/config.json)
and commit — users get the update through the regular app updater.

## Credits

Repository structure modeled after
[hassio-zigbee2mqtt](https://github.com/zigbee2mqtt/hassio-zigbee2mqtt).
