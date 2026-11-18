#!/usr/bin/env bash
systemctl --user start mariadb.service techstore.service cloudflared-tunnel.service
sleep 3
./tunnel-info.sh
