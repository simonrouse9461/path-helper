function __path.cli.use -d ""
  set cmd (basename $argv[1])
  # TODO wildcard and tilde expansion
  set path (realpath (dirname $argv[1]))

  switch (type -t $cmd)
  case file
  case function
  case builtin
  end

  eval "
    function 

  "
end
