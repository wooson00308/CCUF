---
name: scene-inspector
description: "Unity MCP로 씬 상태를 빠르게 파악하는 진단 스킬. 하이라키 덤프, 컴포넌트 감사, 색상 감사, 레이아웃 검증."
user-invocable: true
---

# Scene Inspector

script-execute로 씬 상태를 한 번에 파악하는 진단 패턴 모음.

## 하이라키 덤프

```csharp
using UnityEngine;
using UnityEngine.SceneManagement;
using System.Text;

public class Script
{
    public static string Main()
    {
        var sb = new StringBuilder();
        var scene = SceneManager.GetActiveScene();
        foreach (var root in scene.GetRootGameObjects())
            Print(root.transform, 0, sb);
        return sb.ToString();
    }

    static void Print(Transform t, int depth, StringBuilder sb)
    {
        sb.AppendLine(new string(' ', depth * 2) + t.name
            + (t.gameObject.activeSelf ? "" : " [OFF]"));
        for (int i = 0; i < t.childCount; i++)
            Print(t.GetChild(i), depth + 1, sb);
    }
}
```

## UI 색상 감사

Image.color, TextMeshProUGUI.color, Button.colors를 한 번에 뽑아서
다크 UI 체계(L1/L2/L3)와 비교.

## 레이아웃 검증

LayoutGroup 자식들의 rect.width x rect.height, LayoutElement 값,
flexibleHeight=-1 인 항목 찾기.

## 런타임 색상 덮어쓰기 탐지

`\.color\s*=` 패턴으로 코드 grep → 씬 수정이 런타임에 무효화되는 경우 사전 감지.
씬 색상 변경 전 반드시 확인.
