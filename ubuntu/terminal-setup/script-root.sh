#!/bin/bash

set -e # Exit on error

echo "🛠️ Starting terminal environment setup..."

# 0. Install Git if not installed
if ! command -v git >/dev/null 2>&1; then
  echo "📦 Installing Git..."
  apt update
  apt install -y git
else
  echo "✅ Git already installed."
fi

# 1. Install Zsh if not installed
if ! command -v zsh >/dev/null 2>&1; then
  echo "📦 Installing Zsh..."
  apt install -y zsh
else
  echo "✅ Zsh already installed."
fi

# 2. Change default shell to Zsh
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "⚙️ Changing default shell to Zsh..."
  chsh -s "$(which zsh)"
fi

# 3. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "📥 Installing Oh My Zsh..."
  RUNZSH=yes CHSH=yes KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✅ Oh My Zsh already installed."
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# 4. Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "🔌 Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# 5. Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "🔌 Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# 6. Install Powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "🎨 Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# 7. Update ~/.zshrc
echo "⚙️ Updating ~/.zshrc..."

# Set theme
sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc

# Add plugins if not already present
if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
  sed -i 's/^plugins=(\(.*\))/plugins=(\1 zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
fi

# Add manual source lines for safety
if ! grep -q "zsh-syntax-highlighting.zsh" ~/.zshrc; then
  echo "source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>~/.zshrc
fi
if ! grep -q "zsh-autosuggestions.zsh" ~/.zshrc; then
  echo "source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >>~/.zshrc
fi

# 8. Font suggestion
echo
echo "🔤 IMPORTANT: Install 'MesloLGS NF' font for Powerlevel10k to look great."
echo "👉 Download here: https://github.com/romkatv/powerlevel10k#manual-font-installation"
echo "Then set your terminal font to 'MesloLGS NF'."

echo
echo "✅ Done! Run 'zsh' or restart your terminal to apply the changes."
