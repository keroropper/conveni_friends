#!/bin/bash
set -e 

rm -f /app/tmp/pids/server.pid
# RAILS_ENV=production bin/rails db:create
# RAILS_ENV=production bin/rails db:migrate
RAILS_ENV=production bin/rails db:reset

exec "$@"
