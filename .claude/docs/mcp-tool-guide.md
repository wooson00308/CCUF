# MCP Tool Guide — 실전 사용 빈도 기반

Unity MCP 도구를 실제 프로젝트에서 써본 결과 기반 가이드.
80%의 작업이 script-execute + assets-refresh + scene-save로 끝난다.

## Tier 1 — 거의 매 작업 사용

| 도구 | 용도 | 비고 |
|------|------|------|
| `script-execute` | 만능. 하이라키 덤프, 일괄 수정, 와이어링, 색상 변경 | Roslyn C#. class + static method 필수 |
| `assets-refresh` | 코드 수정 후 컴파일 확인 | 응답에 에러 포함. Warning도 확인할 것 |
| `scene-save` | 씬 저장 | 플레이모드에서 호출 시 실패. 먼저 에디트 모드로 |
| `editor-application-set-state` | 플레이모드 진입/종료 | isPlaying: true/false |
| `editor-application-get-state` | 현재 상태 확인 | 컴파일 중인지, 플레이 중인지 |

## Tier 2 — 자주 사용

| 도구 | 용도 | 비고 |
|------|------|------|
| `scene-list-opened` | 열린 씬 확인 | 씬 전환 전 현재 상태 파악 |
| `assets-find` | 에셋 검색 | `t:Scene`, `t:Shader` 등 타입 필터 |
| `console-get-logs` | 에러/경고 확인 | assets-refresh 후 상세 로그 필요 시 |
| `gameobject-find` | 단일 오브젝트 조회 | 컴포넌트 목록 프리뷰 포함 |
| `gameobject-component-get` | 컴포넌트 상세 | SerializedField 값 확인 |

## Tier 3 — 상황적 사용

| 도구 | 용도 | 비고 |
|------|------|------|
| `scene-open` | 씬 전환 | 경로에 공백 있으면 script-execute로 우회 |
| `gameobject-component-add` | 컴포넌트 추가 | 단일 추가만. 일괄은 script-execute |
| `screenshot-game-view` | 게임뷰 캡처 | Y축 반전 이슈 있음. ScreenCapture API 선호 |

## 비추천 — 있지만 script-execute가 나은 것들

| 도구 | 문제 | 대안 |
|------|------|------|
| `gameobject-create` | 한 번에 하나. 반복 비효율 | script-execute로 일괄 생성 |
| `gameobject-component-modify` | 복잡한 수정 시 한계 | script-execute + SerializedObject |
| `assets-modify` | 명시 안 한 SO 필드가 0으로 리셋 | YAML 직접 수정 + assets-refresh |
| `screenshot-scene-view` | Scene View는 UI 검증에 부적합 | ScreenCapture + 플레이모드 |

## script-execute가 만능인 이유

- FindObjectsOfType + 필터링 = 한 번에 조건부 검색
- SerializedObject = 씬 영구 반영
- for 루프 = 일괄 처리
- StringBuilder = 구조화된 결과 반환
- EditorUtility.SetDirty + MarkSceneDirty = 변경 추적
- Resources.FindObjectsOfTypeAll = 비활성 오브젝트도 탐색

개별 MCP 툴을 3번 이상 반복 호출할 상황이면, script-execute 하나로 합쳐라.

## 스크린샷 검증 — ScreenCapture vs screenshot-game-view

| | ScreenCapture API | screenshot-game-view |
|---|---|---|
| 호출 | script-execute 안에서 | MCP 도구 직접 |
| 조건 | 플레이모드 필수 | 에디트 모드 가능 |
| Y축 | 정상 | 반전 (OpenGL 좌표계) |
| 파일 | 프로젝트 루트에 저장 | base64 반환 |
| 권장 | O | 보조용 |
