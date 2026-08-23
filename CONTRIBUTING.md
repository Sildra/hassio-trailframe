# Contributing

Contributions are welcome! Feel free to open issues and pull requests.

## Repository layout

```
hassio-trailframe/
├── common/               Shared build files (Dockerfile, build.yaml, entrypoint)
├── trailframe/           Stable add-on (tracks Trailframe releases)
├── trailframe-edge/      Edge add-on (tracks the Trailframe main branch)
└── .github/workflows/    CI: build & publish images
```

`Dockerfile`, `build.yaml` and `rootfs/` are shared between both add-ons via
`common/`. They are copied into each add-on folder by CI before building — do
not commit them inside `trailframe/` or `trailframe-edge/`.

## Testing changes locally

Build the edge add-on image locally with the HA builder:

```bash
cd ..
cp common/Dockerfile hassio-trailframe/trailframe-edge/
cp -R common/rootfs hassio-trailframe/trailframe-edge/
cp common/build.yaml hassio-trailframe/trailframe-edge/
docker run --rm --privileged \
  -v $(pwd)/hassio-trailframe/trailframe-edge:/data homeassistant/amd64-builder \
  --amd64 -t /data --no-cache
rm -rf hassio-trailframe/trailframe-edge/rootfs
rm hassio-trailframe/trailframe-edge/Dockerfile
rm hassio-trailframe/trailframe-edge/build.yaml
```

Or simply run `common/local_build.sh`.

Then install the repository as a local repository in Home Assistant
(**Settings → Add-ons → Add-on Store → ⋮ → Repositories**) or copy the add-on
folder into `/usr/share/hassio/addons/local`, disable *Watchdog* in the add-on
settings while testing, and check the logs.
