#!/usr/bin/env fish

set -l testdir (dirname (realpath (status current-filename)))/tests
fishtape $testdir/*.fish | tap-summary
