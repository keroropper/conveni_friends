#!/bin/bash

set -e

rm -f /rails-vue/tmp/pids/server.pid

exec "$@"