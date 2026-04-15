# CCUF — Claude Code Unity Framework

*추측 그만. 바로 만들자.*

---

[Unity MCP](https://github.com/IvanMurzak/Unity-MCP) 기반의 실전 검증 가드레일 + 스킬 프레임워크.

모든 규칙은 실제로 뭔가가 터졌기 때문에 존재한다.

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Claude Code │────►│  Unity MCP   │────►│ Unity Editor │
│  (너 + AI)   │     │  (브릿지)     │     │ (씬/코드)    │
└──────────────┘     └──────────────┘     └──────────────┘
       │                                         ▲
       ▼                                         │
┌──────────────┐                          ┌──────────────┐
│  .claude/    │  스킬, 훅, 규칙          │  script-     │
│  (이 레포)    │─────────────────────────►│  execute     │
└──────────────┘  가드레일 + 패턴          └──────────────┘
```

---

## 왜 만들었나

다른 프레임워크는 47개 에이전트와 72개 스킬을 준다.
이건 7개 스킬과 2개 훅 — 전부 실전에서 검증된 것만.

| 다른 프레임워크 | CCUF |
|----------------|------|
| "CRAP 원칙을 따르세요" | 실제로 작동하는 RGB 값을 줌 |
| "LayoutGroup을 올바르게 사용하세요" | 실제 버그에서 나온 11개 규칙 |
| "씬 파일을 직접 편집하지 마세요" | 편집 시도하면 훅이 차단함 |
| 가상 스튜디오 47명 | 1명 + MCP = 에디터 직접 제어 |

---

## 전제 조건

- [Unity MCP](https://github.com/IvanMurzak/Unity-MCP) — Claude Code에서 Unity Editor를 직접 조작하는 MCP 서버. 이 프레임워크의 모든 스킬이 이걸 전제로 동작함. 설치 방법은 해당 레포 참조.
- [Claude Code](https://claude.ai/claude-code)
- DOTween (선택 — `dotween-patterns` 스킬 사용 시)

---

## 빠른 시작

```bash
# 1. 프로젝트에 복사
git clone https://github.com/user/CCUF.git /tmp/ccuf
cp -r /tmp/ccuf/.claude your-unity-project/.claude

# 2. Unity 열고 + 프로젝트 디렉토리에서 Claude Code 실행
cd your-unity-project
claude

# 3. 세션 시작 → 훅이 MCP 연결 자동 확인
# [CCUF] Unity MCP 연결 확인됨.

# 4. 작업 시작
# "씬 봐줘" → /unity 스킬 트리거
# "UI 만들자" → ugui + dark-ui 스킬이 가이드
# "DOTween 넣자" → dotween-patterns가 안전하게
```

---

## 사용 플로우

### 최초 세팅
```
Unity MCP 설치 → .claude/ 폴더 복사 → 끝.
```

### 매 세션
```
┌─ 세션 시작 ──────────────────────────────────┐
│  훅: check-unity-mcp.sh                      │
│  → CLI 설치됨? Editor 연결됨? ✓               │
└──────────────────────────────────────────────┘
         │
         ▼
┌─ 씬 작업 ───────────────────────────────────┐
│  스킬: unity                                 │
│  → 일괄 작업은 script-execute                 │
│  → 영구 와이어링은 SerializedObject            │
│  → 시각 검증은 ScreenCapture                  │
│                                              │
│  가드레일: validate-scene-access.sh           │
│  → .unity 직접 편집? 차단.                    │
└──────────────────────────────────────────────┘
         │
         ▼
┌─ UI 작업 ───────────────────────────────────┐
│  스킬: ugui-layout-checklist                 │
│  → childControlWidth=true, flexibleHeight=0  │
│  → LayoutElement만, sizeDelta 금지            │
│                                              │
│  스킬: dark-ui-design                        │
│  → L1/L2/L3 컬러 값                          │
│  → 버튼 3티어 (Standard/CTA/Ghost)            │
│  → 8px 그리드 간격                            │
│                                              │
│  스킬: uiux-design-principles                │
│  → CRAP 진단, 게슈탈트, 시각적 위계            │
│  → "이거 왜 이상해?" 에 대한 답                │
└──────────────────────────────────────────────┘
         │
         ▼
┌─ 연출 ─────────────────────────────────────┐
│  스킬: dotween-patterns                     │
│  → LayoutGroup 안전: 루트에서만 슬라이드      │
│  → 팝업: scale 0.92→1 + fade (OutBack)     │
│  → 뷰 전환: 40px 슬라이드 + 페이드           │
└─────────────────────────────────────────────┘
         │
         ▼
┌─ 검증 & 디버그 ────────────────────────────┐
│  스킬: scene-inspector                      │
│  → 하이라키 덤프, 색상 감사, 레이아웃 검증    │
│                                              │
│  스킬: unity-debug                           │
│  → Editor.log 파싱, 에러 감지                │
└──────────────────────────────────────────────┘
```

---

## 구성 요소

### 스킬 (7개)

| 스킬 | 역할 |
|------|------|
| `unity` | MCP 에디터 조작 모드 — script-execute 패턴, 와이어링, 스크린샷 워크플로우 |
| `unity-debug` | 에디터 로그 파싱으로 컴파일/런타임 에러 감지 |
| `ugui-layout-checklist` | 실제 버그에서 나온 LayoutGroup 규칙 11개 — childControl, flexibleHeight, ForceRebuild |
| `uiux-design-principles` | CRAP, 게슈탈트, 시각적 위계, 간격 이론 + 레퍼런스 4개 |
| `dark-ui-design` | 다크 UI 실전 체계 — L1/L2/L3 RGB 값, 버튼 티어, 액센트 컬러 |
| `dotween-patterns` | LayoutGroup 안전한 애니메이션 패턴 — 뷰 전환, 팝업, 스태거 |
| `scene-inspector` | script-execute 진단 스니펫 — 하이라키 덤프, 색상 감사, 레이아웃 검증 |

### 훅 (2개)

| 훅 | 이벤트 | 역할 |
|---|--------|------|
| `check-unity-mcp.sh` | SessionStart | unity-mcp-cli 설치 + Editor 연결 확인 |
| `validate-scene-access.sh` | PreToolUse (Edit/Write) | .unity 파일 직접 편집 차단 — MCP 도구 사용 강제 |

### 규칙 (3개)

| 규칙 | 적용 경로 | 내용 |
|------|----------|------|
| `scene-safety.md` | `**/*.unity` | 씬 직접 읽기/쓰기 금지, SerializedObject 와이어링 |
| `ugui-code.md` | `**/UI/**/*.cs` | LayoutElement만 크기 제어, ColorBlock white, 매직넘버 금지 |
| `mcp-workflow.md` | `**/*.cs` | script-execute 우선, 복잡한 UI는 에이전트 위임 금지 |

### 문서 (2개)

| 문서 | 내용 |
|------|------|
| `known-pitfalls.md` | 실제로 겪은 모든 버그 — MCP, UGUI, 디자인. 해결법 포함. |
| `mcp-tool-guide.md` | 실전 사용 빈도 기반 도구 티어 분류. 작업의 80% = 도구 3개. |

---

## 철학

- 바텀업. 모든 규칙은 먼저 버그였다.
- 구체적. "적절한 대비를 사용하세요" 대신 RGB 값을 준다.
- 군더더기 없이. 전부 쓰이는 7개 스킬 > 대부분 안 쓰이는 72개 스킬.
- MCP 네이티브. "AI가 코드를 생성"이 아니라 "AI가 에디터를 조작."

---

## 라이센스

MIT
