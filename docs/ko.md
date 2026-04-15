# CCUF — Claude Code Unity Framework

_Unity MCP로 에디터를 직접 제어하는 실전 가드레일 프레임워크._

**[English](../README.md)**

---

[Unity MCP](https://github.com/IvanMurzak/Unity-MCP) 기반의 스킬 + 가드레일 프레임워크입니다.

실제 프로젝트에서 겪은 문제들을 해결하면서 만들어졌습니다. 모든 규칙은 버그에서 시작됐습니다.

```mermaid
graph LR
    A[Claude Code] -->|MCP| B[Unity MCP Server]
    B -->|API| C[Unity Editor]
    A -->|참조| D[.claude/]
    D -->|스킬·훅·규칙| E[script-execute]
    E -->|씬 조작| C
```

---

## 왜 만들었나

매 세션마다 ".unity 파일 직접 편집하지 마" 라고 타이핑하는 건 비효율적입니다.
LayoutGroup 규칙, 색상 체계, MCP 패턴을 매번 다시 설명하는 것도 마찬가지입니다.

이 프레임워크는 반복되는 지시를 영구적인 가드레일로 바꿔줍니다.

| CCUF 없이 | CCUF 있으면 |
|-----------|------------|
| "LayoutElement 써, sizeDelta 말고" | UI 코드 건드리면 규칙이 자동 로드됩니다 |
| "MCP 연결부터 확인해" | 세션 시작 시 훅이 자동 확인합니다 |
| "이 L1/L2/L3 컬러값 써..." | 스킬이 정확한 RGB 값을 제공합니다 |
| ".unity 파일 직접 편집하지 마" | 훅이 편집 전에 차단합니다 |

---

## 요구사항

- [Unity MCP](https://github.com/IvanMurzak/Unity-MCP) — Claude Code에서 Unity Editor를 직접 조작할 수 있게 하는 MCP 서버입니다. 이 프레임워크의 모든 스킬이 이를 전제로 동작합니다. 설치 방법은 해당 레포를 참고하세요.
- [Claude Code](https://claude.ai/claude-code)
- DOTween (선택 — `dotween-patterns` 스킬 사용 시)

---

## 빠른 시작

```bash
# 1. 프로젝트에 복사
git clone https://github.com/wooson00308/CCUF.git /tmp/ccuf
cp -r /tmp/ccuf/.claude your-unity-project/.claude

# 2. Unity를 열고 프로젝트 디렉토리에서 Claude Code를 실행합니다
cd your-unity-project
claude

# 3. 세션 시작 시 훅이 MCP 연결을 자동 확인합니다
# [CCUF] Unity MCP 연결 확인됨.

# 4. 작업을 시작합니다
# "씬 봐줘" → /unity 스킬 트리거
# "UI 만들자" → ugui + dark-ui 스킬이 가이드
# "DOTween 넣자" → dotween-patterns로 안전하게
```

---

## 사용 플로우

### 최초 세팅

Unity MCP 설치 → `.claude/` 폴더 복사 → 끝.

### 매 세션

```mermaid
graph TD
    A[세션 시작] -->|check-unity-mcp.sh| B{MCP 연결됨?}
    B -->|Yes| C[씬 작업]
    B -->|No| B2[경고: Editor 확인 필요]
    C -->|unity 스킬| D[script-execute 중심 작업]
    D --> E{UI 작업?}
    E -->|Yes| F[ugui-layout-checklist<br/>dark-ui-design<br/>uiux-design-principles]
    E -->|No| G{연출 필요?}
    F --> G
    G -->|Yes| H[dotween-patterns]
    G -->|No| I[검증]
    H --> I
    I -->|scene-inspector| J[하이라키 덤프·색상 감사]
    I -->|unity-debug| K[에러 로그 확인]
```

---

## 구성 요소

### 스킬 (7개)

| 스킬 | 역할 |
|------|------|
| `unity` | MCP 에디터 조작 모드 — script-execute 패턴, 와이어링, 스크린샷 워크플로우 |
| `unity-debug` | 에디터 로그 파싱으로 컴파일/런타임 에러 감지 |
| `ugui-layout-checklist` | 실제 버그에서 나온 LayoutGroup 규칙 11개 |
| `uiux-design-principles` | CRAP, 게슈탈트, 시각적 위계, 간격 이론 + 레퍼런스 4개 |
| `dark-ui-design` | 다크 UI 실전 체계 — L1/L2/L3 RGB 값, 버튼 티어, 액센트 컬러 |
| `dotween-patterns` | LayoutGroup 안전한 애니메이션 패턴 |
| `scene-inspector` | script-execute 진단 스니펫 모음 |

### 훅 (2개)

| 훅 | 이벤트 | 역할 |
|---|--------|------|
| `check-unity-mcp.sh` | SessionStart | unity-mcp-cli 설치 확인 + Editor 연결 확인 |
| `validate-scene-access.sh` | PreToolUse | .unity 파일 직접 편집 차단 |

### 규칙 (3개)

| 규칙 | 적용 경로 | 내용 |
|------|----------|------|
| `scene-safety.md` | `**/*.unity` | 씬 직접 읽기/쓰기 금지 |
| `ugui-code.md` | `**/UI/**/*.cs` | LayoutElement만 크기 제어, ColorBlock white 필수 |
| `mcp-workflow.md` | `**/*.cs` | script-execute 우선, 복잡한 UI는 에이전트 위임 금지 |

### 문서 (2개)

| 문서 | 내용 |
|------|------|
| `known-pitfalls.md` | 실제로 겪은 모든 버그와 해결법 |
| `mcp-tool-guide.md` | 실전 사용 빈도 기반 도구 티어 분류 |

---

## 철학

- **바텀업.** 모든 규칙은 먼저 버그였습니다.
- **구체적.** "적절한 대비를 사용하세요" 대신 RGB 값을 제공합니다.
- **군더더기 없이.** 전부 쓰이는 7개 스킬이 대부분 안 쓰이는 72개 스킬보다 낫습니다.
- **MCP 네이티브.** "AI가 코드를 생성"이 아니라 "AI가 에디터를 조작"합니다.

---

## 라이선스

MIT
