---
name: unity
description: Unity 에디터와 직접 상호작용하는 작업 모드. 씬 탐색, 오브젝트 조작, 컴파일 확인 등 에디터 레벨 작업을 MCP 툴과 CLI로 수행한다. "/unity", "유니티 봐줘", "씬 확인", "하이라키 봐줘" 등의 요청 시 트리거된다.
---

# Unity Editor 작업 모드

이 스킬이 트리거되면, 코드 파일 편집이 아닌 Unity 에디터와의 직접 상호작용 모드로 진입한다.
"유니티 봐줘"는 ".cs 스크립트 작성해줘"가 아니라 "에디터 상태를 확인하거나 조작해줘"를 의미한다.

## 사용 가능한 도구

### 1. MCP 툴 (직접 호출)
Unity MCP 서버가 제공하는 툴을 직접 호출한다. 단일 오브젝트 조작에 적합.
- `gameobject-find`, `gameobject-create`, `gameobject-modify` 등
- `scene-list-opened`, `scene-get-data` 등
- `assets-find`, `assets-refresh` 등
- `console-get-logs` (에러 확인)
- `screenshot-scene-view`, `screenshot-game-view` (시각적 확인)

### 2. script-execute (일괄 작업의 핵심)
Roslyn으로 C# 코드를 런타임 실행하는 원샷 도구. 반복/재귀/일괄 작업에 압도적으로 효율적.

필수 규칙:
- 반드시 class + static method 구조로 작성 (top-level statements 불가)
- Unity API 접근 가능 (UnityEngine, UnityEditor 네임스페이스)

```csharp
// 기본 템플릿
using UnityEngine;
using UnityEngine.SceneManagement;

public class Script
{
    public static object Main()
    {
        // 작업 코드
        return "결과";
    }
}
```

### 3. unity-mcp-cli (Bash를 통한 호출)
글로벌 설치된 CLI 도구. Bash에서 직접 호출할 때 사용.

```bash
unity-mcp-cli run-tool <tool-name> --input '{"key": "value"}'
# 복잡한 입력은 stdin으로:
unity-mcp-cli run-tool <tool-name> --input-file - <<'EOF'
{"csharpCode": "..."}
EOF
```

## 작업 패턴 (도구 선택 기준)

### 씬 하이라키 탐색
개별 gameobject-find를 반복하지 않는다. script-execute로 한 번에 뽑는다.
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
        sb.AppendLine(new string(' ', depth * 2) + t.name);
        for (int i = 0; i < t.childCount; i++)
            Print(t.GetChild(i), depth + 1, sb);
    }
}
```

### 컴포넌트 일괄 조회
특정 타입의 컴포넌트를 씬 전체에서 찾을 때도 script-execute.
```csharp
using UnityEngine;

public class Script
{
    public static string Main()
    {
        var all = Object.FindObjectsOfType<Canvas>();
        var sb = new System.Text.StringBuilder();
        foreach (var c in all)
            sb.AppendLine($"{c.name} (renderMode={c.renderMode})");
        return sb.ToString();
    }
}
```

### 코드 수정 후 컴파일 확인
1. 파일 편집 (Edit/Write 도구)
2. `assets-refresh` MCP 툴 호출 (또는 CLI: `unity-mcp-cli run-tool assets-refresh --input '{}'`)
3. 응답에서 컴파일 에러 확인 (Warning 포함 시 에러 상세 제공됨)
4. 필요시 `console-get-logs`로 추가 로그 확인

### 스크린샷 캡처 (Game View)
CLI로 찍으면 base64로 반환되므로, python으로 디코딩 후 Read로 확인하는 3단계 루틴.

1. CLI로 캡처:
```bash
unity-mcp-cli run-tool screenshot-game-view --input '{"nothing": ""}'
```

2. 출력에서 base64 이미지 추출 → PNG 저장:
```bash
python3 -c "
import json, base64
with open('<CLI 출력 파일 경로>', 'r') as f:
    text = f.read()
idx = text.find('{')
depth = 0
for i in range(idx, len(text)):
    if text[i] == '{': depth += 1
    elif text[i] == '}': depth -= 1
    if depth == 0:
        end = i + 1
        break
data = json.loads(text[idx:end])
for item in data['content']:
    if item.get('type') == 'image' and item.get('data'):
        img = base64.b64decode(item['data'])
        with open('/tmp/gmlm_gameview.png', 'wb') as f:
            f.write(img)
        break
"
```

3. Read 툴로 `/tmp/gmlm_gameview.png` 읽어서 시각적 확인.

Scene View는 `screenshot-scene-view` (width/height 지정 가능)로 동일 패턴. 단, Scene View 창이 열려있어야 함.

### 단일 오브젝트 조작
이름 변경, 컴포넌트 추가/제거, 프로퍼티 수정 등은 개별 MCP 툴 사용.
- `gameobject-find` → `gameobject-component-get` → `gameobject-component-modify`

## 도구 선택 의사결정

| 작업 유형 | 도구 | 이유 |
|-----------|------|------|
| 하이라키 탐색 | script-execute | 재귀 순회를 한 번에 |
| 오브젝트 검색 (조건부) | script-execute | FindObjectsOfType + 필터링 |
| 단일 오브젝트 수정 | MCP 개별 툴 | 한 번이면 충분 |
| 프리팹 편집 | MCP 개별 툴 | open → 수정 → save → close 흐름 |
| 컴파일 체크 | assets-refresh | 응답에 에러 포함 |
| 스크린샷 확인 | CLI + python + Read | base64 디코딩 후 이미지 파일로 확인 |
| 복수 오브젝트 일괄 처리 | script-execute | 반복 호출 방지 |

## 인증 정보
- 토큰 위치: `UserSettings/AI-Game-Developer-Config.json`
- CLI는 config에서 자동으로 토큰을 읽음
- curl 사용 시 `Authorization: Bearer <token>` 헤더 필요
