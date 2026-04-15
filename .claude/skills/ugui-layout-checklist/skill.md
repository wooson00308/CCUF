# UGUI LayoutGroup 체크리스트

script-execute로 UGUI 레이아웃을 구성하거나 수정할 때, 매번 동일한 실수를 방지하기 위한 체크리스트.
"UGUI 레이아웃", "레이아웃 깨짐", "LayoutGroup 수정" 등의 요청 시 이 스킬을 참고한다.

## 필수 규칙

### 1. LayoutGroup에는 반드시 childControlWidth/Height = true
```csharp
vlg.childControlWidth = true;
vlg.childControlHeight = true;
```
이걸 안 하면 LayoutGroup이 자식 크기를 제어하지 않아서, 자식의 LayoutElement 값이 무시된다. Unity 2021+ 기본값이 false일 수 있으므로 항상 명시적으로 설정.

### 2. LayoutGroup 자식의 크기는 LayoutElement로만 제어
- RectTransform의 sizeDelta를 아무리 설정해도 LayoutGroup이 덮어씌움
- 고정 크기 → `preferredWidth / preferredHeight`
- 남은 공간 채우기 → `flexibleWidth / flexibleHeight`
- flexibleHeight = 0을 명시하지 않으면 기본값(-1)이 적용되어 예측 불가

### 3. ContentSizeFitter는 center 앵커에서만 사용
- stretch 앵커 (anchorMin != anchorMax)와 CSF 조합은 동작이 불안정
- CSF 쓸 거면: anchorMin = anchorMax = (0.5, 0.5), 너비는 sizeDelta.x로 고정
- 자식 수가 가변적인 Content에만 제한적으로 사용 → 가능하면 고정 크기 선호

### 4. 새로운 GameObject 생성 시 앵커 초기값 주의
`new GameObject()`로 만든 오브젝트는 앵커가 (0,0)-(1,1) stretch로 잡힘.
LayoutGroup 자식으로 넣을 때는:
- VLG 자식: anchorMin=(0,1), anchorMax=(1,1), pivot=(0.5,1), sizeDelta=(0,0)
- HLG 자식: anchorMin=(0,0), anchorMax=(0,1), pivot=(0,0.5), sizeDelta=(0,0)
- 단, childControlWidth/Height=true면 LayoutGroup이 앵커를 덮어씌우므로 LE만 정확히 설정하면 됨

### 5. LayoutGroup 안에서 비율 바 구현
Image.Type.Filled의 fillAmount는 LayoutGroup 내부에서 시각적으로 안 먹히는 경우가 있음.
anchorMax.x 방식이 확실:
```csharp
// Image.Type = Simple, RectTransform으로 참조
_barFill.anchorMin = new Vector2(0, 0);
_barFill.anchorMax = new Vector2(ratio, 1);  // ratio = 0~1
_barFill.offsetMin = Vector2.zero;
_barFill.offsetMax = Vector2.zero;
```
- BarBackground에 LayoutElement로 높이 고정 (예: preferredHeight=6, flexibleHeight=0)
- BarFill은 BarBackground의 자식으로 stretch 앵커, LayoutElement 없이
- SerializeField 타입은 Image가 아니라 RectTransform으로

### 6. 중첩 LayoutGroup 주의
LayoutGroup 안에 LayoutGroup:
- 외부 LG가 내부 LG의 RectTransform을 제어
- 내부 LG는 자기 자식만 제어
- 내부 LG 오브젝트에도 LayoutElement로 크기 지정 필수
- 안 하면 0x0으로 찍힘

### 7. 와이어링은 SerializedObject로
```csharp
var so = new SerializedObject(component);
so.FindProperty("_fieldName").objectReferenceValue = target;
so.ApplyModifiedProperties();
EditorUtility.SetDirty(component);
```
리플렉션 SetValue는 리컴파일 시 날아감. 씬 영구 반영은 반드시 SerializedObject.

### 8. 수정 후 반드시 ForceRebuild
```csharp
Canvas.ForceUpdateCanvases();
LayoutRebuilder.ForceRebuildLayoutImmediate(rootRT);
```
안 하면 게임뷰에 반영 안 되어서 스크린샷이 이전 상태로 찍힘.

### 9. 버튼 테두리 구현
Unity Outline 컴포넌트는 그림자 효과지 보더가 아님. 깔끔한 1px 테두리:
- 자식 Border 오브젝트 아래에 Top/Bottom/Left/Right 4개 Image
- 각각 stretch 앵커로 한 변만 차지 (thickness = 1px)
- 버튼 배경은 투명~반투명

### 10. 스크린샷 Y축 반전
Unity MCP의 screenshot-game-view는 OpenGL 좌표계로 캡처되어 Y축 반전됨.
PIL로 보정:
```python
img = img.transpose(Image.FLIP_TOP_BOTTOM)
```

### 11. Outline + CanvasGroup.alpha 충돌
DOTween 등으로 CanvasGroup.alpha를 fade할 때 Outline 컴포넌트가 회색 잔상을 남김.
fade 전에 끄고 완료 후 복원:
```csharp
var outlines = panel.GetComponentsInChildren<Outline>(true);
foreach (var o in outlines) o.enabled = false;
// ... fade 연출 ...
seq.OnComplete(() => {
    foreach (var o in outlines) if (o != null) o.enabled = true;
});
```

## 디버깅 루틴
레이아웃이 깨졌을 때:
1. 모든 오브젝트의 `rect.width x rect.height` + `isTextOverflowing` 덤프
2. preferredHeight vs 실제 rect.height 비교
3. flexibleHeight가 -1(기본)인 LE 찾기
4. childControlWidth/Height가 false인 LG 찾기
