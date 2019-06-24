function __path.util.prepend
  set -l varname $argv[1]
  set -l values $argv[2..-1]
  set -q $varname
    or return 1
  __path.util.remove $varname $values
  for v in $values[-1..1]
    set -p $varname $v
  end
end
