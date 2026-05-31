# OmniWM Config Port Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deploy a hand-authored OmniWM `settings.toml` that mirrors the existing Aerospace setup, managed via the dotfiles repo with Unison bidirectional sync, so OmniWM can be evaluated side-by-side with Aerospace.

**Architecture:** Single canonical TOML file lives at `~/dotfiles/unison/.config/omniwm/settings.toml`. Unison (already wired up via home-manager) bidirectionally syncs it with `~/.config/omniwm/settings.toml`, which is what OmniWM reads and rewrites. One additional `path = …` line in `nix/shared/home.nix` adds the file to the existing sync set.

**Tech Stack:** OmniWM v0.4.9.5 (already installed in `/Applications/OmniWM.app`), nix-darwin + home-manager (rebuild via `darwin-rebuild switch --flake ~/dotfiles#Auri`), Unison (already running as a launchd agent named `unison.user-pref-sync`).

**Spec:** `~/dotfiles/docs/superpowers/specs/2026-05-24-omniwm-config-port-design.md`

---

## File Structure

**Create:**
- `~/dotfiles/unison/.config/omniwm/settings.toml` — canonical OmniWM config

**Modify:**
- `~/dotfiles/nix/shared/home.nix` — add one line to the `sync-user-prefs.prf` `text = ''…''` block to register the new sync path

**Seed (one-time copy, not tracked in dotfiles as a separate artifact):**
- `~/.config/omniwm/settings.toml` — copy of the canonical file, what OmniWM actually loads

---

## Pre-flight notes

- **Aerospace conflict:** Aerospace and OmniWM will both fight for the same `alt-…` shortcuts if both are running. Quit Aerospace (`aerospace quit` or via menu bar) before launching OmniWM for verification. To return to Aerospace, quit OmniWM the same way. Both apps remain installed; only one runs at a time.
- **Unison sync direction on first run:** `prefer = newer` in the existing `.prf` decides which side wins when contents differ. To guarantee Unison sees identical content on both sides at first sync, the seed step (Task 4) copies the dotfiles version into the live location *before* Unison runs again.
- **OmniWM live-reload behavior:** Editing `~/.config/omniwm/settings.toml` from any editor triggers a hot reload. OmniWM may also rewrite the file (e.g., if you toggle a setting via the GUI). Unison handles atomic rewrites correctly — the same mechanism already works for `~/.config/karabiner/karabiner.json`.
- **Workspace hotkey indexing:** OmniWM's `switchWorkspace.N` and `moveToWorkspace.N` reference workspaces by *position* in the `[[workspaces]]` array. Workspace `name = "1"` is at index 0 because it comes first; `name = "9"` is at index 8. Don't reorder the workspace blocks without also reshuffling the hotkey ids.

---

## Task 1: Author the OmniWM settings.toml

**Files:**
- Create: `~/dotfiles/unison/.config/omniwm/settings.toml`

The file is a complete OmniWM config: every top-level section is present so OmniWM has nothing to fill in from defaults, which avoids a noisy first-run rewrite. App rules combine our Aerospace-ported workspace assignments with OmniWM's default app sizing rules. Hotkeys list only the bindings we customize plus two explicit `Unassigned` overrides for default bindings that collide with our scheme (`Option+T` and `Option+Shift+F`). Workspaces are listed in position order; reorder = re-key bindings.

> **UUID gotcha:** Every `id = "..."` in `[[appRules]]` and `[[workspaces]]` must be a real RFC-4122 UUID. Swift's `UUID(uuidString:)` rejects structurally-hex-but-not-real UUIDs like `A0000001-0000-0000-0000-000000000001`, which causes OmniWM to mark the file `.corrupt` on load and revert to defaults. Generate with `uuidgen` (one per call) or `python3 -c 'import uuid; print(str(uuid.uuid4()).upper())'`. The UUIDs in the content block below are real ones generated for this setup; reuse them as-is or regenerate.

- [ ] **Step 1: Verify the parent directory does not yet exist (or is empty)**

```bash
ls -la ~/dotfiles/unison/.config/omniwm/ 2>&1
```

Expected: `No such file or directory`. If the directory already exists with content, stop and inspect before overwriting.

- [ ] **Step 2: Create the file with the complete content below**

Create `~/dotfiles/unison/.config/omniwm/settings.toml` with this content:

```toml
# OmniWM settings — managed via dotfiles
# Canonical home: ~/dotfiles/unison/.config/omniwm/settings.toml
# Sync target:    ~/.config/omniwm/settings.toml (Unison bidirectional)
# Design spec:    ~/dotfiles/docs/superpowers/specs/2026-05-24-omniwm-config-port-design.md

monitorBarOverrides = []
monitorDwindleOverrides = []
monitorNiriOverrides = []
monitorOrientationOverrides = []

[appearance]
mode = "dark"

[borders]
enabled = true
width = 5.0

[borders.color]
alpha = 1.0
blue = 0.979300037944676
green = 1.0
red = 0.08458520228437894

[clipboard]
historyEnabled = false
maxItemBytes = 8388608
maxItems = 200
maxTotalBytes = 67108864

[dwindle]
defaultSplitRatio = 1.0
moveToRootStable = true
singleWindowAspectRatio = "4:3"
smartSplit = true
splitWidthMultiplier = 1.0
useGlobalGaps = true

[focus]
followsMouse = false
followsWindowToMonitor = true
moveMouseToFocusedWindow = true

[gaps]
size = 4.0

[gaps.outer]
bottom = 0.0
left = 0.0
right = 0.0
top = 0.0

[general]
animationsEnabled = true
defaultLayoutType = "niri"
hotkeysEnabled = true
ipcEnabled = true
preventSleepEnabled = false
updateChecksEnabled = true

[gestures]
fingerCount = 3
invertDirection = true
mouseResizeModifierKey = "option"
scrollEnabled = true
scrollModifierKey = "optionShift"
scrollSensitivity = 5.0

[mouseWarp]
axis = "horizontal"
margin = 1
monitorOrder = []

[niri]
alwaysCenterSingleColumn = false
centerFocusedColumn = "never"
columnWidthPresets = [0.3333333333333333, 0.5, 0.6666666666666666]
defaultColumnWidth = 0.5
infiniteLoop = false
maxVisibleColumns = 2
maxWindowsPerColumn = 10
singleWindowAspectRatio = "none"

[quakeTerminal]
animationDuration = 0.2
autoHide = false
enabled = true
heightPercent = 50.0
monitorMode = "focusedWindow"
opacity = 1.0
position = "center"
useCustomFrame = false
widthPercent = 50.0

[state]
commandPaletteLastMode = "windows"

[statusBar]
showAppNames = false
showWorkspaceName = false
useWorkspaceId = false

[workspaceBar]
backgroundOpacity = 0.1
deduplicateAppIcons = false
enabled = true
height = 24.0
hideEmptyWorkspaces = false
labelFontSize = 12.0
notchAware = true
position = "overlappingMenuBar"
reserveLayoutSpace = false
showFloatingWindows = false
showLabels = true
windowLevel = "popup"
xOffset = 0.0
yOffset = 0.0

# ──────────────────────────────────────────────────────────────────────────
# App rules
# ──────────────────────────────────────────────────────────────────────────

# Floating-only rules (ported from aerospace [[on-window-detected]] layout=floating)
[[appRules]]
id = "A0608211-AF1A-4C2C-A242-0582B55A6D13"
bundleId = "com.apple.systempreferences"
layout = "float"

[[appRules]]
id = "99668B83-1584-4AF8-B733-0D677C5B1F38"
bundleId = "com.grailr.CARROT-Weather"
titleSubstring = "Mini Window"
layout = "float"

# Workspace assignment rules (ported from aerospace [[on-window-detected]] move-node-to-workspace)
[[appRules]]
id = "834C979A-0B65-4CF8-9C31-2376CAE533C9"
bundleId = "com.apple.Safari"
assignToWorkspace = "1"
minHeight = 220.0
minWidth = 574.0

[[appRules]]
id = "53ABC8A7-C48C-4E77-B55A-BD5552B3D9EE"
bundleId = "app.zen-browser.zen"
assignToWorkspace = "1"
minHeight = 495.0
minWidth = 500.0

[[appRules]]
id = "1B1B2801-D5B8-4421-8FC8-9DD5F3C9CDE0"
bundleId = "company.thebrowser.Browser"
assignToWorkspace = "1"

[[appRules]]
id = "9169937E-47F8-4621-8591-F763D05B8A9C"
bundleId = "com.github.wez.wezterm"
assignToWorkspace = "2"

[[appRules]]
id = "F5E8FC3B-5F68-4DD8-A076-7C11FBC87A0F"
bundleId = "com.apple.MobileSMS"
assignToWorkspace = "3"
minHeight = 320.0
minWidth = 660.0

[[appRules]]
id = "875D574B-8009-48FA-A8D3-FDDC3CAB629B"
bundleId = "ru.keepcoder.Telegram"
assignToWorkspace = "3"

[[appRules]]
id = "7061CBE1-CE2D-435F-B1F9-EA0A92EEB334"
bundleId = "com.tinyspeck.slackmacgap"
assignToWorkspace = "4"

[[appRules]]
id = "0C35AA11-7A0B-4C04-93B6-D0CC77971B5A"
bundleId = "com.apple.mail"
assignToWorkspace = "5"

[[appRules]]
id = "5FFDD5FC-D5C4-4CA8-8E49-B5C71048D18C"
bundleId = "com.flexibits.fantastical2.mac"
assignToWorkspace = "5"

[[appRules]]
id = "0AD42DB8-1501-4B6A-85C8-92FF52DA482B"
bundleId = "com.busymac.busycal3"
assignToWorkspace = "5"

[[appRules]]
id = "A84494AF-E312-4A18-96C3-C5A53F8F5678"
bundleId = "md.obsidian"
assignToWorkspace = "6"

[[appRules]]
id = "1E3003FA-295F-4F48-9D8D-89E84EAB8CD6"
bundleId = "com.culturedcode.ThingsMac"
assignToWorkspace = "6"

[[appRules]]
id = "EF9ABFA2-FEAD-49CB-A8DB-13AB1F38C844"
bundleId = "com.amazon.Amazon-Chime"
assignToWorkspace = "8"

[[appRules]]
id = "3AF3686E-1924-413C-9F7B-A880FB22E619"
bundleId = "us.zoom.xos"
assignToWorkspace = "8"

# Retained OmniWM defaults — sizing only, no workspace assignment
[[appRules]]
id = "6A31F08A-4051-4354-B439-42F4C71894A3"
bundleId = "com.openai.codex"
minHeight = 600.0
minWidth = 800.0

[[appRules]]
id = "4BA546DA-2875-4BEF-B13F-1539E833B1A0"
bundleId = "com.eltima.cmd1.pro.mas"
minHeight = 550.0
minWidth = 950.0

[[appRules]]
id = "486CEFA6-69AA-4A3C-AF27-BCD38F4F138B"
bundleId = "com.google.Chrome"
minHeight = 375.0
minWidth = 500.0

[[appRules]]
id = "979F05F4-FFA2-4EDD-B23F-08A9944C759F"
bundleId = "dev.zed.Zed"
minHeight = 240.0
minWidth = 360.0

[[appRules]]
id = "005C00D3-F665-47F8-BDAE-D80790E9E46B"
bundleId = "org.mozilla.firefox"
minHeight = 120.0
minWidth = 500.0

[[appRules]]
id = "C21156B1-0224-4998-97E3-8F4FA65B9F3B"
bundleId = "company.thebrowser.dia"
minHeight = 420.0
minWidth = 500.0

[[appRules]]
id = "2DE9390B-0DB4-4D0C-9ABA-06F76F1D4EA9"
bundleId = "com.spotify.client"
minHeight = 600.0
minWidth = 800.0

[[appRules]]
id = "AF752D95-8497-4844-BE20-4C93E73BAEF2"
bundleId = "com.hnc.Discord"
minHeight = 500.0
minWidth = 800.0

[[appRules]]
id = "7876C9EF-437E-4D4F-9C27-B1B02F4AABCE"
bundleId = "com.mitchellh.ghostty"
minHeight = 48.0
minWidth = 90.0

[[appRules]]
id = "8ECAB78B-BCDD-4245-BC25-1609A49B1C86"
bundleId = "com.microsoft.Outlook"
minHeight = 650.0
minWidth = 930.0

# ──────────────────────────────────────────────────────────────────────────
# Workspaces (15) — displayName preserves SF Symbol identity from aerospace.
# Order is load-bearing: switchWorkspace.0 refers to the first entry, etc.
# ──────────────────────────────────────────────────────────────────────────

[[workspaces]]
id = "85949879-EA1E-4CA8-8C6F-E6412561F617"
displayName = "􀎬"
layoutType = "niri"
name = "1"
[workspaces.monitorAssignment]
type = "secondary"

[[workspaces]]
id = "76301D09-D9AD-4E93-9DE5-2436E5BD74BF"
displayName = "􀩼"
layoutType = "dwindle"
name = "2"
[workspaces.monitorAssignment]
type = "secondary"

[[workspaces]]
id = "9DAE5D76-25ED-48F6-9CC1-82658EA1CBC2"
displayName = "􁒘"
layoutType = "niri"
name = "3"
[workspaces.monitorAssignment]
type = "main"

[[workspaces]]
id = "3625B95A-72C6-4F43-8A1D-59021ACD62F2"
displayName = "􀝋"
layoutType = "niri"
name = "4"
[workspaces.monitorAssignment]
type = "main"

[[workspaces]]
id = "B8759689-A00D-4446-9393-AAF2A6180115"
displayName = "􀉉"
layoutType = "niri"
name = "5"
[workspaces.monitorAssignment]
type = "main"

[[workspaces]]
id = "20B2E484-9234-49D3-AAB7-CF51D5D2A32E"
displayName = "􀑁"
layoutType = "niri"
name = "6"
[workspaces.monitorAssignment]
type = "main"

[[workspaces]]
id = "D304A423-42E5-43F0-B8C9-5FABDE953AB0"
displayName = "􀏆"
layoutType = "niri"
name = "7"
[workspaces.monitorAssignment]
type = "main"

[[workspaces]]
id = "AB6B1BDA-D19E-46CE-92D3-A5F7FF6F766E"
displayName = "􀍉"
layoutType = "dwindle"
name = "8"
[workspaces.monitorAssignment]
type = "main"

[[workspaces]]
id = "9443FEB7-1B9A-4FA8-A839-FCEAEA8B7EA4"
displayName = "W"
layoutType = "niri"
name = "9"
[workspaces.monitorAssignment]
type = "main"

[[workspaces]]
id = "2CCA982C-BD1A-4C6D-A558-248C85650E43"
displayName = "A"
layoutType = "niri"
name = "10"
[workspaces.monitorAssignment]
type = "main"

[[workspaces]]
id = "B8B82050-3AE0-4D30-9058-0B37ADEF68B1"
displayName = "B"
layoutType = "niri"
name = "11"
[workspaces.monitorAssignment]
type = "main"

[[workspaces]]
id = "05971A71-3C24-44E6-B8C9-6249B4E00601"
displayName = "Q"
layoutType = "niri"
name = "12"
[workspaces.monitorAssignment]
type = "main"

[[workspaces]]
id = "42494B00-C169-4E50-91EA-F8EC15783383"
displayName = "R"
layoutType = "niri"
name = "13"
[workspaces.monitorAssignment]
type = "main"

[[workspaces]]
id = "B30F07ED-8037-4E15-B77B-2278F7CCD31D"
displayName = "X"
layoutType = "niri"
name = "14"
[workspaces.monitorAssignment]
type = "main"

[[workspaces]]
id = "4EDDD8AD-175A-427F-B94C-03F2AB5C18BC"
displayName = "Z"
layoutType = "niri"
name = "15"
[workspaces.monitorAssignment]
type = "main"

# ──────────────────────────────────────────────────────────────────────────
# Hotkeys — Aerospace alt-letter scheme over OmniWM positional ids.
# Only customized bindings are listed; unlisted ids keep OmniWM defaults.
# ──────────────────────────────────────────────────────────────────────────

# Workspace switch — alt + letter
[[hotkeys]]
binding = "Option+S"
id = "switchWorkspace.0"

[[hotkeys]]
binding = "Option+T"
id = "switchWorkspace.1"

[[hotkeys]]
binding = "Option+C"
id = "switchWorkspace.2"

[[hotkeys]]
binding = "Option+D"
id = "switchWorkspace.3"

[[hotkeys]]
binding = "Option+G"
id = "switchWorkspace.4"

[[hotkeys]]
binding = "Option+P"
id = "switchWorkspace.5"

[[hotkeys]]
binding = "Option+F"
id = "switchWorkspace.6"

[[hotkeys]]
binding = "Option+V"
id = "switchWorkspace.7"

[[hotkeys]]
binding = "Option+W"
id = "switchWorkspace.8"

# Move window to workspace — alt + shift + letter
[[hotkeys]]
binding = "Option+Shift+S"
id = "moveToWorkspace.0"

[[hotkeys]]
binding = "Option+Shift+T"
id = "moveToWorkspace.1"

[[hotkeys]]
binding = "Option+Shift+C"
id = "moveToWorkspace.2"

[[hotkeys]]
binding = "Option+Shift+D"
id = "moveToWorkspace.3"

[[hotkeys]]
binding = "Option+Shift+G"
id = "moveToWorkspace.4"

[[hotkeys]]
binding = "Option+Shift+P"
id = "moveToWorkspace.5"

[[hotkeys]]
binding = "Option+Shift+F"
id = "moveToWorkspace.6"

[[hotkeys]]
binding = "Option+Shift+V"
id = "moveToWorkspace.7"

[[hotkeys]]
binding = "Option+Shift+W"
id = "moveToWorkspace.8"

# Focus (alt-h/j/k/l)
[[hotkeys]]
binding = "Option+H"
id = "focus.left"

[[hotkeys]]
binding = "Option+J"
id = "focus.down"

[[hotkeys]]
binding = "Option+K"
id = "focus.up"

[[hotkeys]]
binding = "Option+L"
id = "focus.right"

# Move (alt-shift-h/j/k/l)
[[hotkeys]]
binding = "Option+Shift+H"
id = "move.left"

[[hotkeys]]
binding = "Option+Shift+J"
id = "move.down"

[[hotkeys]]
binding = "Option+Shift+K"
id = "move.up"

[[hotkeys]]
binding = "Option+Shift+L"
id = "move.right"

# Resize (alt-shift-minus/equal)
[[hotkeys]]
binding = "Option+Shift+-"
id = "setColumnWidth.decrease10Percent"

[[hotkeys]]
binding = "Option+Shift+="
id = "setColumnWidth.increase10Percent"

# Fullscreen + float toggle
[[hotkeys]]
binding = "Control+Option+Command+F"
id = "toggleFullscreen"

[[hotkeys]]
binding = "Control+Option+Shift+Command+F"
id = "toggleNativeFullscreen"

[[hotkeys]]
binding = "Control+Option+Command+T"
id = "toggleFocusedWindowFloating"

# Layout toggle (alt-slash)
[[hotkeys]]
binding = "Option+/"
id = "toggleWorkspaceLayout"

# Monitor focus (alt-tab)
[[hotkeys]]
binding = "Option+Tab"
id = "focusMonitorNext"

# Conflict resolutions — unbind defaults that collide with alt-letter scheme
[[hotkeys]]
binding = "Unassigned"
id = "toggleColumnTabbed"

[[hotkeys]]
binding = "Unassigned"
id = "toggleColumnFullWidth"
```

- [ ] **Step 3: Verify file was written**

```bash
wc -l ~/dotfiles/unison/.config/omniwm/settings.toml && head -20 ~/dotfiles/unison/.config/omniwm/settings.toml
```

Expected: somewhere around 470 lines; first lines match the header comment block.

- [ ] **Step 4: Lint with a TOML parser**

```bash
python3 -c "import tomllib; tomllib.load(open('/Users/manu/dotfiles/unison/.config/omniwm/settings.toml','rb')); print('OK')"
```

Expected: `OK`. Any other output means a TOML syntax error — read the message, locate the line, fix, re-run.

- [ ] **Step 5: Spot-check workspace-to-app-rule consistency**

```bash
grep -E 'assignToWorkspace = "(.+)"' ~/dotfiles/unison/.config/omniwm/settings.toml \
  | sort -u
```

Expected: every distinct value is one of `"1"`, `"2"`, `"3"`, `"4"`, `"5"`, `"6"`, `"8"` — all of which must also exist as `name = "<val>"` in a `[[workspaces]]` block. (Workspace 7 is finder, no app rule; this is fine.)

- [ ] **Step 6: No commit yet** — file will be committed together with the home.nix change at the end (Task 10).

---

## Task 2: Add Unison sync path

**Files:**
- Modify: `~/dotfiles/nix/shared/home.nix` (the `sync-user-prefs.prf` `text = ''…''` block, around line 144)

- [ ] **Step 1: Read the current Unison prefs block to confirm location**

```bash
grep -n "Karabiner" /Users/manu/dotfiles/nix/shared/home.nix
```

Expected: a single match on the comment line right before `path = .config/karabiner/karabiner.json`. Note the line number for orientation.

- [ ] **Step 2: Add the OmniWM path entry immediately after the Karabiner block**

Use the Edit tool to replace this exact block:

```
        # Karabiner (the UI writes to this - unison works better than HM for this)
        path = .config/karabiner/karabiner.json

        ignore = Name {.DS_Store}
```

with:

```
        # Karabiner (the UI writes to this - unison works better than HM for this)
        path = .config/karabiner/karabiner.json

        # OmniWM (the UI writes to this - unison works better than HM for this)
        path = .config/omniwm/settings.toml

        ignore = Name {.DS_Store}
```

- [ ] **Step 3: Verify the change**

```bash
grep -n "omniwm" /Users/manu/dotfiles/nix/shared/home.nix
```

Expected: one match, on the new `path = .config/omniwm/settings.toml` line.

- [ ] **Step 4: No commit yet** — bundled at the end.

---

## Task 3: Apply nix-darwin rebuild

This regenerates `~/.unison/sync-user-prefs.prf` from `home.nix`, which the running Unison launchd agent will pick up on its next scheduled run (or on relaunch).

**Files:** none modified here; we're activating the change from Task 2.

- [ ] **Step 1: Run the rebuild**

```bash
darwin-rebuild switch --flake ~/dotfiles#Auri
```

Expected: ends with `building the system configuration...` and a final summary; no errors. If `darwin-rebuild` isn't on PATH, try `sudo darwin-rebuild switch --flake ~/dotfiles#Auri` or your usual rebuild invocation.

- [ ] **Step 2: Verify the prefs file now includes the new path**

```bash
grep -n "omniwm" ~/.unison/sync-user-prefs.prf
```

Expected: one match showing `path = .config/omniwm/settings.toml`.

- [ ] **Step 3: No commit needed** for this step (no file changes in the repo).

---

## Task 4: Seed the live OmniWM config

OmniWM is already installed at `/Applications/OmniWM.app` (v0.4.9.5) and may have written a default `~/.config/omniwm/settings.toml` on a prior launch. We replace it with our canonical version so Unison sees identical bytes on both sides at next sync.

**Files:**
- Create/overwrite: `~/.config/omniwm/settings.toml`

- [ ] **Step 1: Check if a live config already exists**

```bash
ls -la ~/.config/omniwm/ 2>&1
```

If `settings.toml` already exists, back it up:

```bash
mv ~/.config/omniwm/settings.toml ~/.config/omniwm/settings.toml.pre-port.bak
```

- [ ] **Step 2: Make the live directory if missing, then copy**

```bash
mkdir -p ~/.config/omniwm && \
  cp ~/dotfiles/unison/.config/omniwm/settings.toml ~/.config/omniwm/settings.toml
```

- [ ] **Step 3: Verify byte-identical**

```bash
diff -q ~/dotfiles/unison/.config/omniwm/settings.toml ~/.config/omniwm/settings.toml
```

Expected: no output (files match).

- [ ] **Step 4: Nudge Unison to sync now (optional, will run on its own schedule otherwise)**

```bash
launchctl kickstart -k "gui/$(id -u)/unison.user-pref-sync"
```

Expected: silent success, or `Could not find specified service` — if so, Unison will sync on its next scheduled tick.

---

## Task 5: Launch OmniWM, confirm the config loads

Verifies that the TOML parses on OmniWM's end (Python's `tomllib` from Task 1 confirms syntax, but OmniWM has its own decoder with stricter schema validation).

- [ ] **Step 1: Quit Aerospace first**

If Aerospace is running:

```bash
aerospace quit 2>&1 || true
```

If `aerospace` is not in PATH, quit via the menu bar icon. Confirm:

```bash
pgrep -x AeroSpace; echo "exit:$?"
```

Expected: `exit:1` (no process).

- [ ] **Step 2: Launch OmniWM**

```bash
open -a /Applications/OmniWM.app
```

Expected: OmniWM's menu bar icon appears within ~3 seconds.

- [ ] **Step 3: Confirm it's running and didn't crash on config load**

```bash
pgrep -x OmniWM && echo running
```

Expected: a PID + `running`.

- [ ] **Step 4: Check for parse errors in the log**

```bash
log show --predicate 'process == "OmniWM"' --last 1m --info 2>&1 | \
  grep -iE 'error|warn|invalid|decode|fail' | head -20
```

Expected: no entries about decoding or invalid TOML keys. Borderline-OK: harmless permission warnings. Stop and inspect anything mentioning `CanonicalTOMLConfig`, `AppRule`, `WorkspaceConfiguration`, or `decode`.

- [ ] **Step 5: Confirm OmniWM hasn't rewritten our file**

```bash
diff -q ~/dotfiles/unison/.config/omniwm/settings.toml ~/.config/omniwm/settings.toml
```

Expected: no output. If they differ, OmniWM re-canonicalized on load. Inspect the diff and decide whether to accept it as the new canonical (then `cp` back to dotfiles). Either outcome is fine; we want to be aware.

---

## Task 6: Verify workspaces

- [ ] **Step 1: Look at the workspace bar across both monitors**

Expected (with two monitors connected): the workspace bar shows the 15 workspace `displayName` glyphs in order: `􀎬 􀩼 􁒘 􀝋 􀉉 􀑁 􀏆 􀍉 W A B Q R X Z`. Workspaces `􀎬` and `􀩼` should render on the external display (secondary); the rest on the main.

- [ ] **Step 2: Open Settings → Workspaces (via menu bar icon) and confirm**

15 entries, names `1`–`15`, displayNames as above, layoutType column shows `niri` for all except workspaces `2` (terminal) and `8` (video) which show `dwindle`. Monitor column: `secondary` for `1` and `2`; `main` for the rest.

If anything's wrong, fix in `~/dotfiles/unison/.config/omniwm/settings.toml` (the canonical) — OmniWM will live-reload on save and Unison will sync.

---

## Task 7: Verify hotkeys

For each row, perform the gesture and confirm the expected behavior. With OmniWM's menu bar icon → Settings → Hotkeys, you can also visually confirm the bindings if a hotkey misfires.

- [ ] **Step 1: Workspace switching (alt + letter)**

Press each in turn — the workspace bar's highlighted entry should jump to the indicated displayName:

| Press | Expected workspace |
|---|---|
| `Option+S` | 􀎬 (safari) |
| `Option+T` | 􀩼 (terminal) |
| `Option+C` | 􁒘 (chat) |
| `Option+D` | 􀝋 (slack) |
| `Option+G` | 􀉉 (calendar) |
| `Option+P` | 􀑁 (obsidian) |
| `Option+F` | 􀏆 (finder) |
| `Option+V` | 􀍉 (video) |
| `Option+W` | W |

- [ ] **Step 2: Move-to-workspace (alt + shift + letter)**

Focus any window, then press `Option+Shift+T` — the window should jump to workspace `􀩼` and the workspace switch should follow. Repeat with `Option+Shift+S` to confirm a second instance works.

- [ ] **Step 3: Focus / move (hjkl)**

With ≥2 windows on the same workspace: `Option+H/J/K/L` shifts focus directionally; `Option+Shift+H/J/K/L` swaps the focused window directionally.

- [ ] **Step 4: Fullscreen / float / layout**

- `Control+Option+Command+F` — focused window goes fullscreen within OmniWM (not native).
- `Control+Option+Shift+Command+F` — focused window goes macOS-native fullscreen.
- `Control+Option+Command+T` — focused window toggles between tiling and floating.
- `Option+/` — current workspace flips between niri and dwindle layouts.

- [ ] **Step 5: Resize (Niri workspace only)**

On a niri workspace with ≥2 columns: `Option+Shift+-` shrinks the focused column 10%; `Option+Shift+=` grows it 10%.

- [ ] **Step 6: Monitor focus**

`Option+Tab` — focus moves to the next monitor (this is `focusMonitorNext`, not the Aerospace-style "move workspace to monitor"; behavior intentionally diverges per spec §5).

- [ ] **Step 7: Conflict resolution confirmation**

Press `Option+T` and confirm it switches to workspace `􀩼` (terminal) and does *not* toggle column-tabbed mode. Press `Option+Shift+F` and confirm it moves the focused window to workspace `􀏆` (finder), not toggling column-full-width.

---

## Task 8: Verify app routing rules

- [ ] **Step 1: Launch each managed app, observe routing**

Walk through this list. For each app, quit it if running, then launch fresh and confirm its window lands on the target workspace:

| App (bundleId) | Target workspace |
|---|---|
| Safari (`com.apple.Safari`) | 􀎬 (1) |
| Zen Browser (`app.zen-browser.zen`) | 􀎬 (1) |
| Arc (`company.thebrowser.Browser`) | 􀎬 (1) |
| wezterm (`com.github.wez.wezterm`) | 􀩼 (2) |
| Messages (`com.apple.MobileSMS`) | 􁒘 (3) |
| Telegram (`ru.keepcoder.Telegram`) | 􁒘 (3) |
| Slack (`com.tinyspeck.slackmacgap`) | 􀝋 (4) |
| Mail (`com.apple.mail`) | 􀉉 (5) |
| Fantastical (`com.flexibits.fantastical2.mac`) | 􀉉 (5) |
| BusyCal (`com.busymac.busycal3`) | 􀉉 (5) |
| Obsidian (`md.obsidian`) | 􀑁 (6) |
| Things (`com.culturedcode.ThingsMac`) | 􀑁 (6) |
| Amazon Chime (`com.amazon.Amazon-Chime`) | 􀍉 (8) |
| Zoom (`us.zoom.xos`) | 􀍉 (8) |

You don't need to test every single app — pick 3-4 representative ones across different workspaces. The rules all use the same `assignToWorkspace` mechanism, so if one works the rest are very likely fine.

- [ ] **Step 2: Verify floating rules**

- Open System Settings (`open -b com.apple.systempreferences`) — window should be floating, not tiled.
- Open CARROT Weather and trigger its "Mini Window" (if installed) — that one specific window should float.

---

## Task 9: Verify monitor assignments

Requires the external display connected to behave as `secondary` (your laptop being `main`).

- [ ] **Step 1: Switch to workspace `􀎬` (Option+S) and `􀩼` (Option+T)**

Both should activate on the external (secondary) monitor — the laptop screen continues to show whichever workspace was already on `main`.

- [ ] **Step 2: Switch to any other workspace (e.g., `Option+C` for chat)**

The newly-activated workspace should appear on `main` (laptop), not the external.

- [ ] **Step 3: If terminal/safari land on the wrong monitor**

Likely means `main` vs `secondary` doesn't map the way the spec assumed for your setup. Two options:

  a. Swap the two assignments — edit `~/dotfiles/unison/.config/omniwm/settings.toml` to set workspaces `1` and `2` to `type = "main"` and pick two other workspaces for `type = "secondary"`. OmniWM live-reloads on save.

  b. Switch to `specificDisplay` with an OutputId. In OmniWM Settings → Monitors, find the OutputId for each connected display. Then change the workspace block to:

  ```toml
  [workspaces.monitorAssignment]
  type = "specificDisplay"
  output = { id = "<OutputId-here>", name = "<Display Name>" }
  ```

  (Schema reference: `Sources/OmniWM/Core/Config/WorkspaceConfig.swift` in the OmniWM repo.)

---

## Task 10: Commit everything

- [ ] **Step 1: Stage the two repo changes**

```bash
git -C ~/dotfiles add \
  unison/.config/omniwm/settings.toml \
  nix/shared/home.nix
```

- [ ] **Step 2: Confirm the staged diff is what you expect**

```bash
git -C ~/dotfiles diff --cached --stat
```

Expected: `unison/.config/omniwm/settings.toml` (new file, ~470 insertions) and `nix/shared/home.nix` (3 insertions for the comment + path line + blank).

- [ ] **Step 3: Commit**

```bash
git -C ~/dotfiles commit -m "$(cat <<'EOF'
Add OmniWM config ported from Aerospace

Adds settings.toml mirroring the Aerospace workspace/hotkey scheme so both
window managers can run side-by-side. Registered with Unison sync alongside
Karabiner and the other GUI-managed configs.

See docs/superpowers/specs/2026-05-24-omniwm-config-port-design.md for the
design and known gaps (Karabiner forwarding for the 6 unbound workspaces +
alt-enter execs deferred).
EOF
)"
```

- [ ] **Step 4: Confirm it landed**

```bash
git -C ~/dotfiles log --oneline -1 && git -C ~/dotfiles status --short
```

Expected: the new commit at the top of the log; `unison/...` and `nix/shared/home.nix` no longer in the dirty list.

---

## Done criteria

- `~/dotfiles/unison/.config/omniwm/settings.toml` and `~/.config/omniwm/settings.toml` are byte-identical.
- OmniWM is running with the new config; 15 workspaces visible in the bar with the SF Symbol displayNames.
- The 9 alt-letter workspace bindings all switch correctly; the 9 alt-shift-letter bindings all move-and-follow.
- At least one app rule routes a freshly-launched window to its expected workspace.
- Aerospace remains installed and launchable; the user can switch between WMs by quitting one and launching the other.
- The dotfiles commit captures both the new file and the `home.nix` sync path.
- The 6 follow-up TODOs from spec §7 remain open (Karabiner forwarding, exec bindings, monitor pin verification, etc.).
