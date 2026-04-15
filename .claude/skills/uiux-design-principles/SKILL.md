---
name: uiux-design-principles
description: UI/UX 디자인 원칙 기반 판단 스킬. UI 요소 배치, 색상, 간격, 위계 결정 시 원칙에 근거한 판단을 내리고, 디자인 문제를 진단할 때 사용. "이거 왜 이상해", "UI 봐줘", "디자인 평가", "레이아웃 검토" 등의 요청이나, UGUI 작업 전 자가 검증 시 트리거.
---

# UI/UX Design Principles

UI/UX 디자인 판단에 원칙 기반 근거를 제공하는 레퍼런스 스킬.

## When to Use

- UI 요소를 배치/수정하기 전에 자가 검증
- 디자인 결과물이 "왜 이상한지" 진단할 때
- 색상, 간격, 위계, 대비 판단이 필요할 때
- 서드파티 에셋을 적용하기 전에 적합성 판단할 때

## Quick Diagnostic Checklist

UI 작업 전후로 아래 항목을 점검한다.

1. Contrast — 요소 간 차이가 "확실히" 구분되는가? 애매한 차이는 실수로 보임.
2. Repetition — 같은 역할의 요소가 같은 시각 언어(색, 크기, 형태)를 쓰는가?
3. Alignment — 모든 요소가 보이지 않는 그리드 선 위에 있는가?
4. Proximity — 관련 요소는 가깝고, 무관한 요소는 떨어져 있는가? 내부 간격 < 외부 간격인가?
5. Hierarchy — 가장 중요한 요소가 가장 눈에 띄는가? (크기, 대비, 위치)
6. Proportion — 테두리, 패딩, 마진이 요소 크기에 비례하는가? 과하거나 부족하지 않은가?

## Detailed References

상세 원칙은 `references/` 디렉토리에서 참조한다.

- `references/foundations.md` — CRAP 원칙, 게슈탈트, 시각적 위계, 시선 흐름 패턴
- `references/spacing-and-grid.md` — 8px 그리드, 내부/외부 간격 규칙, 컴포넌트별 권장 간격
- `references/color-and-dark-ui.md` — 색상 이론, 대비 비율, 다크 UI 레이어링, 채도 관리
- `references/common-mistakes.md` — 실전에서 자주 발생하는 실수 패턴과 교정 방법

필요한 영역의 레퍼런스를 읽은 후 판단에 적용한다.
