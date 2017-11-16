### Use this script to set up the environment with the prerequisites to make changes or develop in the monocular repository

### Declare colors to use during the running of this script:
declare -r GREEN="\033[0;32m"
declare -r RED="\033[0;31m"
declare -r YELLOW="\033[0;33m"

function echo_green {
  echo -e "${GREEN}$1"; tput sgr0
}
function echo_red {
  echo -e "${RED}$1"; tput sgr0
}
function echo_yellow {
  echo -e "${YELLOW}$1"; tput sgr0
}

# Install prereqs
echo_green "\nPhase I: Installing system prerequisites:"
pkg="build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev"

for pkg in $pkg; do
    if sudo dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
        echo -e "$pkg is already installed"
    else
        sudo apt-get update && sudo apt-get -qq install $pkg
        echo "Successfully installed $pkg"
    fi
done

## Install node and npm
echo_green "\nPhase II: Install Node and NPM:"
# Install linuxbrew
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
# Add linuxbrew to PATH
test -d ~/.linuxbrew && PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
test -r ~/.bash_profile && echo 'export PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"' >>~/.bash_profile
echo 'export PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"' >>~/.profile

# Install node
brew install node
## Install angular and angular-cli
npm install -g angular
npm install -g @angular/cli

## Install Yarn
echo_green "\nPhase III: Install Yarn:"
# Check to make sure cmdtest is not installed and remove it if it is
if sudo dpkg --get-selections | grep -q "^cmdtest[[:space:]]*install$" >/dev/null; then
    echo -e "cmdtest installed, let's remove it..."
    apt-get remove --purge cmdtest
else
    sudo apt-get update && sudo apt-get -qq install $pkg
    echo "cmdtest is not installed. Good."
fi
# Update Source
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

pkg="yarn"
if sudo dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
    echo -e "$pkg is already installed"
else
    sudo apt-get update && sudo apt-get -qq install $pkg
    echo "Successfully installed $pkg"
fi

echo_green "\nCOMPLETE!\n"
