#!/usr/bin/env bash
set -euo pipefail

echo -e "\
\e[44minstall.sh - Config Installer by baer1\e[0m
\e[44mhttps://github.com/baerchen201/configs\e[0m\e[3
1;104mTHIS SCRIPT COMES WITH ABSOLUTELY NO WARRANTY\e[0m"

confirm() {
  while :; do
    if [ -z "$1" ]; then
      read -p "[y/n] " -n 1
    else
      read -p "$1 [y/n] " -n 1
    fi
    echo
    if [ "$REPLY" = "n" ] || [ "$REPLY" = "N" ]; then
      return 1
    elif [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
      return 0
    fi
  done
}

cd "$(dirname $0)"
echo -e "\e[93mWARNING: This script will modify
 > the .bashrc and .bash_profile scripts
 > .local folder structure (bin and lib)
  >> .local/bin/bmenu.sh
  >> .local/lib/rofi-bmenu
 > .config files for the following apps:
$(ls .config | sed 's/^/  >> /')

Please ensure you have your current scripts and config files backed up, as they will be permanently overwritten.\e[0m"

if ! confirm "Continue?"; then
  echo -e "\e[44m == INSTALLATION CANCELLED == \e[0m"
  exit 1
fi

installs=

# == BASH SCRIPTS ==
if confirm "Do you want to install the bash scripts (.bashrc/.bash_profile)?"; then
  let installs++ || true
  echo -e "\e[94mInstalling bash scripts...\e[0m"
  mkdir -vp ~
  for f in `ls .bash*`; do
    ln -vsf "$(realpath "$f")" ~
  done

  _o=`cp -v --update=none .tty_autolaunch ~`
  echo "$_o"
  if [ -z "$_o" ]; then
    echo -e "\e[90mSkipping example tty autolaunch file ($HOME/.tty_autolaunch exists)\e[0m"
  else
    echo -e "\e[95mExample tty autolaunch file created at $HOME/.tty_autolaunch\e[0m"
  fi
fi

# == CONFIG FILES ==
if confirm "Do you want to install the graphical .config files?"; then
  let installs++ || true
  echo -e "\e[94mInstalling graphical .config files...\e[0m"
  mkdir -vp ~/.config
  for d in `ls .gconfig`; do
    # Scary
    rm -vrf "$HOME/.config/$d"
    ln -vs "$(realpath ".gconfig/$d")" ~/.config
  done
fi
if confirm "Do you want to install the terminal .config files?"; then
  let installs++ || true
  echo -e "\e[94mInstalling terminal .config files...\e[0m"
  mkdir -vp ~/.config
  for d in `ls .tconfig`; do
    # Scary
    rm -vrf "$HOME/.config/$d"
    ln -vs "$(realpath ".tconfig/$d")" ~/.config
  done
fi


# == MANUALLY INSTALLED FILES ==
if confirm "Do you want to install rofi-bmenu?"; then
  let installs++ || true
  echo -e "\e[94mCompiling rofi-bmenu...\e[0m"
  # compile rofi-bmenu
  (
    set -euo pipefail
    cd .local/lib/rofi-bmenu
    make
    echo -e "\e[92mCompilation finished\e[0m"
    )

  # ~/.bmenu
  _o=`cp -v --update=none .local/lib/rofi-bmenu/example.txt ~/.bmenu`
  echo "$_o"
  if [ -z "$_o" ]; then
    echo -e "\e[90mSkipping example bmenu file ($HOME/.bmenu exists)\e[0m"
  else
    echo -e "\e[95mExample bmenu file created at $HOME/.bmenu\e[0m"
  fi

  # .local/bin
  echo -e "\e[94mInstalling .local/bin/bmenu.sh...\e[0m"
  mkdir -vp ~/.local/bin
  ln -vsf "$(realpath .local/bin/bmenu.sh)" ~/.local/bin
  chmod -v +x ~/.local/bin/bmenu.sh

  # .local/lib
  echo -e "\e[94mInstalling .local/lib/rofi-bmenu...\e[0m"
  mkdir -vp ~/.local/lib
  rm -vrf ~/.local/lib/rofi-bmenu
  ln -vs "$(realpath .local/lib/rofi-bmenu)" ~/.local/lib
fi

if let installs; then
  echo -e "\e[44m == INSTALLATION FINISHED == \e[0m"
else
  echo -e "\e[44m == NOTHING INSTALLED == \e[0m"
fi


