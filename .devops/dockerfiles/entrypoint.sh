#!/bin/bash

set -e

if [ -f /desafio-ninja/tmp/pids/server.pid ]; then
  rm /desafio-ninja/tmp/pids/server.pid
fi

exec "$@"