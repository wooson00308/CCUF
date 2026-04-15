---
name: dark-ui-design
description: "다크 UI 디자인 원칙. 레이어링, 색상 체계, 버튼 티어, 간격 시스템. UI 작업 전 자가 검증 또는 디자인 문제 진단 시 사용."
user-invocable: true
---

# Dark UI Design System

## Color Layering

| Layer | 용도 | RGB | Alpha |
|-------|------|-----|-------|
| L0 | 최하위 배경 | 환경아트 또는 (0.06, 0.07, 0.09) | — |
| L1 | 패널/사이드바 | (0.09, 0.10, 0.13) | 0.95 |
| L1-Header | 헤더/푸터 | (0.07, 0.08, 0.10) | 0.95 |
| L2 | 카드/버튼 | (0.12, 0.13, 0.16) | 1.0 |
| L3 | 호버/선택 | (0.16, 0.18, 0.22) | 1.0 |
| L4 | 팝업/오버레이 | (0.18, 0.20, 0.24) | 1.0 |

핵심: 각 레이어가 "한 단계 떠 보이는" 느낌. 반투명(20% alpha)은 쓰지 않는다 — 뒤가 비쳐서 레이어 분리가 안 됨.

## Accent Color

통일 시안: (0.35, 0.75, 0.85) / #59BFD9
- 전체 면적의 10-15% 이하
- 사용처: CTA, 선택 인디케이터, 중요 수치, 탭 인디케이터
- 금지: 배경, 대면적, 일반 텍스트

## Button 3-Tier System

### Standard (리스트 아이템, 네비게이션)
- Image.color = L2
- ColorBlock: normal=white, highlighted=(1.35,1.38,1.38), pressed=(0.70,0.72,0.75)

### CTA (SORTIE, CUSTOMIZE, EQUIP)
- Image.color = dark teal (0.12, 0.22, 0.28)
- Text color = accent cyan
- 하단 2px 시안 액센트 라인

### Ghost (BACK, RESET DATA)
- Image.color = L2 alpha 0.35
- Text color = white 50%

## Text Hierarchy

| 역할 | Alpha/Color | 예시 |
|------|-------------|------|
| 주요 (제목, 이름) | 87-95% white | 파일럿 이름, 스탯 수치 |
| 보조 (레이블) | 45-50% white | 카테고리, 힌트 |
| 비활성 | 30-35% white | disabled, tertiary |
| 라벨 (섹션 제목) | 30% white + tracking 4 | "MENU", "SORTIE AC" |

## 8px Grid

모든 간격은 8의 배수: 8, 16, 24, 32, 40, 48, 64
- 내부 패딩 < 외부 간격 (게슈탈트 근접성)
- 7, 13, 19 같은 임의 수치 금지

## Quick Diagnostic (CRAP)

1. Contrast — 확실히 구분되는가?
2. Repetition — 같은 역할 = 같은 시각 언어?
3. Alignment — 보이지 않는 그리드 위에?
4. Proximity — 관련 요소 가깝고, 무관한 요소 떨어져 있는가?

## 흔한 실수

- 스프라이트에 color 틴트 → 원색 파괴. color=white 유지하거나 전용 스프라이트 사용.
- 테두리 두께 비례 안 맞음 → 400px 카드에 25px border는 과함. 1-2px이 적절.
- 코드에서 런타임 색상 덮어쓰기 → 씬에서 바꿔봐야 소용없음. 코드 확인 필수.
