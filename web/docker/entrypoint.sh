#!/bin/sh
set -e

AUTH_B64=$(printf '%s:%s' "$SURREAL_USER" "$SURREAL_PASS" | base64 | tr -d '\n')
export AUTH_B64

# basic auth на весь сайт — временная защита до Keycloak (этап F, D-11)
if [ -n "$WEB_BASIC_PASS" ]; then
  printf '%s:%s\n' "${WEB_BASIC_USER:-domovoy}" "$(openssl passwd -apr1 "$WEB_BASIC_PASS")" > /etc/nginx/.htpasswd
  export AUTH_DIRECTIVES='auth_basic "Domovoy"; auth_basic_user_file /etc/nginx/.htpasswd;'
else
  export AUTH_DIRECTIVES=''
fi

mkdir -p /etc/nginx/conf.d
envsubst '${AUTH_B64} ${AUTH_DIRECTIVES}' \
  < /etc/nginx/templates-src/default.conf.template \
  > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
