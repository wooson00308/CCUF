---
paths: ["**/UI/**/*.cs", "**/Lobby/**/*.cs"]
---

# UGUI Code Rules

1. LayoutGroup 자식 크기는 LayoutElement로만 제어. sizeDelta 금지.
2. flexibleWidth/Height는 반드시 명시 (기본 -1은 예측 불가).
3. Button ColorBlock normalColor = white. 코드에서 Image.color 제어 시 필수.
4. 색상 상수는 static readonly Color로. 매직 넘버 금지.
5. 런타임 색상 설정 시 주석으로 "L2", "L3", "accent" 등 레이어 명시.
