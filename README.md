[![GitHub Release](https://img.shields.io/github/release/sildra/hassio-trailframe.svg?style=for-the-badge)](https://github.com/sildra/hassio-trailframe/releases)
[![GitHub Activity](https://img.shields.io/github/commit-activity/y/sildra/hassio-trailframe.svg?style=for-the-badge)](https://github.com/sildra/hassio-trailframe/commits/main)
[![License](https://img.shields.io/github/license/sildra/hassio-trailframe.svg?style=for-the-badge)](LICENSE)

# Trailframe Home Assistant add-on

Home Assistant add-ons for [Trailframe](https://github.com/sildra/trailframe), a
self-hosted photo gallery for people who move: photos and GPS activities
(Garmin Connect / GPX) live side by side, linked by time and place.

The repository contains two add-ons:

| Add-on | Description | Recommended |
| --- | --- | --- |
| [Trailframe](trailframe/) | Stable release tracking released versions of Trailframe | ✔️ For most users |
| [Trailframe Edge](trailframe-edge/) | Development build tracking the `main` branch of Trailframe | For testing |

## Installation

1. In Home Assistant go to **Settings → Add-ons → Add-on Store**, click **⋮ →
   Repositories**, fill in `https://github.com/sildra/hassio-trailframe` and
   click **Add → Close**.
2. Click on the add-on and press **Install**. Note that the first build/install
   can take a long time (the image includes PyTorch/ultralytics used by the
   object-detection scanner).
3. Configure the add-on (at minimum the `photos_path` option) and start it.
4. The web UI is available on port `8000` (default) of your Home Assistant
   host: `http://homeassistant.local:8000` — the port is configurable via the
   add-on's `port` option and *Network* settings.

For more information see the [documentation](trailframe/DOCS.md).

## Credits

Repository structure modeled after
[hassio-zigbee2mqtt](https://github.com/zigbee2mqtt/hassio-zigbee2mqtt).
