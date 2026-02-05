#!/bin/bash
# Claude Code statusline script
# Shows zmx session name and git branch/status

output=""

# zmx session
if [ -n "$ZMX_SESSION" ]; then
  output="[${ZMX_SESSION}]"
fi

# git info (if in a git repo)
if git rev-parse --git-dir &>/dev/null; then
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    modified=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
    staged=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')

    git_status=""
    [ "$modified" != "0" ] && git_status="${modified}m"
    [ "$staged" != "0" ] && git_status="${git_status} ${staged}s"

    if [ -n "$output" ]; then
      output="$output "
    fi
    output="${output}${branch}"
    [ -n "$git_status" ] && output="${output} ${git_status}"
  fi
fi

echo "$output"
