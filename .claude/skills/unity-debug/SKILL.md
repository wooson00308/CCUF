---
name: unity-debug
description: Unity Editor 로그에서 컴파일 에러, 런타임 에러, 경고를 확인합니다. 유니티 에러 확인, 컴파일 체크, 빌드 에러 등을 요청할 때 사용합니다.
---

# Unity Debug Log Checker

Unity Editor 로그 파일에서 에러를 확인하는 스킬.

## 로그 파일 위치 (macOS)

- 현재 세션: `~/Library/Logs/Unity/Editor.log`
- 이전 세션: `~/Library/Logs/Unity/Editor-prev.log`

둘 다 확인해야 하며, 수정 시간이 더 최근인 파일을 우선 확인한다.

## 확인 순서

### 1. 컴파일 에러 (C# Compiler Errors)

```bash
grep -n "error CS" ~/Library/Logs/Unity/Editor.log | tail -30
grep -n "error CS" ~/Library/Logs/Unity/Editor-prev.log | tail -30
```

- `error CS1061`: 멤버 없음 (프로퍼티/메서드 제거 후 참조 누락)
- `error CS0246`: 타입/네임스페이스 없음 (using 누락)
- `error CS0103`: 이름 없음 (변수/메서드명 오타 또는 누락)
- `error CS0019`: 연산자 적용 불가

### 2. 런타임 에러 (NullRef, InvalidOperation 등)

```bash
grep -n "NullReferenceException\|InvalidOperationException\|ArgumentException\|MissingReferenceException" ~/Library/Logs/Unity/Editor.log | tail -20
```

스택 트레이스가 필요하면 에러 줄 번호 기준으로 앞뒤 10줄 읽기:
```bash
sed -n '{LINE_NUM-2},{LINE_NUM+10}p' ~/Library/Logs/Unity/Editor.log
```

### 3. 경고 (Warnings)

```bash
grep -n "warning CS" ~/Library/Logs/Unity/Editor.log | tail -20
```

## 분석 방법

1. 에러를 파일별로 그룹핑
2. 근본 원인 식별 (하나의 원인이 연쇄 에러를 유발하는 경우가 많음)
3. ServiceLocator 관련 에러는 초기화 순서(Awake → Start) 타이밍 이슈일 가능성 높음
4. 에러가 반복되면 deduplicate해서 유니크한 에러만 보고

## 보고 형식

에러 수와 요약을 먼저 말하고, 파일/줄번호/에러 내용을 테이블로 정리.
근본 원인이 보이면 수정 방향까지 같이 제시.
