@mesg $current_filename

function setup
  set -gx original_PATH $PATH
end

function teardown
  path unbind testpath
  set -e testpath
  set -gx PATH $original_PATH
end

@test "test bind status" (
  set testpath /test/path
  path bind testpath
) $status = 0

@test "test companion var after bind" (
  set testpath /test/path
  path bind testpath
  echo "$testpath_added_PATH"
) = /test/path

@test "test update binding variable" (
  set testpath /test/path
  path bind testpath
  set testpath /test/newpath
  echo "$PATH"
) = "/test/newpath:$original_PATH"

