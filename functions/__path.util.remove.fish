function __path.util.remove
  set -l varname $argv[1]
  set -l values $argv[2..-1]
  set -q $varname
    or return 1
  for v in $values
    set -l idx (contains --index -- $v $$varname)
      and eval set -e $varname\[$idx\]
  end
end
