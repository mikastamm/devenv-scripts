echo "Installing nvm, node, npm and gulp-cli..."
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
bash
nvm install --lts
npm install --global gulp-cli
echo "Installed nvm, node, npm and gulp-cli"