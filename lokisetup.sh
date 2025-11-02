#!/bin/bash
mkdir -p /tmp/lok
cd /tmp/lok
wget https://github.com/grafana/loki/releases/latest/download/loki-linux-amd64.zip
sudo apt install unzip -y
unzip loki-linux-amd64.zip
sudo mv loki-linux-amd64 /usr/local/bin/loki
sudo chmod +x /usr/local/bin/loki
loki --version
groupadd --system loki
useradd --system --no-create-home --shell /sbin/nologin --gid loki loki
sudo mkdir -p /var/lib/loki/chunks /var/lib/loki/rules
sudo chown -R loki:loki /var/lib/loki
sudo chmod -R 755 /var/lib/loki
mkdir -p /etc/loki/
cat <<EOF > /etc/loki/config.yml
auth_enabled: false

server:
  http_listen_port: 3100

common:
  path_prefix: /var/lib/loki
  storage:
    filesystem:
      chunks_directory: /var/lib/loki/chunks
      rules_directory: /var/lib/loki/rules
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

schema_config:
  configs:
    - from: 2023-01-01
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h

limits_config:
  allow_structured_metadata: false
EOF


cat <<EOF > /etc/systemd/system/loki.service
[Unit]
Description=Loki Log Aggregation
After=network.target

[Service]
User=loki
Group=loki
Type=simple
ExecStart=/usr/local/bin/loki --config.file=/etc/loki/config.yml
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

sudo ufw allow 3100/tcp

sudo systemctl daemon-reload
sudo systemctl enable loki
sudo systemctl start loki
sudo systemctl status loki --no-pager

sleep 100
curl http://localhost:3100/ready

curl -s http://localhost:3100/metrics | grep loki_build_info

