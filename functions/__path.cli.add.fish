function __path.cli.add -d "Prepend paths to $PATH or $MANPATH"
  argparse --name=(status function) -x p,m      \
    (fish_opt --short=p --long=PATH)            \
    (fish_opt --short=m --long=MANPATH)         \
    (fish_opt --short=v --long=verbose)         \
    (fish_opt --short=s --long=suppress)        \
  -- $argv
  or return 1

  set -q _flag_p
    and set -a opt -p
  set -q _flag_m
    and set -a opt -m
  set -q _flag_v
    and set -a opt -v
  set -q _flag_s
    and set -a opt -s
  set --path path $argv
  echo "$path" | path load $opt
end
