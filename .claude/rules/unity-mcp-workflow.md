# Unity MCP Workflow Rules

Unity MCP 연동 작업 시 항상 적용되는 규칙.

## 씬 조작

1. .unity 파일 직접 읽기/편집 금지. 반드시 MCP 툴 또는 script-execute 사용.
2. 개별 MCP 툴 3회 이상 반복 시 script-execute로 전환.
3. 씬 영구 수정은 SerializedObject + ApplyModifiedProperties + SetDirty. 리플렉션 SetValue는 리컴파일 시 날아감.
4. 플레이모드에서 씬 저장 불가. editor-application-set-state로 에디트 모드 전환 후 scene-save.
5. 수정 후 EditorSceneManager.MarkSceneDirty 호출.

## script-execute

만능 도구. 작업의 80%가 이걸로 끝남. 기본 규칙: 개별 MCP 툴 3회 이상 반복할 상황이면 script-execute 하나로 합칠 것.

### 기본 구조 (절대 바꾸지 말 것)

```csharp
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;

public class Script
{
    public static object Main()
    {
        // 반드시 class + static method. top-level statements 불가.
        EditorSceneManager.MarkSceneDirty(
            UnityEngine.SceneManagement.SceneManager.GetActiveScene());
        return "결과";  // 반환값이 MCP 응답으로 전달됨
    }
}
```

### 결과는 StringBuilder로 구조화

MCP 왕복 횟수를 줄이는 것이 핵심. 한 번 호출에 최대한 많은 정보를 담아서 반환.

```csharp
var sb = new StringBuilder();
sb.AppendLine($"{name}: rect={rt.rect.width:F0}x{rt.rect.height:F0}");
sb.AppendLine($"  img={img.color}");
return sb.ToString();
```

### 비활성 오브젝트 탐색

`GameObject.Find()`는 활성 오브젝트만 찾음. 비활성 포함:

```csharp
var allT = Resources.FindObjectsOfTypeAll<Transform>();
foreach (var t in allT)
{
    if (!t.gameObject.scene.IsValid()) continue;  // 프리팹 에셋 제외 필수
    // ...
}
```

`scene.IsValid()` 없으면 프로젝트 에셋까지 전부 잡혀서 결과가 오염됨.

### 수정 시 3종 세트

```csharp
EditorUtility.SetDirty(target);               // 변경 추적
EditorSceneManager.MarkSceneDirty(scene);      // 씬 dirty 표시
// 이후 별도 scene-save 호출로 영구 저장
```

### SerializedObject 와이어링 (영구 반영)

```csharp
var so = new SerializedObject(component);
so.FindProperty("_fieldName").objectReferenceValue = target;
so.ApplyModifiedProperties();
EditorUtility.SetDirty(component);
```

리플렉션 SetValue는 런타임에만 유효. 리컴파일 시 날아감.

### try-catch는 선택적으로

Unity 6에서 null sprite 접근 등 불확실한 프로퍼티 접근 시:

```csharp
try { var name = sprite.name; }
catch { /* skip */ }
```

### 여러 작업은 반드시 하나로 묶기

```csharp
// BAD: gameobject-find 3번 + gameobject-component-modify 3번 = 왕복 6회
// GOOD: script-execute 1번에 전부 처리
var allBtns = Resources.FindObjectsOfTypeAll<Button>();
foreach (var btn in allBtns)
{
    if (!btn.gameObject.scene.IsValid()) continue;
    var img = btn.GetComponent<Image>();
    img.color = newColor;
    EditorUtility.SetDirty(img);
}
```

### CLI에서 복잡한 입력 전달

코드에 큰따옴표나 줄바꿈이 많으면 stdin 사용:

```bash
unity-mcp-cli run-tool script-execute --input-file - <<'OUTER'
{"csharpCode": "using UnityEngine;\n\npublic class Script\n{\n    public static object Main()\n    {\n        return \"hello\";\n    }\n}"}
OUTER
```

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
