#!/bin/bash
# PreToolUse: Edit|Write 전에 .unity 파일 직접 편집 차단
# 씬 조작은 Unity MCP 또는 script-execute를 통해서만.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if echo "$FILE_PATH" | grep -q '\.unity$'; then
  echo "BLOCK: .unity 씬 파일 직접 편집 금지. Unity MCP 툴(gameobject-find, script-execute 등)을 사용할 것." >&2
  exit 2
fi

exit 0
