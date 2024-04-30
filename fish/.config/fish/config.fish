if status is-interactive
    # Commands to run in interactive sessions can go here
end

function starship_transient_prompt_func
  starship module character
end

starship init fish | source
enable_transience

abbr -a -- cl clear
abbr -a -- pick 'pj pickupp'
abbr -a -- downloads 'pj Downloads'
abbr -a -- gco 'git checkout'
abbr -a -- gs 'git status'
abbr -a -- gb 'git branch'
abbr -a -- gl 'git pull'
abbr -a -- gp 'git push'
abbr -a -- gf 'git fetch'
abbr -a -- ref 'source ~/.config/fish/config.fish && echo \'Sourcing fish config finished..\' && sleep 0.25 && clear'
abbr -a -- pml 'pm2 logs --lines 100'
abbr -a -- pmk 'pm2 stop all && pm2 kill && pm2 flush all'

function pm2kill
  echo 'Killing services'
  set pid_list (lsof -i :80 -t)

  for pid in (lsof -i :6000-6050 -t)
    kill -9 $pid
  end

  if test (count $pid_list) -gt 0
    for pid in $pid_list
      kill -9 $pid
    end
  end
  echo 'Finished killing services'
end

function expand-dot-to-parent-directory-path -d 'expand ... to ../.. etc'
  # Get commandline up to cursor
  set -l cmd (commandline --cut-at-cursor)

  # Match last line
  switch $cmd[-1]
    case '*..'
      commandline --insert '/..'
    case '*'
      commandline --insert '.'
  end
end

function run --description 'Edit commands in an editor, then run them.'
  set -l editor
  if set -q VISUAL
    set editor $VISUAL
  else if set -q EDITOR
    set editor $EDITOR
  end
  set -l interactive

  if test -n "$editor"
    # Break editor up to get its first command (i.e. discard flags)
    set -l editor_cmd
    eval set editor_cmd $editor
    if not type -q -f "$editor_cmd[1]"
      echo "run: The value for \$VISUAL or \$EDITOR '$editor' could not be used because the command '$editor_cmd[1]' could not be found"
      return -1
    end
  else
    echo "run: Cannot find an available editor in \$VISUAL or \$EDITOR"
    return -1
  end

  set -l tmpname (mktemp -t fish_run.XXXXXXXXXX.fish)
  if not eval $editor $tmpname
    echo "run: Editing failed"
    return -1
  end
  set -l stat 0
  if test -s $tmpname
    source $tmpname
    set stat $status
  else
    echo "run: Editing cancelled"
  end
  rm -f $tmpname >/dev/null
  return $stat
end

function my_key_bindings
  fish_default_key_bindings
  bind . 'expand-dot-to-parent-directory-path'
  # bind \c_ 'run'
end

set -g fish_key_bindings my_key_bindings
