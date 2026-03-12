This document serves as the **Standard Operating Procedure (SOP) and Development Plan** for the *Star Wars: Forgotten Ones* Campaign Log System. It outlines the architecture, automation pipeline, and maintenance requirements for the Datapad interface.

---

# 1. Project Overview

The "Project Holonet" Log System is a custom-built web archive designed to display Discord-based roleplay sessions in an immersive "In-Universe Datapad" interface. It supports two primary formats:

1. **Markdown Logs:** Curated, long-form story entries.
2. **JSON Transmissions:** Dynamic, filtered logs exported directly from Discord via Discrub, featuring automatic thread detection, frequency shifting, and interactive smart-links.

---

# 2. System Architecture & Data Flow

### The Pipeline

1. **Export:** Raw Discord data is exported using Discrub as JSON.
2. **Local Processing:** The `discrub_JSON_convert.ps1` script processes files for local media paths and chronological sorting.
3. **Upload:** Processed JSON files are uploaded to `/Chapter_Logs/JSON/`.
4. **Automation (Manifest Generator):** A GitHub Action triggers on push, scans the JSON files, extracts the "Chapter Title" from the content, and updates `log-manifest.json`.
5. **Render:** The `json-viewer.html` layout fetches the manifest and renders the selected log with Star Wars-themed formatting.

---

# 3. Development Standards (CSS & Layout)

To prevent code bloat and "sticky" position failures, the CSS is strictly partitioned:

### A. Universal Styling (`/assets/style.css`)

Contains shared brand assets:

* **Color Palette:** `--sw-blue`, `--sw-yellow`, `--gh-bg`.
* **Typography:** Datapad fonts and line heights.
* **Shared UI:** The `.frozen-nav` (Top Sticky Bar), `.toc-open-btn` (Buttons), and universal Discord formatting (Spoilers, Gold Text, Subtext).
* **Stabilization:** `overflow-x: hidden` on `html/body` to prevent mobile zoom bugs.

### B. Layout-Specific Styling (Embedded in HTML)

* **`log-entry.html`:** Contains the slide-out Table of Contents (TOC) and the GitHub-Markdown compatibility layer.
* **`json-viewer.html`:** Contains the Avatar logic, Frequency Bar positioning, and Message Feed layout.

---

# 4. Automation: The Log Manifest

Instead of manual indexing, the system uses an automated manifest to generate "Pretty Names" and handle sorting.

### Title Extraction Logic

The system identifies the "Pretty Name" for the dropdown by peeking into the first 50 messages of a JSON file for a line matching this pattern:

* **Format:** `# [Any Text] (Chapter|Prelude) [Any Text]`
* **Example:** `# CHAPTER IV: RESONANCE FREQUENCY`
* **Fallback:** If no header is found, it cleans the filename (e.g., `FO_Ch4.json` becomes `FO CH4`).

### GitHub Action: `update-manifest.yml`

Located in `.github/workflows/`, this script:

1. Scans `/Chapter_Logs/JSON/`.
2. Extracts the Title and a numeric `order` (based on filename digits).
3. Saves a sorted array to `log-manifest.json`.

---

# 5. The "Smart" JSON Viewer Logic

### Thread Detection (The Pre-Scan)

Before rendering, the JavaScript performs a "Deep Pre-Scan" of the JSON. It looks for `thread` objects.

* **Main Channel:** The ID most frequently cited as a `parent_id` is designated the "Master Frequency."
* **Thread Names:** Maps individual `channel_id`s to their human-readable thread names.

### Interactive Elements

* **Frequency Shift Markers:** When a user views the "Combined Feed," the system inserts a clickable dashed-line marker when the conversation moves from the Bridge to a Thread.
* **Smart Anchors:** Discord links (e.g., `discord.com/channels/...`) are converted into internal jumps if the target message exists in the current log.
* **Lazy Avatar Probes:** To prevent "broken image" flashes on mobile, avatars load a default placeholder and only fade in the character-specific avatar once the browser confirms the file exists locally.

---

# 6. Maintenance SOP

### Adding a New JSON Log

1. Place the raw JSON in `/Chapter_Logs/JSON/`.
2. Ensure the **first message** of the log contains a Markdown Header with the Chapter title (e.g., `# CHAPTER V: THE UNKNOWN`).
3. Upload any new avatars to `/Chapter_Logs/avatars/[UserID]/`.
4. Push to GitHub. The manifest will update automatically, and the log will appear at the top of the "Select Transmission" list.

### Adding a New Markdown Log

1. Create a new `.md` file in `/Chapter_Logs/`.
2. Set the Front Matter:
```yaml
layout: log-entry
title: "Chapter Title"
order: 5

```


3. The footer "Next/Prev" and sidebar TOC will generate automatically based on `order`.

---

# 7. Troubleshooting & Known Constraints

* **Stickiness Failure:** If the top navigation stops sticking, verify that no parent `div` or the `main` tag has `overflow: hidden` or `display: flex` applied without a height.
* **Mobile Zoom:** If the screen can be "zoomed out" revealing empty space on the right, ensure `style.css` contains `overflow-x: hidden` on both `html` and `body`.
* **White Buttons:** If buttons appear white/grey, ensure they have the `!important` flag in `style.css` to override browser-default `<button>` gradients.
* **Alignment:** Both the Top Nav and the Frequency Bar must use a `.nav-inner` container with `max-width: 900px` and `margin: 0 auto` to stay perfectly aligned.

---

**End of SOP.**
*Author: Project Technical Lead & Gemini Coding Partner*
*Version: 1.2.0 (Manifest Edition)*