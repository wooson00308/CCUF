#!/bin/bash
# SessionStart: Unity MCP 연결 상태 확인
# 연결 안 되면 경고만 (차단은 안 함 — SessionStart는 exit 2 무시)

if ! command -v unity-mcp-cli &> /dev/null; then
  echo "[CCUF] unity-mcp-cli가 설치되지 않음. npm install -g unity-mcp-cli 실행 필요." >&2
  exit 1
fi

RESULT=$(unity-mcp-cli status 2>&1)

if echo "$RESULT" | grep -q "ready for tool calls"; then
  echo "[CCUF] Unity MCP 연결 확인됨."
else
  echo "[CCUF] Unity MCP 연결 실패 — Unity Editor가 실행 중인지, MCP 서버가 켜져 있는지 확인." >&2
  echo "$RESULT" >&2
  exit 1
fi

exit 0
