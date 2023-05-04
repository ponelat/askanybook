#!/usr/bin/env bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Build docker image
rake docker:build
# Push it (requires logged-in)
rake docker:push

# Push the files up
rsync -r \
    $DIR/docker-compose.production.yml \
    $DIR/.env \
    $DIR/books/  \
    ec2-user@askanybook.ponelat.com:/home/ec2-user/

# Pull new image and redeploy
ssh ec2-user@askanybook.ponelat.com "\
docker-compose -f ./docker-compose.production.yml pull \
&& docker-compose -f docker-compose.production.yml up -d"
