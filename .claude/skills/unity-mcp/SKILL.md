---
name: unity-mcp
description: "Unity MCP를 통한 에디터 직접 조작 모드. 씬 탐색, 오브젝트 수정, 컴파일 확인, 스크린샷 검증까지. 코드 편집이 아닌 에디터 상호작용이 필요할 때 사용."
user-invocable: true
---

# Unity MCP 작업 모드

## 도구 선택 기준

| 작업 | 도구 | 이유 |
|------|------|------|
| 하이라키 탐색 | script-execute | 재귀 순회를 한 번에 |
| 오브젝트 검색 (조건부) | script-execute | FindObjectsOfType + 필터링 |
| 단일 오브젝트 수정 | MCP 개별 툴 | 한 번이면 충분 |
| 복수 오브젝트 일괄 처리 | script-execute | 반복 호출 방지 |
| 컴파일 체크 | assets-refresh | 응답에 에러 포함 |
| 씬 와이어링 | script-execute + SerializedObject | 영구 반영 |

## 핵심 규칙

1. 씬 파일(.unity) 직접 읽기/편집 금지. 반드시 MCP 툴 사용.
2. 개별 MCP 툴 3회 이상 반복 시 script-execute로 전환.
3. 씬 수정은 SerializedObject + ApplyModifiedProperties + SetDirty. 리플렉션 SetValue는 런타임에만 유효.
4. 플레이모드에서 씬 저장 불가. 반드시 에디트 모드에서 scene-save.

## script-execute 템플릿

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

## SerializedObject 와이어링 패턴

```csharp
var so = new SerializedObject(component);
so.FindProperty("_fieldName").objectReferenceValue = target;
so.ApplyModifiedProperties();
EditorUtility.SetDirty(component);
```

## 스크린샷 검증 루프

1. 플레이모드 진입 → ScreenCapture.CaptureScreenshot("파일명.png") (상대경로, 프로젝트 루트에 저장)
2. Read 툴로 PNG 파일 확인
3. 플레이모드 종료 → 스크린샷 파일 삭제

주의: ScreenCapture는 플레이모드에서만 작동. 첫 프레임(Time.time < 1)에는 파일이 안 써질 수 있음.
