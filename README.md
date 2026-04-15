# CCUF — Claude Code Unity Framework

*Stop guessing. Start building.*

---

A battle-tested guardrail + skill framework for Unity projects powered by [Unity MCP](https://github.com/IvanMurzak/Unity-MCP).

Born from real production work — every rule exists because something broke without it.

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Claude Code │────►│  Unity MCP   │────►│ Unity Editor │
│  (you + AI)  │     │  (bridge)    │     │ (scene/code) │
└──────────────┘     └──────────────┘     └──────────────┘
       │                                         ▲
       ▼                                         │
┌──────────────┐                          ┌──────────────┐
│  .claude/    │  skills, hooks, rules    │  script-     │
│  (this repo) │─────────────────────────►│  execute     │
└──────────────┘  guardrails + patterns   └──────────────┘
```

---

## Why this exists

Other frameworks give you 47 agents and 72 skills.
This one gives you 7 skills and 2 hooks — all proven in production.

| Other frameworks | CCUF |
|------------------|------|
| "Follow CRAP principles" | Here's the exact RGB values that work |
| "Use LayoutGroup properly" | Here's 11 rules from actual bugs we hit |
| "Don't edit scene files directly" | Hook that blocks it before you can |
| 47 virtual studio members | 1 person + MCP = direct scene control |

---

## Prerequisites

- [Unity MCP](https://github.com/IvanMurzak/Unity-MCP) — Lets Claude Code talk directly to Unity Editor. Every skill in this framework depends on it. See that repo for installation.
- [Claude Code](https://claude.ai/claude-code)
- DOTween (optional — for `dotween-patterns` skill)

---

## Quick Start

```bash
# 1. Clone into your project
git clone https://github.com/user/CCUF.git /tmp/ccuf
cp -r /tmp/ccuf/.claude your-unity-project/.claude

# 2. Open Unity + start Claude Code in your project dir
cd your-unity-project
claude

# 3. Session starts → hook auto-checks MCP connection
# [CCUF] Unity MCP 연결 확인됨.

# 4. Start working
# "씬 봐줘" → /unity skill triggers
# "UI 만들자" → ugui + dark-ui skills guide the work
# "DOTween 넣자" → dotween-patterns keeps it safe
```

---

## User Flow

### First time setup
```
Install Unity MCP → Copy .claude/ folder → Done.
```

### Every session
```
┌─ Session Start ──────────────────────────────┐
│  hook: check-unity-mcp.sh                    │
│  → CLI installed? Editor connected? ✓        │
└──────────────────────────────────────────────┘
         │
         ▼
┌─ Scene Work ─────────────────────────────────┐
│  skill: unity                                │
│  → script-execute for batch ops              │
│  → SerializedObject for permanent wiring     │
│  → ScreenCapture for visual verification     │
│                                              │
│  guardrail: validate-scene-access.sh         │
│  → .unity direct edit? BLOCKED.              │
└──────────────────────────────────────────────┘
         │
         ▼
┌─ UI Work ────────────────────────────────────┐
│  skill: ugui-layout-checklist                │
│  → childControlWidth=true, flexibleHeight=0  │
│  → LayoutElement only, never sizeDelta       │
│                                              │
│  skill: dark-ui-design                       │
│  → L1/L2/L3 color values                    │
│  → Button 3-tier (Standard/CTA/Ghost)        │
│  → 8px grid spacing                          │
│                                              │
│  skill: uiux-design-principles               │
│  → CRAP diagnostic, Gestalt, visual hierarchy│
│  → "Why does this look wrong?" answers       │
└──────────────────────────────────────────────┘
         │
         ▼
┌─ Animation ──────────────────────────────────┐
│  skill: dotween-patterns                     │
│  → LayoutGroup-safe: root slide only         │
│  → Popup: scale 0.92→1 + fade (OutBack)     │
│  → View transition: 40px slide + fade        │
└──────────────────────────────────────────────┘
         │
         ▼
┌─ Verify & Debug ─────────────────────────────┐
│  skill: scene-inspector                      │
│  → Hierarchy dump, color audit, layout check │
│                                              │
│  skill: unity-debug                          │
│  → Editor.log parsing, error detection       │
└──────────────────────────────────────────────┘
```

---

## What's Inside

### Skills (7)

| Skill | What it does |
|-------|-------------|
| `unity` | MCP editor interaction mode — script-execute patterns, wiring, screenshot workflow |
| `unity-debug` | Editor log parsing for compile/runtime errors |
| `ugui-layout-checklist` | 11 LayoutGroup rules from real bugs — childControl, flexibleHeight, ForceRebuild |
| `uiux-design-principles` | CRAP, Gestalt, visual hierarchy, spacing theory + 4 reference docs |
| `dark-ui-design` | Concrete dark UI system — L1/L2/L3 RGB values, button tiers, accent color |
| `dotween-patterns` | LayoutGroup-safe animation patterns — view transitions, popups, stagger |
| `scene-inspector` | script-execute diagnostic snippets — hierarchy dump, color audit, layout validation |

### Hooks (2)

| Hook | Event | What it does |
|------|-------|-------------|
| `check-unity-mcp.sh` | SessionStart | Verifies unity-mcp-cli is installed and Editor is reachable |
| `validate-scene-access.sh` | PreToolUse (Edit/Write) | Blocks direct .unity file editing — use MCP tools instead |

### Rules (3)

| Rule | Paths | What it enforces |
|------|-------|-----------------|
| `scene-safety.md` | `**/*.unity` | No direct scene read/write, SerializedObject for wiring |
| `ugui-code.md` | `**/UI/**/*.cs` | LayoutElement-only sizing, ColorBlock white, no magic numbers |
| `mcp-workflow.md` | `**/*.cs` | script-execute first, no agent delegation for complex UI |

### Docs (2)

| Doc | What it covers |
|-----|---------------|
| `known-pitfalls.md` | Every bug we actually hit — MCP, UGUI, design. With solutions. |
| `mcp-tool-guide.md` | Tool tier list by real usage frequency. 80% of work = 3 tools. |

---

## Philosophy

- **Bottom-up, not top-down.** Every rule here was a bug first.
- **Concrete, not abstract.** RGB values, not "use appropriate contrast."
- **Lean, not comprehensive.** 7 skills that all get used > 72 skills that mostly don't.
- **MCP-native.** This isn't "AI writes code." It's "AI controls the editor."

---

## License

MIT
