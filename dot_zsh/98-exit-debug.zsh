# Exit instrumentation for interactive zsh sessions.
# Writes a compact snapshot on shell teardown so tab-close hangs can be diagnosed after the fact.

[[ "${IS_INTERACTIVE_SHELL:-0}" -eq 1 ]] || return 0

autoload -Uz add-zsh-hook
zmodload zsh/datetime 2>/dev/null || true

typeset -gr ZSH_EXIT_DEBUG_LOG="${XDG_CACHE_HOME:-$HOME/.cache}/zsh-exit-debug.log"
typeset -gi _zsh_exit_debug_seq=0

_zsh_exit_debug_timestamp() {
  if (( ${+EPOCHREALTIME} )); then
    print -r -- "$EPOCHREALTIME"
  else
    printf '%(%Y-%m-%dT%H:%M:%S%z)T\n' -1
  fi
}

_zsh_exit_debug_log() {
  local reason="$1"
  local ts tty_path last_status job_dump fd_dump proc_dump pstree_dump

  (( ++_zsh_exit_debug_seq ))
  ts="$(_zsh_exit_debug_timestamp)"
  tty_path="$(tty 2>/dev/null || print -r -- "not-a-tty")"
  last_status="$?"
  job_dump="$(jobs -l 2>&1)"
  fd_dump="$(ls -l /proc/$$/fd 2>&1)"
  proc_dump="$(ps -o pid,ppid,pgid,sid,tty,stat,etime,command -p $$ --ppid $$ 2>&1)"
  if (( $+commands[pstree] )); then
    pstree_dump="$(pstree -aps $$ 2>&1)"
  else
    pstree_dump="pstree unavailable"
  fi

  {
    print -r -- "===== zsh-exit-debug ====="
    print -r -- "timestamp=$ts"
    print -r -- "reason=$reason"
    print -r -- "seq=$_zsh_exit_debug_seq"
    print -r -- "pid=$$ ppid=$PPID shlvl=$SHLVL status=$last_status"
    print -r -- "tty=$tty_path pwd=$PWD"
    print -r -- "term=${TERM:-} term_program=${TERM_PROGRAM:-} wt_session=${WT_SESSION:-} wsl_distro=${WSL_DISTRO_NAME:-}"
    print -r -- "precmd_functions=${(j: :)precmd_functions}"
    print -r -- "preexec_functions=${(j: :)preexec_functions}"
    print -r -- "chpwd_functions=${(j: :)chpwd_functions}"
    print -r -- "-- jobs --"
    print -r -- "$job_dump"
    print -r -- "-- process-tree --"
    print -r -- "$pstree_dump"
    print -r -- "-- ps --"
    print -r -- "$proc_dump"
    print -r -- "-- fd --"
    print -r -- "$fd_dump"
    print -r -- ""
  } >>"$ZSH_EXIT_DEBUG_LOG" 2>&1
}

_zsh_exit_debug_zshexit() {
  _zsh_exit_debug_log "zshexit"
}

TRAPEXIT() {
  _zsh_exit_debug_log "TRAPEXIT"
}

TRAPHUP() {
  _zsh_exit_debug_log "SIGHUP"
  return 0
}

TRAPTERM() {
  _zsh_exit_debug_log "SIGTERM"
  return 0
}

TRAPINT() {
  _zsh_exit_debug_log "SIGINT"
  return 0
}

add-zsh-hook zshexit _zsh_exit_debug_zshexit
