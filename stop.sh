#!/usr/bin/env bash
systemctl --user stop cloudflared-tunnel.service techstore.service mariadb.service
echo "Đã dừng TechStore và Cloudflare Tunnel."
