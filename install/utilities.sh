########################################################################################################
# SOURCE: https://github.com/cowboy/dotfiles/blob/master/bin/dotfiles
########################################################################################################
# Copyright (c) 2014 "Cowboy" Ben Alman
# Licensed under the MIT license.
# http://benalman.com/about/license/


###########################################
# GENERAL PURPOSE EXPORTED VARS / FUNCTIONS
###########################################


# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }

# For testing some of these functions.
function assert() {
  local success modes equals result
  modes=(e_error e_success); equals=("!=" "==");
  [[ "$1" == "$2" ]] && success=1 || success=0
  if [[ "$(echo "$1" | wc -l)" != 1 || "$(echo "$2" | wc -l)" != 1 ]]; then
    result="$(diff <(echo "$1") <(echo "$2") | sed '
      s/^\([^<>-].*\)/===[\1]====================/
      s/^\([<>].*\)/\1|/
      s/^< /actual   |/
      s/^> /expected |/
      2,$s/^/    /
    ')"
    [[ ! "$result" ]] && result="(multiline comparison)"
  else
    result="\"$1\" ${equals[success]} \"$2\""
  fi
  ${modes[success]} "$result"
}

# Test if the dotfiles script is currently
function is_dotfiles_running() {
  [[ "$DOTFILES_SCRIPT_RUNNING" ]] || return 1
}

# Test if this script was run via the "dotfiles" bin script (vs. via curl/wget)
function is_dotfiles_bin() {
  [[ "$(basename $0 2>/dev/null)" == dotfiles ]] || return 1
}

# OS detection
function is_osx() {
  [[ "$OSTYPE" =~ ^darwin ]] || return 1
}
function is_ubuntu() {
  [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1
}
function is_ubuntu_desktop() {
  dpkg -l ubuntu-desktop >/dev/null 2>&1 || return 1
}
function get_os() {
  for os in osx ubuntu ubuntu_desktop; do
    is_$os; [[ $? == ${1:-0} ]] && echo $os
  done
}

# Remove an entry from $PATH
# Based on http://stackoverflow.com/a/2108540/142339
function path_remove() {
  local arg path
  path=":$PATH:"
  for arg in "$@"; do path="${path//:$arg:/:}"; done
  path="${path%:}"
  path="${path#:}"
  echo "$path"
}

# Display a fancy multi-select menu.
# Inspired by http://serverfault.com/a/298312
function prompt_menu() {
  local exitcode prompt choices nums i n
  exitcode=0
  if [[ "$2" ]]; then
    _prompt_menu_draws "$1"
    read -t $2 -n 1 -sp "Press ENTER or wait $2 seconds to continue, or press any other key to edit."
    exitcode=$?
    echo ""
  fi 1>&2
  if [[ "$exitcode" == 0 && "$REPLY" ]]; then
    prompt="Toggle options (Separate options with spaces, ENTER when done): "
    while _prompt_menu_draws "$1" 1 && read -rp "$prompt" nums && [[ "$nums" ]]; do
      _prompt_menu_adds $nums
    done
  fi 1>&2
  _prompt_menu_adds
}

function _prompt_menu_iter() {
  local i sel state
  local fn=$1; shift
  for i in "${!menu_options[@]}"; do
    state=0
    for sel in "${menu_selects[@]}"; do
      [[ "$sel" == "${menu_options[i]}" ]] && state=1 && break
    done
    $fn $state $i "$@"
  done
}

function _prompt_menu_draws() {
  e_header "$1"
  _prompt_menu_iter _prompt_menu_draw "$2"
}

function _prompt_menu_draw() {
  local modes=(error success)
  if [[ "$3" ]]; then
    e_${modes[$1]} "$(printf "%2d) %s\n" $(($2+1)) "${menu_options[$2]}")"
  else
    e_${modes[$1]} "${menu_options[$2]}"
  fi
}

function _prompt_menu_adds() {
  _prompt_menu_result=()
  _prompt_menu_iter _prompt_menu_add "$@"
  menu_selects=("${_prompt_menu_result[@]}")
}

function _prompt_menu_add() {
  local state i n keep match
  state=$1; shift
  i=$1; shift
  for n in "$@"; do
    if [[ $n =~ ^[0-9]+$ ]] && (( n-1 == i )); then
      match=1; [[ "$state" == 0 ]] && keep=1
    fi
  done
  [[ ! "$match" && "$state" == 1 || "$keep" ]] || return
  _prompt_menu_result=("${_prompt_menu_result[@]}" "${menu_options[i]}")
}

# Array mapper. Calls map_fn for each item ($1) and index ($2) in array, and
# prints whatever map_fn prints. If map_fn is omitted, all input array items
# are printed.
# Usage: array_map array_name [map_fn]
function array_map() {
  local __i__ __val__ __arr__=$1; shift
  for __i__ in $(eval echo "\${!$__arr__[@]}"); do
    __val__="$(eval echo "\"\${$__arr__[__i__]}\"")"
    if [[ "$1" ]]; then
      "$@" "$__val__" $__i__
    else
      echo "$__val__"
    fi
  done
}

# Print bash array in the format "i <val>" (one per line) for debugging.
function array_print() { array_map $1 __array_print; }
function __array_print() { echo "$2 <$1>"; }

# Array filter. Calls filter_fn for each item ($1) and index ($2) in array_name
# array, and prints all values for which filter_fn returns a non-zero exit code
# to stdout. If filter_fn is omitted, input array items that are empty strings
# will be removed.
# Usage: array_filter array_name [filter_fn]
# Eg. mapfile filtered_arr < <(array_filter source_arr)
function array_filter() { __array_filter 1 "$@"; }
# Works like array_filter, but outputs array indices instead of array items.
function array_filter_i() { __array_filter 0 "$@"; }
# The core function. Wheeeee.
function __array_filter() {
  local __i__ __val__ __mode__ __arr__
  __mode__=$1; shift; __arr__=$1; shift
  for __i__ in $(eval echo "\${!$__arr__[@]}"); do
    __val__="$(eval echo "\${$__arr__[__i__]}")"
    if [[ "$1" ]]; then
      "$@" "$__val__" $__i__ >/dev/null
    else
      [[ "$__val__" ]]
    fi
    if [[ "$?" == 0 ]]; then
      if [[ $__mode__ == 1 ]]; then
        eval echo "\"\${$__arr__[__i__]}\""
      else
        echo $__i__
      fi
    fi
  done
}

# Array join. Joins array ($1) items on string ($2).
function array_join() { __array_join 1 "$@"; }
# Works like array_join, but removes empty items first.
function array_join_filter() { __array_join 0 "$@"; }

function __array_join() {
  local __i__ __val__ __out__ __init__ __mode__ __arr__
  __mode__=$1; shift; __arr__=$1; shift
  for __i__ in $(eval echo "\${!$__arr__[@]}"); do
    __val__="$(eval echo "\"\${$__arr__[__i__]}\"")"
    if [[ $__mode__ == 1 || "$__val__" ]]; then
      [[ "$__init__" ]] && __out__="$__out__$@"
      __out__="$__out__$__val__"
      __init__=1
    fi
  done
  [[ "$__out__" ]] && echo "$__out__"
}

# Do something n times.
function n_times() {
  local max=$1; shift
  local i=0; while [[ $i -lt $max ]]; do "$@"; i=$((i+1)); done
}

# Do something n times, passing along the array index.
function n_times_i() {
  local max=$1; shift
  local i=0; while [[ $i -lt $max ]]; do "$@" "$i"; i=$((i+1)); done
}

# Given strings containing space-delimited words A and B, "setdiff A B" will
# return all words in A that do not exist in B. Arrays in bash are insane
# (and not in a good way).
# From http://stackoverflow.com/a/1617303/142339
function setdiff() {
  local debug skip a b
  if [[ "$1" == 1 ]]; then debug=1; shift; fi
  if [[ "$1" ]]; then
    local setdiff_new setdiff_cur setdiff_out
    setdiff_new=($1); setdiff_cur=($2)
  fi
  setdiff_out=()
  for a in "${setdiff_new[@]}"; do
    skip=
    for b in "${setdiff_cur[@]}"; do
      [[ "$a" == "$b" ]] && skip=1 && break
    done
    [[ "$skip" ]] || setdiff_out=("${setdiff_out[@]}" "$a")
  done
  [[ "$debug" ]] && for a in setdiff_new setdiff_cur setdiff_out; do
    echo "$a ($(eval echo "\${#$a[*]}")) $(eval echo "\${$a[*]}")" 1>&2
  done
  [[ "$1" ]] && echo "${setdiff_out[@]}"
}
########################################################################################################
