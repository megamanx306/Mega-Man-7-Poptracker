# Changelog

## Version 0.9.3 — 2026-10-05 direct full-stage views

Each stage now opens its full map directly. Removed Whole stage, Locations, Check list, and close-up sub-tabs and their unused images/map definitions. Shop views, all AP check sections, full-map markers and notes, inventory, broadcast, logic, and autotracking remain. No live GUI/emulator test performed.

## Version 0.9.2 — 2026-10-05 segmented-map cleanup

Removed 81 numbered stage-segment images, their Sections tabs, map definitions, and segment-only marker coordinates. Whole-stage maps, check boards, targeted close-ups, AP check definitions, logic, autotracking, and broadcast views are retained. No live PopTracker/emulator run was performed.

## Documentation refresh — 2026-10-05

Rewrote the README around current behavior and compatibility, aligned its title with the manifest and VERSION file, moved previous release notes into this changelog, and added a licensing-status notice. Pack version and runtime files are unchanged. Historical notes below describe their respective releases and may be superseded by later entries.

## Historical release notes

# Mega Man 7 maps and logic v0.8.8

Unique weapons, R.U.S.H plates, Rush upgrades and useful items now use toggles: no green “1” overlays. Consumable filler and bolt-wallet counters keep their quantities.

All 113 existing AP checks now have whole-map markers, including room references. Added Spring weapon energy and Hyper Bolt, Junk health and Rush Jet, Shade branches, Beat, Wily 2's three small health pickups and all eight optional Boss Rush checks. Corrected Freeze's Exit Unit, Junk/Shade digs, and Guts Man G / HannyaNED2 boss markers. Some new placements remain room references, including Spring's weapon capsule; tooltips say so.

Logic fixes: Hyper Bolt is in Spring, with no Rush Search requirement. Junk's Mega Bolt needs Freeze Cracker AND Rush Search. Default tested routes allow Burst 1-Up 1 without vertical items. Wily 1's weapon capsule has no separate vertical requirement; its stage's leave rule still applies. Wily 1's 1-Up needs Rush Jet. Early Wily 2/3 pickups become yellow if you can enter but cannot clear/exit; checks beyond the movement obstacle remain red. Wily 3's E/S/W tanks use Rush Jet OR all four Super Adapter plates, taking the later explicit-ID note over the earlier upper-path note.

Slot data synchronizes stage codes, Pickupsanity and Split Boss Rush. Match remaining Logic settings to your YAML; the world does not send all of them. Optional Boss Rush checks require the option and are hidden when absent from the seed.

Auto-follow and current bolts still require PopTracker's SNES connection to the same emulator bridge used by AP/SNI. AP alone supplies items/checks. Follow stage can be disabled in Auto's Shop. Existing wallet, shop prices and discounts are retained.

Validated: JSON/layout/image references and marker bounds, Lua syntax, unique-toggle receipts, reconnect resets, duplicate suppression, restored checks and focused route/fortress regressions. Server log confirms both players completed their goals; it cannot prove every marker pixel.

Install: replace the previous pack with this ZIP. Do not load two versions with the same package UID. Whole stage stays the default view; inventory and check boards stay below it. Playtest close-up tabs enlarge the revised map areas. AP tracking restores checks and suppresses duplicate item events. Maps and marker coordinates are checked, but this update has not been run in the PopTracker GUI or emulator.

AP seed logic is a new toggle under Logic settings. OFF (default) uses the player's tested individual routes. ON uses the AP world's conservative requirements. Physical access in the default mode can be greener than the generator's sphere logic; this does not change the seed or APWorld. Yellow denotes a sequence break / difficult movement route. Hidden rooms and uncertain pixels are explicitly labeled room references, rather than claimed exact pickup coordinates. Server IDs and primary names are preserved; where the playtest numbers differ, tooltips include the ID-specific aliases.

Map art: Geminiman (MM7) / Zeric (MM8), VGMaps.com; individual URLs and dimensions are in map-sources.json. Game artwork copyright Capcom. No ROM, disc, or executable is included.

## Screenshot corrections 0.8.1

Corrected the screenshot-highlighted check coordinates on whole maps and every corresponding close-up. New named spot tabs show the exact confirmed areas. The original AP IDs, logic and whole-stage defaults are retained.

## Additional screenshot correction

User screenshot: Rush Search dig in the bottom-right blue room on the Freeze Cracker route. Updated the whole map and every corresponding close-up.

Version 0.8.3: broadcast view uses four columns: eight Robot Masters, eight weapons, Wily 1–4 (fourth is final Wily access), R/U/S/H plates, Coil/Search/Jet/Hyper Rocket Buster, Hyper Bolt/Exit Unit/Energy Balancer/Beat, then Proto clues 1/2 and Proto Shield. Broadcast omits lives and tanks.

Version 0.8.4: numbered Wily emblems. Split Boss Rush shows a separate Wily 4 and final Wily 5; combined mode shows final Wily 4. Broadcast stays four columns, with split final on an extra row.

Version 0.8.5: Exit Unit check 7799077 requires Rush Search and access to Freeze Man’s stage. Corrected the previous accidental Spring stage gate.

Version 0.8.6: Robot Master portraits follow robot_master_access_codes. With codes disabled, all eight portraits are active; with codes enabled, each portrait stays grey until its code arrives. Received AP item state is preserved independently of the portrait display. Applies to main and broadcast views.


## Version 0.8.7 — 2026-10-03 playtest corrections

Corrected Wily 4 refight tower markers and boss identities, large bolts 1–3 and W-Tank; swapped large bolts 4/6 and Shade health refills 1/2. Moved Beat, Spring weapon energy and HannyaNED² reward to the supplied markers. Spring E-Tank is yellow without Rush Coil, Rush Jet or Super Adapter and green with them. Wily 2 completion and downstream refills require one of those vertical tools; Freeze Cracker alone no longer clears that route. Wily 1 weapon energy remains obtainable without an extra tool gate.

Stage maps remain the default view. New Latest playtest tabs enlarge screenshot-confirmed areas. Existing AP location IDs and primary names are preserved. Default physical routes use the new findings; AP seed logic retains the APWorld rules.

Validation for this release: all JSON parsed, every Lua script passed a syntax check, AP IDs/primary check sections matched the previous pack, map markers passed bounds checks, and new route regressions passed. Across both packs, 47,600 strict-mode comparisons matched the prior validated rules. No live PopTracker/emulator run was performed for this release.


## Version 0.8.8 — UI organization

Compact four-column inventory now sits on the left, with Items and Extras tabs. Main maps occupy the right-hand area at full available height. Stage navigation is grouped into Intro, Robot Masters, special stage, Wily’s Castle and shop/lab. Whole stage remains each stage’s first view. Sections and special locations are grouped into short nested tabs; every existing map view is retained. Each stage’s check board is available under Check list. Logic options are accessed through PopTracker’s settings popup.

Broadcast order and size, AP check identities, map markers and access rules are unchanged. MM7 auto-follow opens the correct stage group before selecting the detected stage. MM8 automatic stage detection remains unavailable.

UI layout organization takes inspiration from the supplied Mega Man X1–X3 packs; their game art and tracking code were not imported. Layout, item/map references, retained views and archive integrity were checked. This release has not been run in the PopTracker GUI.

## Version 0.8.9

Corrected all eight final-castle refill-room markers from the supplied screenshot, including the upper row vertical offset. Added an enlarged Refill room view. Left inventory icons increased from 52 × 48 to 64 × 60.

## Version 0.9.0

- Spaced Cloud Man's Mega Bolt and Large Health 2 markers apart on the whole-stage and section views.
- Restored Wily 4 Boss Rush beside Wily 1–3 in the main inventory. Final Wily access is on the next row.
- Final-stage settings now sync from the patched ROM through the existing SNES connection, guarded by the MM7AP ROM prefix. Supports Wily-stage count, Robot Master count, weapon count, and Proto Man encounter requirements.
- Proto Man completion is also recognized from the checked Proto Shield location; final-stage icons refresh immediately after AP item/check updates.
- Without the SNES connection, set the Final type and count controls in Settings to match the seed YAML. This APWorld does not send those settings through the server. Final type: 0 Wily stages, 1 Robot Masters, 2 weapons, 3 Proto Man.
- Wily 5 is the displayed final stage with Split Boss Rush enabled; the combined layout displays Wily 4.

## Version 0.9.1

Cloud Man’s Mega Bolt marker now sits above Large Health 2, matching the supplied vertical arrangement. Repositioned Wily 2’s three small-health checks directly onto their platform pickups in every existing map view. Wily 1–4 remain on one inventory row with Wily 5 below when Split Boss Rush is enabled.
