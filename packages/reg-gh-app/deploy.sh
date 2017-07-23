#!/bin/bash

if [ ! -f keys/private-key.pem ]; then
  node keys/pem-zip.js
fi
yarn run webpack
cp serverless.yml serverless.yml.bk
cat serverless.yml.bk | sed "s/- serverless-webpack//" > serverless.yml
yarn run sls -- deploy
mv serverless.yml.bk serverless.yml
apiEndpoint=$(./node_modules/.bin/sls info | grep POST - | head -n 1 | cut -b 10- | sed "s/\/api.*//")
cat << JSON > ../reg-notify-github-plugin/.endpoint.json
{ "endpoint": "$apiEndpoint" }
JSON