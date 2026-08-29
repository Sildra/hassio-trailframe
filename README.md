[![Trailframe Release](https://img.shields.io/github/release/sildra/trailframe.svg?style=for-the-badge)](https://github.com/sildra/trailframe/releases)
[![GitHub-Activity](https://img.shields.io/github/commit-activity/y/sildra/hassio-trailframe.svg?style=for-the-badge)](https://github.com/sildra/hassio-trailframe/commits/main)
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

For more information see the [documentation](trailframe/DOCS.md).

## Updating Trailframe

The `version` of the app (`X.Y.Z-A`) pins the packaged Trailframe version:
the part before the dash is what gets installed from PyPI. To ship a new
Trailframe release, bump `version` in [`trailframe/config.json`](trailframe/config.json)
and commit — users get the update through the regular app updater.

## Trailframe in a card

[![IFrame card Release](https://img.shields.io/github/release/lovelylain/ha-addon-iframe-card.svg?style=for-the-badge)](https://github.com/lovelylain/ha-addon-iframe-card)

Once the app is installed and running, you can embed the (standalone kiosk) slideshow
in a dashboard card with
[addon-iframe-card](https://github.com/lovelylain/ha-addon-iframe-card).

Install that card from HACS:

1. In Home Assistant go to **HACS → ⋮ → Custom repositories** and add
   `https://github.com/lovelylain/ha-addon-iframe-card` with category **Lovelace**.
2. Then install **addon-iframe-card** from HACS and reload your dashboard.

Example card config (slideshow menu, custom section):

```yaml
type: custom:addon-iframe-card
url: f6a361ef_trailframe/slideshow.html?section=custom
aspect_ratio: 100%
grid_options:
  columns: full
  rows: 8
```

The `f6a361ef_trailframe` part is the slug of the installed app (uppercase `_`
in the slug) plus the app name; adjust it to whatever the addon slug of your
installation is. The URL can use any of the supported slideshow parameters, e.g.
`?section=custom&start=1` for a self-starting custom slideshow, `?controls=hide`
and `?map=hide` to hide the control bar and map, or a `?photos=...` deep link.

## Credits

Repository structure modeled after
[hassio-zigbee2mqtt](https://github.com/zigbee2mqtt/hassio-zigbee2mqtt).
