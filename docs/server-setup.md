# Server Setup Guide

Complete guide for setting up a remote development server with Claude Code and zmx session persistence.

## Overview

This setup provides:
- **zmx** - Terminal multiplexer for persistent sessions
- **Claude Code** - AI-powered CLI assistant
- **Custom prompt** - Shows zmx session, git branch, and status
- **SSH integration** - Automatic session attachment on connect

## Server Setup (Remote)

### Prerequisites

```bash
sudo apt update && sudo apt install -y git jq curl build-essential
```

### Node.js via nvm

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

# Reload shell
source ~/.bashrc

# Install Node.js 24
nvm install 24
```

### Claude Code

```bash
npm i -g @anthropic-ai/claude-code
```

Set your API key:
```bash
echo 'export ANTHROPIC_API_KEY="your-key-here"' >> ~/.bashrc
source ~/.bashrc
```

### zmx (Session Persistence)

zmx is a lightweight terminal multiplexer written in Zig. It provides persistent sessions that survive SSH disconnects.

**Automated installation:**
```bash
./scripts/install-zmx.sh
```

**Manual installation:**
```bash
# Download Zig
ZIG_VERSION="0.15.2"
curl -sL "https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz" | tar xJ
export ZIG="$PWD/zig-linux-x86_64-${ZIG_VERSION}/zig"

# Clone and build zmx
git clone https://github.com/neurosnap/zmx
cd zmx
$ZIG build -Doptimize=ReleaseSafe --prefix ~/.local

# Install globally
sudo cp ~/.local/bin/zmx /usr/local/bin/
```

## Shell Configuration (Remote)

### Custom Prompt

The prompt shows:
- **[session-name]** - zmx session (magenta)
- **user@host** - standard info (green)
- **path** - relative to ~/projects (blue)
- **branch** - git branch (red)
- **↑n↓m** - commits ahead/behind upstream (cyan)
- **Nm Nu** - modified and untracked files (yellow/gray)

Install:
```bash
cp server/.bashrc.prompt ~/.bashrc.prompt
echo 'source ~/.bashrc.prompt' >> ~/.bashrc
source ~/.bashrc
```

### PATH Setup

Add to `~/.bashrc`:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Claude Configuration (Remote)

### Settings

Copy the settings template:
```bash
mkdir -p ~/.claude
cp server/.claude/settings.json ~/.claude/settings.json
cp server/.claude/statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

### Statusline

The statusline shows the zmx session and git info in Claude's interface:
- `[session-name]` - Current zmx session
- `branch Nm Ns` - Git branch with modified/staged counts

## Local Machine Setup (macOS)

### SSH Config

Add to `~/.ssh/config`:
```
# Create sockets directory first: mkdir -p ~/.ssh/sockets

Host server-*
    HostName your-server.example.com
    User your-username
    IdentityFile ~/.ssh/id_ed25519
    RequestTTY yes
    RemoteCommand zmx attach %n
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 10m

Host server
    HostName your-server.example.com
    User your-username
    IdentityFile ~/.ssh/id_ed25519
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 10m
```

Key options:
- `RemoteCommand zmx attach %n` - Automatically attaches to zmx session named after the host pattern
- `ControlMaster auto` - Multiplexes connections over single TCP socket
- `ControlPersist 10m` - Keeps connection alive for 10 minutes after last session

### autossh

autossh monitors SSH connections and automatically reconnects on failure:

```bash
brew install autossh
```

Add to `~/.zshrc`:
```bash
alias ash="autossh -M 0 -o 'ServerAliveInterval 10' -o 'ServerAliveCountMax 3'"
```

### Ghostty Terminfo

If using Ghostty terminal, send terminfo to the server:
```bash
infocmp -x xterm-ghostty | ssh server 'tic -x -'
```

## Usage

### Basic Workflow

```bash
# Connect to a project (creates or attaches to zmx session)
ssh server-myproject

# Work in the session...
cd ~/projects/myproject
claude

# Detach from session (keeps it running)
# Press Ctrl+\

# Reattach later
ssh server-myproject
# Everything is exactly as you left it
```

### With Auto-Reconnect

```bash
# Use autossh for persistent connections
ash server-myproject

# If connection drops, autossh automatically reconnects
# and reattaches to the same zmx session
```

### zmx Commands

Inside a zmx session:
- `Ctrl+\` - Detach from session
- `zmx list` - List all sessions
- `zmx attach <name>` - Attach to a session
- `zmx kill <name>` - Kill a session

## Troubleshooting

### SSH connection refused after reboot

Check if sshd is running:
```bash
sudo systemctl status sshd
```

### zmx session not found

List existing sessions:
```bash
zmx list
```

Create a new session manually:
```bash
zmx new myproject
```

### Terminal colors not working

Ensure terminfo is installed:
```bash
# On local machine
infocmp -x $TERM | ssh server 'tic -x -'
```

### Claude Code statusline not showing

Verify the statusline script is executable:
```bash
chmod +x ~/.claude/statusline.sh
~/.claude/statusline.sh  # Test it
```
