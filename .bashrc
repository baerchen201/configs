#
# ~/.bashrc
#

[ -f ~/.bashrc- ] && source ~/.bashrc-

# Check for interactive mode
if [[ $- == *i* ]]; then
  # Welcome message
  if ! (( $SHLVL > 1 )); then
    clear
    echo "Welcome, $USER!"
  fi

  # the rest of the welcome message is in english so the date should be too (but using a non-retarded format)
  LC_TIME=en_US.UTF-8 date "+%A %d. %B %Y - %H:%M"
  echo -en "bash $(if ! [ ${BASH_VERSINFO[4]} = "release" ];then echo "${BASH_VERSINFO[4]} ";fi )${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}\e[90m.${BASH_VERSINFO[2]}.${BASH_VERSINFO[3]}\e[0m"
  if (( $SHLVL > 1 )); then echo -e " - nested level $(( $SHLVL - 1 ))"; else echo ""; fi

  _print_exit_code () {
    _e=$?
    if let _COUNTER++; then if [ $_e != 0 ]; then
      echo -e "\e[1;91mProcess exited with code $_e"
    fi; fi
  }

  PROMPT_COMMAND=_print_exit_code

  _print_working_dir () {
    if [ "$PWD" = "$HOME" ]; then
      echo "~"
    else
      echo "$PWD"
    fi
  }
  _suffix="\[\e[90m\]>> \[\e[0m\]"
  PS2="$_suffix"
  PS1="\[\e[0m\e[91m\]\u\[\e[93m\]@\[\e[94m\]\H\[\e[0m\] \$(_print_working_dir)$_suffix"

  [ -f ~/.bashrc+ ] && source ~/.bashrc+
fi
