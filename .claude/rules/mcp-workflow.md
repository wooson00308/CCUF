---
paths: ["**/*.cs"]
---

# MCP Workflow Rules

1. 하이라키 탐색, 일괄 수정은 script-execute 우선. 개별 MCP 툴 3회 이상 반복 금지.
2. 씬 와이어링(SerializeField 연결)은 SerializedObject. 리플렉션 SetValue는 리컴파일 시 날아감.
3. assets-refresh 후 에러 확인. Warning 무시하지 말 것.
4. 에이전트에게 복잡한 UGUI 씬 작업 위임 금지. LayoutElement 비율이 깨짐.
5. 스크린샷은 ScreenCapture API (플레이모드, 상대경로). screenshot-game-view는 Y축 반전 이슈.
