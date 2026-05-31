# OmniWM config port — design

**Date:** 2026-05-24
**Status:** Approved

Port the existing Aerospace setup (`~/dotfiles/.config/aerospace/aerospace.toml`)
to an OmniWM `settings.toml` so OmniWM can be evaluated side-by-side with
Aerospace. Aerospace stays installed and untouched.

## 1. Goal & non-goals

**Goal:** Produce an OmniWM `settings.toml` that lets the user live with
OmniWM day-to-day with as little muscle-memory disruption from Aerospace as
possible, and manage it through the existing dotfiles + Unison sync flow.

**Non-goals:**

- 1:1 feature parity. Some Aerospace concepts have no OmniWM equivalent and
  are dropped (see §7).
- Uninstalling or disabling Aerospace.
- Wiring up Karabiner forwarders for the 6 unbound workspaces or the
  `alt-enter` / `alt-shift-enter` exec bindings. Deferred to a follow-up
  iteration; captured in §7.

## 2. Storage & sync architecture

OmniWM stores its canonical config at `~/.config/omniwm/settings.toml` and
both live-reloads and rewrites it (rewrites happen when the GUI mutates
settings). The dotfiles repo already manages files with this same shape
(Karabiner, Alfred, Ice, Rocket, macOS print prefs) via Unison bidirectional
sync.

```
~/dotfiles/unison/.config/omniwm/settings.toml   ← canonical, tracked in git
~/.config/omniwm/settings.toml                   ← what OmniWM reads & rewrites
                    ↕ (Unison bidirectional sync via launchd)
```

**Changes required:**

1. Add the hand-authored `settings.toml` at
   `~/dotfiles/unison/.config/omniwm/settings.toml`.
2. Add one line to the `path = …` block in
   `nix/shared/home.nix`'s `sync-user-prefs.prf`:

   ```
   path = .config/omniwm/settings.toml
   ```

3. Initial seed: copy the file into both locations once so Unison sees
   identical content on first run.

`prefer = newer` (already set in the Unison config) means GUI edits flow
back to dotfiles, and dotfiles edits flow forward to the live file
(OmniWM will live-reload). This is the same pattern that already works for
`~/.config/karabiner/karabiner.json`.

## 3. Workspaces

15 workspaces, preserving the Aerospace display identity. The `name` field
is the internal/sortable id (`"1".."15"`); `displayName` carries the
SF Symbol glyph or letter exactly as in the Aerospace config.

| Idx | name   | displayName | Aerospace equivalent | monitor   | initial hotkey |
| --- | ------ | ----------- | -------------------- | --------- | -------------- |
| 1   | `"1"`  | `􀎬`        | safari               | secondary | `Option+S`     |
| 2   | `"2"`  | `􀩼`        | terminal             | secondary | `Option+T`     |
| 3   | `"3"`  | `􁒘`        | chat                 | main      | `Option+C`     |
| 4   | `"4"`  | `􀝋`        | slack                | main      | `Option+D`     |
| 5   | `"5"`  | `􀉉`        | calendar             | main      | `Option+G`     |
| 6   | `"6"`  | `􀑁`        | obsidian             | main      | `Option+P`     |
| 7   | `"7"`  | `􀏆`        | finder               | main      | `Option+F`     |
| 8   | `"8"`  | `􀍉`        | video chat           | main      | `Option+V`     |
| 9   | `"9"`  | `W`         | generic              | main      | `Option+W`     |
| 10  | `"10"` | `A`         | generic              | main      | (unbound)      |
| 11  | `"11"` | `B`         | generic              | main      | (unbound)      |
| 12  | `"12"` | `Q`         | generic              | main      | (unbound)      |
| 13  | `"13"` | `R`         | generic              | main      | (unbound)      |
| 14  | `"14"` | `X`         | generic              | main      | (unbound)      |
| 15  | `"15"` | `Z`         | generic              | main      | (unbound)      |

The 9 hotkey-bound workspaces also get a matching
`Option+Shift+<letter>` for the corresponding `moveToWorkspace.N` action.
The remaining 6 workspaces are reachable via the workspace bar / overview;
Karabiner forwarding to OmniWM IPC is planned for a follow-up so all 15 can
be hotkey-driven.

**Mechanism:** OmniWM's hotkey ids `switchWorkspace.0..8` and
`moveToWorkspace.0..8` accept any binding string. The numeric indices map
to position-ordered workspaces, so binding `switchWorkspace.0` to
`Option+S` switches to whichever workspace is first in the ordered list
(workspace `"1"`, which displays as Safari). The mapping is determined by
workspace order in the config, not by the index in the hotkey id.

**Per-workspace layout (`layoutType`):**

- `dwindle` (BSP, closest to Aerospace tiles): terminal, video
- `niri` (scrolling): safari, chat, slack, calendar, obsidian, finder, and
  the 7 generic letter workspaces (it's OmniWM's default and arguably its
  strength)

Toggle per workspace at runtime with `Option+Shift+L`
(`toggleWorkspaceLayout`).

**Monitor assignment:** `secondary` for terminal + safari (matches the
Aerospace `workspace-to-monitor-force-assignment` block); `main` for all
others. May need to switch to `specificDisplay` with an `OutputId` if the
laptop-vs-external mapping doesn't behave as expected at runtime (see §7).

## 4. App rules

Direct port of the Aerospace `on-window-detected` blocks to OmniWM
`[[appRules]]` with `assignToWorkspace = "<name>"`. The match value is the
numeric `name` field, not `displayName`.

| bundleId                          | assignToWorkspace | extra            |
| --------------------------------- | ----------------- | ---------------- |
| `com.apple.systempreferences`     | —                 | `layout=float`   |
| `com.grailr.CARROT-Weather`       | —                 | `layout=float`, `titleSubstring="Mini Window"` |
| `com.apple.Safari`                | `"1"`             |                  |
| `app.zen-browser.zen`             | `"1"`             |                  |
| `company.thebrowser.Browser`      | `"1"`             |                  |
| `com.github.wez.wezterm`          | `"2"`             |                  |
| `com.apple.MobileSMS`             | `"3"`             |                  |
| `ru.keepcoder.Telegram`           | `"3"`             |                  |
| `com.tinyspeck.slackmacgap`       | `"4"`             |                  |
| `com.apple.mail`                  | `"5"`             |                  |
| `com.flexibits.fantastical2.mac`  | `"5"`             |                  |
| `com.busymac.busycal3`            | `"5"`             |                  |
| `md.obsidian`                     | `"6"`             |                  |
| `com.culturedcode.ThingsMac`      | `"6"`             |                  |
| `com.amazon.Amazon-Chime`         | `"8"`             |                  |
| `us.zoom.xos`                     | `"8"`             |                  |

**Behavioral difference:** Aerospace's
`if.during-aerospace-startup = true` flag (used for Safari/Zen/Arc/wezterm
rules) is not supported. OmniWM's `assignToWorkspace` triggers on first
matching window per session, which means any *new* Safari window also gets
routed to workspace 1. Aerospace would only do this at startup and let
later windows stay wherever they're opened. Expected to be acceptable;
revisit if it becomes annoying.

## 5. Hotkey port

OmniWM has no mode system, so Aerospace's `mode service` is dropped. Most
of its commands have direct OmniWM equivalents or aren't necessary
(`reload-config` is automatic on file change).

| Aerospace                                  | OmniWM hotkey id                                          | OmniWM binding                |
| ------------------------------------------ | --------------------------------------------------------- | ----------------------------- |
| `alt-h/j/k/l` focus                        | `focus.left/down/up/right`                                | `Option+H/J/K/L`              |
| `alt-shift-h/j/k/l` move                   | `move.left/down/up/right`                                 | `Option+Shift+H/J/K/L`        |
| `alt-shift-minus/equal` resize             | `setColumnWidth.decrease10Percent`/`increase10Percent`    | `Option+Shift+-` / `Option+Shift+=` |
| `cmd-alt-ctrl-f` fullscreen                | `toggleFullscreen`                                        | `Control+Option+Command+F`           |
| `cmd-alt-ctrl-shift-f` native fullscreen   | `toggleNativeFullscreen`                                  | `Control+Option+Shift+Command+F`     |
| `cmd-alt-ctrl-t` float toggle              | `toggleFocusedWindowFloating`                             | `Control+Option+Command+T`           |
| `alt-tab` workspace→monitor                | `focusMonitorNext` (closest analogue)                     | `Option+Tab`                  |
| `alt-slash`/`alt-comma` layout switch      | `toggleWorkspaceLayout`                                   | `Option+/`                    |
| service-mode `r` reset layout              | `balanceSizes`                                            | `Option+Shift+B` (default)    |
| service-mode `backspace` close-all-but-current | —                                                     | dropped (no equivalent)       |
| `cmd-alt-ctrl-h/j/k/l` join-with           | —                                                         | dropped (BSP/scrolling don't have this op) |
| `alt-shift-semicolon` mode service         | —                                                         | dropped (live-reload is automatic) |

The 9 workspace switch + 9 workspace move bindings are listed in §3.

The Niri-specific column ops in OmniWM's defaults (`focusColumn.0..8`,
`cycleColumnWidthForward`, `toggleColumnTabbed`, etc.) are kept as-is — they
have no Aerospace analogue but are useful when on a Niri workspace.

`alt-enter` and `alt-shift-enter` are not bindable in OmniWM and are
captured as follow-ups in §7.

## 6. Top-level settings

```toml
[general]
defaultLayoutType   = "niri"   # per-workspace overrides do the work
hotkeysEnabled      = true
ipcEnabled          = true     # required for planned Karabiner forwarding

[gaps]
size = 4.0                     # matches Aerospace inner.horizontal/vertical = 4

[gaps.outer]
top    = 0.0
bottom = 0.0
left   = 0.0
right  = 0.0                   # matches Aerospace outer.* = 0

[focus]
moveMouseToFocusedWindow = true  # ~ on-focus-changed move-mouse window-lazy-center
followsWindowToMonitor   = true  # ~ on-focused-monitor-changed move-mouse monitor-lazy-center
followsMouse             = false # not enabled in Aerospace config

[dwindle]
smartSplit = true              # ~ enable-normalization-opposite-orientation-for-nested-containers

[appearance]
mode = "dark"

[borders]
enabled = true                 # OmniWM default; not in Aerospace but useful UX
```

OmniWM-only features (workspace bar, quake terminal, overview, borders) are
left at their built-in defaults so the side-by-side evaluation sees what's
*different* about OmniWM rather than a stripped-down clone. Tune later if
chrome becomes distracting.

## 7. Known gaps / follow-up TODOs

Captured here, not implemented in this iteration.

1. **Letter hotkeys for the 6 unbound workspaces** (A, B, Q, R, X, Z) —
   route via Karabiner → OmniWM IPC (`ipcEnabled = true` in §6 is
   prerequisite). Requires identifying the IPC command for
   "switch to workspace by name".
2. **`alt-enter` — new terminal in current workspace** — currently
   `exec-and-forget ~/.local/bin/aerospace-new-terminal`. Needs Karabiner
   or another tool to invoke a shell command bound to a hotkey.
3. **`alt-shift-enter` — new Zen/Safari window via osascript** — same as
   #2, needs an external hotkey-to-shell bridge.
4. **Monitor pin specificity** — `secondary` is the initial assumption.
   If terminal/safari workspaces don't land on the expected external
   display, switch to `specificDisplay` with the runtime `OutputId`
   captured from OmniWM.
5. **Verify Unison + OmniWM rewrite interaction** — confirm OmniWM's
   live-reload + atomic-rewrite cycle plays nicely with Unison sync.
   Karabiner already works under this scheme so high confidence, but
   worth checking.
6. **Disabled cmd-h / cmd-alt-h** — Aerospace empties these to disable
   "hide application" / "hide others". OmniWM doesn't override them by
   default. Probably fine; flag if accidental hides become annoying.
7. **Aerospace's `join-with` operation** — has no equivalent in OmniWM's
   BSP/scrolling engines. Dropped without replacement.
8. **`close-all-windows-but-current`** — service-mode action in Aerospace,
   no OmniWM equivalent. Dropped.

## 8. Implementation order

1. Author `~/dotfiles/unison/.config/omniwm/settings.toml` with §3–6
   content.
2. Add `path = .config/omniwm/settings.toml` to `sync-user-prefs.prf` in
   `nix/shared/home.nix`.
3. `home-manager switch` to apply the new Unison path.
4. Copy the hand-authored file to `~/.config/omniwm/settings.toml` for the
   initial seed.
5. Launch OmniWM; verify config loads, hotkeys work, app rules route
   correctly, monitor assignments behave.
6. Commit the new file + home.nix change.
