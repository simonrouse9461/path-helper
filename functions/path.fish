function path -d "Utilities for managing $PATH and $MANPATH"
  set -l cmd $argv[1]
  set -e argv[1]
  __path.cli.$cmd $argv 
end
