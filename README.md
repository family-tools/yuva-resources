# Yuva resources

Files for [Yuva](https://github.com/family-tools/yuva) that are too big for
its Docker image. Yuva downloads them from the releases of this repo.

## Sounds

`sounds/` has the adhan recordings and notification sounds. An admin
installs them in Yuva from **Prayer → Settings → Sound packs**. A server
without internet can download the zips from the [releases](../../releases)
and use **Install a pack from a zip file**.

Each folder with a `pack.json` is one pack:

```json
{"name": "adhan", "title": "Adhan recordings", "kind": "adhan"}
```

`kind` is `adhan` (offered for adhan and shuffle) or `sound` (reminders only).

`sounds/build-packs.sh` zips each pack into `sounds/dist/` and writes
`packs.json` with the size and sha256 of each zip. Pushing a `sounds-v1`,
`sounds-v2`... tag does this on GitHub and publishes a release. Yuva reads
the release its `sounds.DefaultURL` points at, so a new tag also needs that
changed in Yuva.
