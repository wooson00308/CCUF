# Unity MCP Workflow Rules

Unity MCP 연동 작업 시 항상 적용되는 규칙.

## 씬 조작

1. .unity 파일 직접 읽기/편집 금지. 반드시 MCP 툴 또는 script-execute 사용.
2. 개별 MCP 툴 3회 이상 반복 시 script-execute로 전환.
3. 씬 영구 수정은 SerializedObject + ApplyModifiedProperties + SetDirty. 리플렉션 SetValue는 리컴파일 시 날아감.
4. 플레이모드에서 씬 저장 불가. editor-application-set-state로 에디트 모드 전환 후 scene-save.
5. 수정 후 EditorSceneManager.MarkSceneDirty 호출.

## script-execute

기본 템플릿:
```csharp
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;

public class Script
{
    public static object Main()
    {
        // 작업 코드
        EditorSceneManager.MarkSceneDirty(
            UnityEngine.SceneManagement.SceneManager.GetActiveScene());
        return "결과";
    }
}
```

SerializedObject 와이어링:
```csharp
var so = new SerializedObject(component);
so.FindProperty("_fieldName").objectReferenceValue = target;
so.ApplyModifiedProperties();
EditorUtility.SetDirty(component);
```

비활성 오브젝트 탐색: `Resources.FindObjectsOfTypeAll<T>()` 사용 (씬 유효성 체크 필수: `t.gameObject.scene.IsValid()`).

## 스크린샷 검증

- ScreenCapture.CaptureScreenshot() 사용 (script-execute 내에서 호출).
- 반드시 플레이모드에서만 작동. 에디트 모드에서는 캡처 안 됨.
- 상대 경로만 사용 ("screenshot.png" → 프로젝트 루트에 저장). 절대 경로는 Unity Editor가 무시함.
- 첫 프레임(Time.time < 1)에는 파일이 안 써질 수 있음. 한 프레임 이상 경과 후 캡처.
- 캡처 후 Read 툴로 PNG 확인 → 작업 완료 후 스크린샷 파일 삭제.
- screenshot-game-view MCP 도구는 Y축 반전 이슈 있음. ScreenCapture API 우선 사용.

## 에러 확인

- 코드 수정 후 assets-refresh로 컴파일 확인. 응답에 에러 포함됨.
- Warning도 무시하지 말 것.
- 상세 로그 필요 시 console-get-logs 호출.
- 에디터 로그 위치:
  - macOS: `~/Library/Logs/Unity/Editor.log` (현재), `Editor-prev.log` (이전)
  - Windows: `%LOCALAPPDATA%\Unity\Editor\Editor.log` (현재), `Editor-prev.log` (이전)

## 도구 우선순위

작업의 80%는 이 3개로 끝남:
1. script-execute — 일괄 조회, 수정, 와이어링
2. assets-refresh — 컴파일 확인
3. scene-save — 씬 저장

assets-modify로 ScriptableObject 수정 시 주의: 명시하지 않은 필드가 기본값(0)으로 리셋됨. SO는 YAML 직접 수정 + assets-refresh 조합을 사용할 것.

복잡한 UGUI 씬 작업을 에이전트에게 위임하지 말 것 — LayoutElement 비율이 깨질 수 있음. 직접 수행.
