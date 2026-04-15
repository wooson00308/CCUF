# CCUF — Claude Code Unity Framework

Unity MCP 기반 실전 가드레일 + 스킬 프레임워크.

이론이 아니라 실제 프로젝트에서 삽질하면서 만든 것들만 들어있다.

## 전제 조건

- [Unity MCP](https://github.com/IvanMurzak/Unity-MCP) — Unity 에디터를 Claude Code에서 직접 조작하기 위한 MCP 서버. 이 프레임워크의 모든 스킬이 이걸 전제로 동작함. 설치 방법은 해당 레포 참조.
- [Claude Code](https://claude.ai/claude-code)
- DOTween (선택 — dotween-patterns 스킬 사용 시)

## 설치

`.claude/` 폴더를 프로젝트 루트에 복사.

```
your-project/
├── .claude/
│   ├── skills/         # 실전 검증 스킬
│   ├── hooks/          # 자동 가드레일
│   ├── rules/          # 도메인별 코딩 규칙
│   ├── docs/           # 패턴 레퍼런스
│   └── settings.json   # 권한 + 훅 설정
├── Assets/
└── ...
```

## 철학

- CCGS가 47명의 가상 스튜디오를 만든다면, 이건 1명이 MCP로 직접 씬을 만지는 워크플로우
- "이렇게 해라" 대신 "이렇게 하면 터진다"
- 스킬은 실전에서 검증된 것만. 쓰지 않을 스킬은 넣지 않는다
