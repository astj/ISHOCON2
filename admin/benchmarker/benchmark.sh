#!/usr/bin/env bash
# ./benchmark.sh <Team Name> [option]
# Options:
#   --workload	N	run benchmark with N workloads (default: 3)
#   --ip	IP	specify target IP Address (default: 127.0.0.1)

TEAMNAME=$1
if [ -z $TEAMNAME ]; then
    echo 'You need to specify team name'
    exit 1
fi
shift

DIR=$(dirname $0)

# load env
# https://songmu.jp/riji/entry/2019-06-14-bash-dotenv.html
set -o allexport
source $DIR/.env
set +o allexport

$DIR/bin/benchmark "$@" | tee | /opt/mackerel-agent/plugins/bin/mackerel-plugin-json -stdin -prefix $MACKEREL_SERVICE_METRIC_PREFIX -include score | sed "s/score/score-$TEAMNAME/" | mkr throw -s $MACKEREL_SERVICE
