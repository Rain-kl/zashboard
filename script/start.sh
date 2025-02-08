#!/bin/ash

chmod +x ./mihomo

./mihomo &

cd /srv

caddy run
