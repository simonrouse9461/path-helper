function path-unbind -d "Stop prepending a path variable to $PATH"  
  set -q argv[1]
    or return
  set -l local_path $PATH
  set -l added_paths __{$argv[1]}_added_paths
  for x in $$added_paths
    set -l idx (contains --index -- $x $local_path)
    and set -e local_path[$idx]
  end
  set -xg PATH $local_path
  set -e $added_paths
  functions -e __reconstruct_path_from_$argv[1] 
end
