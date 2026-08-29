# Home Assistant app: Trailframe

[![Open your Home Assistant instance and show the app repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fsildra%2Fhassio-trailframe)

Trailframe is a self-hosted photo gallery for people who move: photos and GPS
activities (Garmin Connect / GPX) live side by side, linked by time and place.

This app installs the stable release of Trailframe. See the upstream
project for the full feature list:

https://github.com/sildra/trailframe

## Installation

Follow these steps to get the app installed on your system:

1. In Home Assistant go to **Settings → Apps → App Store**, click **⋮ →
   Repositories**, fill in `https://github.com/sildra/hassio-trailframe` and
   click **Add → Close**.
2. Click on the **Trailframe** app and press **Install**. Home Assistant
   builds the small container image locally on your device.
3. Configure the app (see *Configuration* below) — at minimum make sure the
   `photos_path` points to a folder containing your photos.
4. Start the app. On **first start** Trailframe and its Python
   dependencies (including PyTorch, ~2 GB) are installed from PyPI into the
   persistent `<data_path>/venv` — this takes several minutes and needs
   an internet connection. Later starts are fast, and app updates reuse
   the virtualenv unless the pinned version changed.

> The web UI is not exposed through the Home Supervisor ingress sidebar but on
> its own port, since the frontend currently requires being served from the
> site root. The port is only reachable from your local network unless you
> deliberately expose it.

## Configuration

**Note**: *Remember to restart the app when the configuration is changed.*

The app configuration is intentionally minimal — only the two options that
map to Trailframe's command-line arguments. Everything else is configured from
the Trailframe web UI after the first start.

| Option | Default | Description |
| --- | --- | --- |
| `data_path` | `/share/trailframe` | Base folder holding the library (database, thumbnails, maps, models, tiles, trash) and the app-managed `config.yaml`. Stored under the Home Assistant `share` folder so it is browsable from Samba/SMB, the File Editor, etc. |
| `photos_path` | `/media/photos` | Location of your photo library; exposed inside the app as `<data_path>/photos`. |
| `failsafe` | `false` | Start Trailframe in failsafe mode: the FolderService (scan/watch) is not started. Use this to work on the gallery database, models or configuration without triggering scans, or when a scanner is crashing the app. |

Notes:

- **Where the data lives**: `data_path` defaults to `/share/trailframe`, i.e. the
  Home Assistant `share` folder, which is accessible from outside the app via
  Samba/SMB or the File Editor. You can point it at any mapped folder — e.g.
  `/media/trailframe` to store it on the media share or on a NAS/network
  drive, or `/addon_config/trailframe` for the app configuration folder.
  When changing `data_path`, copy any existing library (`config.yaml`,
  `gallery.db`, thumbnails, …) from the old location into the new one before
  restarting.
- The SQLite database lives at `<data_path>/gallery.db`.
- On first start Trailframe writes its own `<data_path>/config.yaml` with
  default settings; afterwards settings changed from the web UI
  (*Tools/Configuration* page) persist across restarts. Delete that file to
  regenerate it with defaults.

### Storing your photos

- **Local media folder**: put your photos under the Home Assistant media
  folder (e.g. via Samba/SMB share or File Editor) and set `photos_path`
  accordingly, e.g. `/media/photos`.
- **NAS / network storage**: add it in Home Assistant (**Settings → System →
  Storage → Add network storage**); it then appears under `/media/<name>` —
  point `photos_path` there.
- **USB drive**: mount it as network storage as well, or map it under
  `/share` and set `photos_path: /share/photos`.

## Known limitations

- The first start can take several minutes: dependencies include PyTorch, and
  the object-detection model (`yolo26n.pt` by default) is downloaded
  automatically on first scan.
- On Raspberry Pi hardware prefer a Pi 4/5 with enough RAM; object detection
  is resource intensive and can be disabled from the web UI configuration.
- Garmin Connect import is configured from within the Trailframe web UI; the
  device must have internet access (default).

## Support

- Upstream project & documentation: https://github.com/sildra/trailframe
- Issues with this app: https://github.com/sildra/hassio-trailframe/issues

## Changelog

See [CHANGELOG.md](CHANGELOG.md).
