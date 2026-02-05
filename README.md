# Developer Server Dotfiles

Configuration files and setup scripts for a remote development server with Claude Code and zmx session persistence.

## Quick Start

### On the Server

```bash
# 1. Install prerequisites
sudo apt update && sudo apt install -y git jq curl build-essential

# 2. Install Node.js via nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
source ~/.bashrc
nvm install 24

# 3. Install Claude Code
npm i -g @anthropic-ai/claude-code

# 4. Clone and install dotfiles
git clone https://github.com/krasnoperov/dotfiles.git
cd dotfiles
./server/install.sh

# 5. Install zmx
./scripts/install-zmx.sh

# 6. Set your API key
echo 'export ANTHROPIC_API_KEY="your-key-here"' >> ~/.bashrc
source ~/.bashrc
```

### On Your Local Machine (macOS)

```bash
# 1. Create SSH sockets directory
mkdir -p ~/.ssh/sockets

# 2. Add to ~/.ssh/config (edit local/ssh-config.example first)
cat local/ssh-config.example >> ~/.ssh/config

# 3. Install autossh
brew install autossh

# 4. Add alias to ~/.zshrc
cat local/zshrc-additions >> ~/.zshrc

# 5. Send Ghostty terminfo to server
infocmp -x xterm-ghostty | ssh server 'tic -x -'
```

## Usage

```bash
# Connect to a project session (creates or attaches)
ssh server-myproject

# Session persists across disconnects
# Ctrl+\ to detach, ssh server-myproject to reattach

# With auto-reconnect
ash server-myproject
```

## What's Included

- **server/.bashrc.prompt** - PS1 with zmx session name and git status
- **server/.claude/** - Claude Code settings and statusline
- **scripts/install-zmx.sh** - Automated zmx installation
- **local/** - SSH config and shell aliases for macOS

## Documentation

See [docs/server-setup.md](docs/server-setup.md) for detailed setup instructions.
