#!/usr/bin/env zsh
# cc-worktree — create/enter a git worktree for <branch> and start claude in it.
#
# Source this file from your ~/.zshrc:
#   source ~/emacs/scripts/cc-worktree.zsh
#
# Usage:
#   cc-worktree <branch>        # existing (local or origin/) branch, or new branch off HEAD
#   cc-worktree-emacs <branch>  # same, but open the worktree in a new Emacs frame
#   cc-worktree-rm <branch>     # remove the worktree directory
#   cc-worktree-ls              # list worktrees of the current repo
#
# Worktrees are placed in a sibling directory "worktrees/<repo>/<branch>" next
# to the main repo, so multiple repos sharing a parent directory don't collide.

# Resolve the main worktree path even when invoked from inside another worktree.
_ccwt_main_worktree() {
  emulate -L zsh
  git worktree list --porcelain 2>/dev/null \
    | awk '/^worktree / { print $2; exit }'
}

# Copy untracked files (including gitignored) from main worktree into the new
# one — local tools, symlinks, .envrc, etc. that aren't in the repo but are
# needed to work. Set CC_WORKTREE_NO_COPY=1 to skip. Extra excludes can be
# added via CC_WORKTREE_EXCLUDES (space-separated names or rsync patterns).
_ccwt_copy_untracked() {
  emulate -L zsh
  local main_wt="$1" dst="$2"
  [[ -n "${CC_WORKTREE_NO_COPY:-}" ]] && return 0

  local -a excludes
  excludes=(
    node_modules
    .direnv
    build
    target
    dist
    .venv
    __pycache__
  )
  if [[ -n "${CC_WORKTREE_EXCLUDES:-}" ]]; then
    excludes+=(${=CC_WORKTREE_EXCLUDES})
  fi

  local -a rsync_args
  rsync_args=(-a --files-from=- --from0)
  local e
  for e in $excludes; do
    rsync_args+=(--exclude="$e")
  done

  git -C "$main_wt" ls-files -oz \
    | rsync $rsync_args "$main_wt/" "$dst/" \
    || print -u2 "cc-worktree: warning: copying untracked files failed"
}

# Resolve and (if needed) create the worktree for <branch>. Prints the
# resulting path on stdout on success.
_ccwt_ensure() {
  emulate -L zsh
  local branch="$1"
  if [[ -z "$branch" ]]; then
    print -u2 "usage: ${funcstack[2]:-cc-worktree} <branch>"
    return 1
  fi

  local main_wt
  main_wt=$(_ccwt_main_worktree) || return 1
  if [[ -z "$main_wt" ]]; then
    print -u2 "cc-worktree: not inside a git repo"
    return 1
  fi

  local repo_name="${main_wt:t}"
  local wt_root="${main_wt:h}/worktrees/${repo_name}"
  local wt_path="${wt_root}/${branch}"

  mkdir -p "$wt_root" || return 1

  if [[ -d "$wt_path" ]]; then
    print -u2 "cc-worktree: $wt_path already exists, entering it"
  else
    if git -C "$main_wt" show-ref --verify --quiet "refs/heads/$branch"; then
      git -C "$main_wt" worktree add "$wt_path" "$branch" >&2 || return 1
    elif git -C "$main_wt" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
      git -C "$main_wt" worktree add --track -b "$branch" "$wt_path" "origin/$branch" >&2 || return 1
    else
      git -C "$main_wt" worktree add -b "$branch" "$wt_path" >&2 || return 1
    fi
    _ccwt_copy_untracked "$main_wt" "$wt_path"
  fi

  print -r -- "$wt_path"
}

cc-worktree() {
  emulate -L zsh
  local wt_path
  wt_path=$(_ccwt_ensure "$1") || return 1

  cd "$wt_path" || return 1

  if (( $+commands[claude] )); then
    claude
  else
    print -u2 "cc-worktree: 'claude' not on PATH — you're in $wt_path"
  fi
}

cc-worktree-emacs() {
  emulate -L zsh
  local wt_path
  wt_path=$(_ccwt_ensure "$1") || return 1

  if (( $+commands[emacsclient] )); then
    emacsclient -c -n "$wt_path"
  else
    print -u2 "cc-worktree-emacs: 'emacsclient' not on PATH — worktree is at $wt_path"
    return 1
  fi
}

cc-worktree-rm() {
  emulate -L zsh
  local branch="$1"
  if [[ -z "$branch" ]]; then
    print -u2 "usage: cc-worktree-rm <branch>"
    return 1
  fi
  local main_wt
  main_wt=$(_ccwt_main_worktree) || return 1
  local repo_name="${main_wt:t}"
  local wt_path="${main_wt:h}/worktrees/${repo_name}/${branch}"
  git -C "$main_wt" worktree remove "$wt_path"
}

cc-worktree-ls() {
  emulate -L zsh
  git worktree list
}
