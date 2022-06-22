#!/usr/bin/env bash

set -u
set -e

COMPOSE_LOCATION="/usr/local/bin/docker-compose"
AWSCLI_LOCATION="$(which aws)"
AWS_REGION="eu-north-1"
ECR_URI="374254383031.dkr.ecr.${AWS_REGION}.amazonaws.com"

${AWSCLI_LOCATION} --region ${AWS_REGION} ecr get-login-password | docker login \
  --username AWS \
  --password-stdin ${ECR_URI}

# Run compose
${COMPOSE_LOCATION} "$@"

# Don't preserve login token
docker logout