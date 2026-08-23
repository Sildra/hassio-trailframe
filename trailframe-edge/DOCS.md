# Home Assistant add-on: Trailframe (Edge)

Development build of [Trailframe](https://github.com/sildra/trailframe), a
self-hosted photo gallery for people who move: photos and GPS activities
(Garmin Connect / GPX) live side by side, linked by time and place.

Unlike the stable **Trailframe** add-on, this edge version is built directly
from the `main` branch of Trailframe so you can test features and fixes before
they are released. It may be unstable — use the stable add-on unless you know
you need this one.

Both add-ons can be installed at the same time; the edge version keeps its
data under `/data/trailframe-edge`.

## Installation

1. Add this repository to the Home Assistant add-on store:
   `https://github.com/sildra/hassio-trailframe`
2. Install the **Trailframe Edge** add-on.
   The build compiles the web UI from source and pulls in all Python
   dependencies (including PyTorch), so it takes significantly longer than the
   stable add-on.
3. Configure `photos_path` (see below), then start the add-on.
4. Open `http://homeassistant.local:8000` (default `port` option; see the
   [stable add-on documentation](../trailframe/DOCS.md)).

## Configuration

See the [stable add-on documentation](../trailframe/DOCS.md) — the options are
identical. The only difference is `data_path`, which defaults to
`/data/trailframe-edge`.
