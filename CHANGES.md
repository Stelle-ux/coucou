# Mark-LI / JARVIS Integration & Updates Log

## Overview
This log documents all architectural decisions, fixes, and code modifications made to integrate **JARVIS / Mark-LI** into Coucou across macOS, Windows, Linux, and Android.

---

## 1. Catalog & Identification
- **Pill ID:** `agent_mark-li`
- **Agent Identifier (`coucou_agent`):** `mark-li`
- **Name:** `JARVIS / Mark-LI`
- **Short Name / Header Subtitle:** `JARVIS`
- **Color Accent:** Cyan `#00D4FF` (matches Mark-LI default UI theme)
- **Category:** `agent`
- **Connection Type:** `hooks` (receives live events from the agent runtime via Coucou's local relay / hook server)

---

## 2. Detailed Updates Made Across the Codebase

### A. Windows & Linux App (`windows/src/`)
1. **`windows/src/core/pills.ts`**
   - Registered `agent_mark-li` into `PILL_CATALOG` with `connect: hooks`, category `agent`, color `#00D4FF`.
   - Updated `sessionSubtitle(id)`: returns `"JARVIS"` when `id === "agent_mark-li"`.
   - Ensured `isHookPill("agent_mark-li")` returns `true` so sessions register with hook event handling.

2. **`windows/src/island/agents.ts`**
   - Added `mark-li` entry to `KNOWN_AGENTS`:
     ```ts
     "mark-li": { name: "JARVIS / Mark-LI", color: "#00D4FF" },
     ```
   - Cleaned up duplicate/phantom entries to maintain single-canonical-key integrity.

3. **`windows/src/island/hooks.ts`**
   - Standardized routing directly on `rawAgent = validateAgent(payload.coucou_agent)`.
   - Removed temporary remap shims. Any payload carrying `coucou_agent: "mark-li"` routes directly to `agent_mark-li`.
   - Verified permission requests, cards, and session steps lifecycle.

4. **`windows/src/views/integrations.ts`**
   - Added an idle card action button for `agent_mark-li` that launches Mark-LI's local dashboard:
     ```ts
     h("button", {
       class: "link-btn",
       style: `color:${task.color}d9`,
       text: t("Open {name}", { name: "JARVIS" }),
       onclick: () => void Bridge.openUrl("http://127.0.0.1:8000"),
     })
     ```

5. **`windows/src/recap/summary.ts`**
   - Added `agent_mark-li` to `AGENT_NAMES` map for weekly recap and stats cards.

### B. macOS & iOS App (`NotchBuddy/`)
1. **`NotchBuddy/Sources/CoucouKit/PillCatalog.swift`**
   - Added `agent_mark-li` to `PillCatalog.all`:
     ```swift
     .init(id: "agent_mark-li", name: "JARVIS / Mark-LI", color: "#00D4FF",
           category: .agent, subtitle: String(localized: "Agent"), source: .agent)
     ```
   - Added `agent_mark-li` to `sessionSubtitle(id:)`:
     ```swift
     case "agent_mark-li": return "JARVIS"
     ```

2. **`tests/PillFixture.swift`**
   - Added `agent_mark-li` to test fixtures to ensure parity with `PillCatalog.swift`.

### C. Android App (`android/`)
1. **`android/app/src/main/kotlin/com/coucou/android/core/Pills.kt`**
   - Added `agent_mark-li` definition to `Pills.CATALOG`:
     ```kotlin
     PillDefinition("agent_mark-li", "JARVIS / Mark-LI", "#00D4FF", PillCategory.AGENT)
     ```

### D. Test Suite (`windows/tests/`)
1. **`windows/tests/agents.test.mjs`**
   - Verified `agentName("mark-li") === "JARVIS / Mark-LI"`.
   - Verified `agentColor("mark-li") === "#00D4FF"`.
2. **`windows/tests/hooks.test.mjs`**
   - Added test: `"a JARVIS / Mark-LI session routes to agent_mark-li in its cyan colour"`.
   - Uses `coucou_agent: "mark-li"`.
3. **`windows/tests/pills.test.mjs`**
   - Verified catalog definitions, availability across platforms, and hook-driven pill list (`isHookPill`).
   - Verified `sessionSubtitle("agent_mark-li") === "JARVIS"`.
   - Full suite passes: **562 tests, 0 failures**.

---

## 3. Startup & Autorun Configuration
- **JARVIS Startup Behavior:** As requested, JARVIS is **NOT** configured to autorun on system startup.
- Coucou itself manages its own window state and does not spawn external Python processes or register them in Windows Registry `Run` keys or Startup folders.
- Starting Mark-LI remains on-demand (`python main.py` or through the user's preferred task script).
