#! /bin/sh

set -e

trap 'echo "Killing background jobs..."; kill $(jobs -p)' EXIT

args="$@"
command=""

case "$1" in
    -*)
	command=server
	;;
esac

(cd webapp && make serve) &

GO111MODULE=off go get github.com/cespare/reflex

$HOME/go/bin/reflex -s -R -packr\.go -r \.go$ -- \
       sh -c "rm -f evebox && RACE='-race' make evebox && \
                 ./evebox ${command} ${args}"
