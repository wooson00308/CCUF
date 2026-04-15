---
name: dotween-patterns
description: "DOTween 연출 패턴 — LayoutGroup 안전한 애니메이션, 뷰 전환, 팝업 연출. DOTween 사용 시 참조."
user-invocable: true
---

# DOTween Patterns for Unity UI

## LayoutGroup-Safe 애니메이션

LayoutGroup 자식의 anchoredPosition을 DOTween으로 건드리면 레이아웃이 깨진다.
안전한 방법만 사용할 것.

### 안전한 방법
- CanvasGroup.alpha 페이드 — LayoutGroup 영향 없음
- Transform.localScale — 위치 안 바뀜
- LayoutGroup 밖 루트의 anchoredPosition — 내부 레이아웃 무관

### 위험한 방법 (금지)
- LayoutGroup 자식의 DOAnchorPos — 레이아웃 충돌
- LayoutGroup 자식에 CanvasGroup 동적 추가 — 레이아웃 재계산 유발 가능

## View Transition (LobbyViewAnimator 패턴)

```csharp
// Group 루트(LayoutGroup 밖)에서 슬라이드+페이드
// OnEnable → 애니메이션, OnDisable → 즉시 복원
void PlayIntro()
{
    _rootRT.anchoredPosition = new Vector2(40f, 0f);
    _rootCG.alpha = 0f;
    
    var seq = DOTween.Sequence();
    seq.Append(_rootRT.DOAnchorPos(Vector2.zero, 0.4f).SetEase(Ease.OutCubic));
    seq.Join(_rootCG.DOFade(1f, 0.24f).SetEase(Ease.OutQuad));
}
```

핵심: Group 루트는 stretch 앵커 + (0,0) 기본 위치라 LayoutGroup 영향 밖.

## Popup Animation (PopupAnimator 패턴)

```csharp
// MissionResultPopup에서 검증된 패턴
_rt.localScale = Vector3.one * 0.92f;
_cg.alpha = 0f;

var seq = DOTween.Sequence();
seq.Append(_rt.DOScale(1f, 0.25f).SetEase(Ease.OutBack, 1.1f));
seq.Join(_cg.DOFade(1f, 0.2f));
seq.SetUpdate(true); // TimeScale 무관
```

## Stagger Pattern (리스트 아이템)

```csharp
for (int i = 0; i < items.Length; i++)
{
    float delay = 0.05f + i * 0.06f;
    seq.Insert(delay, items[i].DOFade(1f, 0.3f));
}
```

## Outline + CanvasGroup.alpha 충돌

DOTween으로 CanvasGroup.alpha를 fade할 때 Outline 컴포넌트가 회색 잔상.
fade 전에 끄고 완료 후 복원:
```csharp
var outlines = panel.GetComponentsInChildren<Outline>(true);
foreach (var o in outlines) o.enabled = false;
seq.OnComplete(() => {
    foreach (var o in outlines) if (o != null) o.enabled = true;
});
```
