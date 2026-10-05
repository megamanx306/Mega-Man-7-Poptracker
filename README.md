# Mega Man 7 — Maps and Logic v0.9.3

Archipelago PopTracker pack for Mega Man 7, based on the supplied MM7 APWorld 0.4.0. Includes 113 AP check definitions, stage maps, item tracking, shop support, and SNES stage auto-follow.

## Installation and connection

1. Place this ZIP in your PopTracker packs folder and select the pack in PopTracker.
2. Replace your previous copy; do not keep two installed versions with the same package UID.
3. Connect PopTracker's Archipelago connection to your server using your slot name and password, if required. Received items and checked locations are tracked through AP.
4. Review the pack's Logic settings and match options that are not synchronized to the seed that generated your game.

Requires PopTracker 0.33.0 or newer; the manifest targets 0.35.4.

## Layout and tracking

- Four-column inventory on the left, with Items and Extras tabs; maps on the right.
- Selecting a stage opens its full map directly. Whole stage, Locations, Check list, and close-up sub-tabs have been removed; shop views remain available.
- A separate broadcast layout provides a compact progression display.
- Robot Master portraits follow the seed's stage access-code setting.
- Optional checks are hidden when absent from the connected seed.
- AP tracking handles restored checks, reconnect resets, and duplicate item events.

Yellow accessibility indicates a sequence break or difficult movement route. Some markers identify rooms rather than verified individual pickup pixels; consult their tooltips.

## Logic and emulator settings

AP seed logic defaults **OFF**. The default uses the individually playtested physical routes; enabling AP seed logic selects the supplied APWorld's conservative rules. Physical accessibility may differ from generator sphere logic.

AP synchronizes stage access codes, Pickupsanity, and Split Boss Rush. Other options must match your seed YAML. Stage auto-follow and the current bolt wallet require PopTracker's SNES connection to the same emulator bridge used by AP/SNI; the AP connection alone supplies items and checks.

Final-stage requirements can synchronize from the patched ROM over the SNES connection, guarded by the MM7AP ROM prefix. Without that connection, set Final type and count in Settings: 0 = Wily stages, 1 = Robot Masters, 2 = weapons, 3 = Proto Man. Proto Man completion is also recognized from the checked Proto Shield location.

Wily 1–4 appear on one inventory row. With Split Boss Rush enabled, Wily 4 is Boss Rush and Wily 5 is the final stage below it; combined mode displays final Wily 4.

The latest map corrections separate Cloud Man's Mega Bolt and Large Health 2 vertically and place Wily 2's three small-health markers on their platform pickups.

## Credits and licensing status

Map contributor: **Geminiman**, via VGMaps.com.

Pack identity: MegaManX306. Map artwork credits and source URLs are recorded in `map-sources.json`. Mega Man game artwork belongs to Capcom. No ROM, disc image, or game executable is included.

The UI organization was inspired by supplied Mega Man X1–X3 tracker examples; their game artwork and tracking code were not imported.

See `LICENSE-NOTICE.md` for the current licensing status. Attribution does not grant reuse rights for third-party artwork.

## Reporting issues

Include the pack version, PopTracker version, APWorld version that generated the seed, relevant YAML/settings, the check name and AP ID, your available items, and a screenshot where useful. For connection problems, include a redacted log without passwords.

## Verification and known limitations

This release checked ZIP integrity, JSON syntax, version consistency, map and image references, retained marker bounds, and preservation of AP check definitions and runtime scripts. It did not run PopTracker or an emulator. Earlier validation claims and user playtest results are recorded in `CHANGELOG.md` and the included validation/playtest files; they were not rerun for this documentation update.

