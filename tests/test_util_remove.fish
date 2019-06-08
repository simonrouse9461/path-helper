@mesg $current_filename

function setup
  set -g testvar 1 2 3 4 5 6 7
  set -e notexist
end

function teardown
  set -e testvar
end

@test "test remove nothing from list" (
  __path.util.remove testvar
) "$testvar" = "1 2 3 4 5 6 7"

@test "test remove multiple elements from list" (
  __path.util.remove testvar 1 3 5 7
) "$testvar" = "2 4 6"

@test "test non-existing element from var" (
  __path.util.remove testvar 8 9 0
) "$testvar" = "1 2 3 4 5 6 7"

@test "test status after removing from non-existing var" (
  __path.util.remove notexist 1 2 3
) $status = 1

@test "test status if fail to remove last element" (
  __path.util.remove testvar 1 2 0
) $status = 1
