# Contributing

Contributions are welcome! Feel free to open issues and pull requests.

## Repository layout

```
hassio-trailframe/
└── trailframe/       The app (config.json, Dockerfile, rootfs/)
```

There is no CI and no published image: Home Assistant builds the image
locally on the user's device when the app is installed, and Trailframe is
installed from PyPI into a persistent virtualenv at first start. Bumping the
packaged Trailframe version only requires changing `version` in
`trailframe/config.json`.

## Testing changes locally

1. Copy (or clone) this repository onto a machine running Home Assistant OS /
   Supervised, e.g. into `/usr/share/hassio/addons/local/trailframe`, or add
   it as a **local repository** in the App Store
   (**Settings → Apps → App Store → ⋮ → Repositories**).
2. Install/start the app from there; check the **Log** tab for output.
3. Tip: turn off *Watchdog* in the app settings while testing so the
   container isn't restarted automatically when stopped via the CLI.
