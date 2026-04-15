#!/bin/bash
# .unity 파일 직접 편집 차단
# 씬 조작은 반드시 Unity MCP 툴 또는 script-execute를 통해서만.

INPUT="$1"

if echo "$INPUT" | grep -q '\.unity"'; then
  echo "BLOCK: .unity 파일 직접 편집 금지. Unity MCP 툴(scene-get-data, gameobject-find 등)이나 script-execute를 사용할 것." >&2
  exit 1
fi

exit 0
