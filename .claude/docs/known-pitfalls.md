# Known Pitfalls — 실전 삽질 기록

Unity MCP + UGUI 작업에서 실제로 겪은 문제와 해결법.

## MCP 관련

| 함정 | 원인 | 해결 |
|------|------|------|
| ScreenCapture 절대경로 무시 | Unity Editor는 상대경로만 인식 | `"filename.png"` (프로젝트 루트 저장) |
| DOTween 도중 스크린샷 투명 | alpha=0 상태에서 캡처 | Time.time > 2 확인 후 캡처 |
| script-execute sprite.name null | Unity 6에서 null sprite 접근 | try-catch 감싸기 |
| assets-modify로 SO 수정 | 명시 안 한 필드가 0으로 리셋 | YAML 직접 수정 + assets-refresh |
| scene-save 플레이모드 실패 | 플레이모드에서 저장 불가 | editor-application-set-state로 종료 후 저장 |

## UGUI 관련

| 함정 | 원인 | 해결 |
|------|------|------|
| LayoutGroup 자식 크기 안 먹힘 | childControlWidth=false (기본) | 명시적 true 설정 |
| flexibleHeight 예측 불가 | 기본값 -1 | 항상 0 또는 원하는 값 명시 |
| 버튼 색상이 어둡게 나옴 | ColorBlock normalColor != white | normalColor = white로 통일 |
| 씬 색상 변경 후 런타임에 원복 | 코드에서 색상 덮어쓰기 | 코드의 static Color 상수 수정 |
| DOTween 슬라이드 + LayoutGroup 깨짐 | anchoredPosition이 LG와 충돌 | LG 밖 루트에서만 슬라이드 |
| Outline + CanvasGroup fade 잔상 | Outline이 alpha 변경에 반응 | fade 전 disable, 완료 후 enable |

## 디자인 관련

| 함정 | 원인 | 해결 |
|------|------|------|
| 패널이 환경에 묻힘 | 20% 반투명 배경 | solid L1 (0.09,0.10,0.13,0.95) |
| 모든 요소가 같은 무게 | 위계 없는 색상 체계 | L1/L2/L3 + 3-tier 버튼 |
| CTA가 안 보임 | 리스트 아이템과 같은 스타일 | dark teal + 시안 액센트 |
| 폰트 글리프 깨짐 (tofu) | 유니코드 문자 미지원 | 폰트가 가진 문자만 사용 |
| 스프라이트 color 틴트 재앙 | 어두운 스프라이트 + 밝은 color | color=white 유지, 전용 스프라이트 사용 |
