function __path.cli.show -d "print all paths in $PATH"
  for path in $PATH
    echo $path
  end
end
