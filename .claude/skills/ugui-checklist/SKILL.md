---
name: ugui-checklist
description: "UGUI LayoutGroup 작업 시 매번 동일한 실수를 방지하는 체크리스트. LayoutGroup 수정, 레이아웃 깨짐 디버깅 시 참조."
user-invocable: true
---

# UGUI LayoutGroup 체크리스트

## 필수 규칙

### 1. childControlWidth/Height = true 명시
```csharp
vlg.childControlWidth = true;
vlg.childControlHeight = true;
```
Unity 2021+ 기본값이 false일 수 있으므로 항상 명시.

### 2. LayoutGroup 자식 크기는 LayoutElement로만
- sizeDelta 아무리 설정해도 LayoutGroup이 덮어씌움
- 고정 크기 → preferredWidth / preferredHeight
- 남은 공간 채우기 → flexibleWidth / flexibleHeight
- flexibleHeight=0 명시하지 않으면 기본값(-1) 적용 → 예측 불가

### 3. LayoutGroup 자식의 anchoredPosition 건드리지 말 것
- LayoutGroup이 위치를 관리하므로 DOTween 등으로 anchoredPosition 트윈하면 레이아웃 깨짐
- 슬라이드 애니메이션은 LayoutGroup 밖의 루트 오브젝트에서만

### 4. ContentSizeFitter는 center 앵커에서만
- stretch 앵커와 CSF 조합은 불안정
- 가능하면 고정 크기 선호

### 5. 수정 후 ForceRebuild
```csharp
Canvas.ForceUpdateCanvases();
LayoutRebuilder.ForceRebuildLayoutImmediate(rootRT);
```

### 6. 버튼 ColorBlock white 규칙
코드에서 Image.color를 제어할 때 Button ColorBlock의 normalColor가 white가 아니면 색상이 곱해져서 어두워짐.
```csharp
var cb = button.colors;
cb.normalColor = Color.white;
cb.highlightedColor = new Color(1.35f, 1.38f, 1.38f, 1f);
cb.pressedColor = new Color(0.70f, 0.72f, 0.75f, 1f);
button.colors = cb;
```

## 디버깅 루틴

레이아웃 깨졌을 때:
1. 모든 오브젝트의 rect.width x rect.height 덤프
2. preferredHeight vs 실제 rect.height 비교
3. flexibleHeight가 -1(기본)인 LE 찾기
4. childControlWidth/Height가 false인 LG 찾기
5. 코드에서 런타임 색상 덮어쓰기 여부 확인
