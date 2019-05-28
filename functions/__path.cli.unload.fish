function __path.cli.unload -d "Load paths from files and prepend to PATH"
  argparse --name=(status function) -x p,m      \
    (fish_opt --short=p --long=PATH)            \
    (fish_opt --short=m --long=MANPATH)         \
    (fish_opt --short=v --long=verbose)         \
    (fish_opt --short=s --long=suppress)        \
  -- $argv
  or return 1
  
  if set -q _flag_m
    set PATHvar MANPATH
    set PATHflag -m
  else 
    set PATHvar PATH
    set PATHflag -p
  end

  for arg in $argv 
    for filevar in $__path_files
      set file $$filevar
      if test (realpath $arg) = $file
      or test (realpath $arg) = (dirname $file)
        path unbind $PATHflag {$filevar}_{$PATHvar}  
        set -e {$filevar}_{$PATHvar}
        set -e $filevar
        set -l idx (contains --index -- $filevar $__path_files)
          and set -e __path_files[$idx]
      end
    end
  end

  return 0
end
