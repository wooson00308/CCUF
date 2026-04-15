---
paths: ["**/*.unity"]
---

# Scene Safety Rules

1. .unity 파일을 직접 읽거나 수정하지 말 것
2. 씬 조작은 Unity MCP 툴 또는 script-execute를 통해서만
3. 플레이모드에서 씬 수정/저장 금지
4. SerializedObject + ApplyModifiedProperties로 영구 와이어링
5. 수정 후 EditorSceneManager.MarkSceneDirty + scene-save
