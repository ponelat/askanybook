#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


scp $DIR/docker-compose.yml $DIR/../.env ec2-user@askanybook.ponelat.com:/home/ec2-user/
ssh ec2-user@askanybook.ponelat.com "docker-compose up -d"
