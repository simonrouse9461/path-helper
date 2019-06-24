@mesg $current_filename

function setup
  set -gx original_PATH $PATH
  set -g testpath /test/path /more/test/path
end

function teiardown
  set -e testpath
  set -gx PATH $original_PATH
end

@test "test unbind status" (
  path bind testpath
  path unbind testpath
) $status = 0

@test "test unbind if testpath is not in PATH" (
  path bind testpath
  path unbind testpath
  set testpath /test/path/again
  echo "$PATH"
) = "$original_PATH"

@test "test unbind if testpath is already in PATH" (
  set -p PATH /test/path
  path bind testpath
  path unbind testpath
  echo "$PATH"
) = /test/path:"$original_PATH"

