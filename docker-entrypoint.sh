#!/bin/sh

for var in REDMINE_URL REDMINE_API_KEY SLACK_TOKEN; do
  if [ -z "$(eval echo \$"$var")" ]; then
    echo "Variable $var is not set." >&2
    exit 1
  fi
done

envsubst < /config.yml.template | tee /config.yml

exec /slack-redmine-bot --config /config.yml
