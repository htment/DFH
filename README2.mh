Adding hosts
Ubuntu consistently ships outdated versions of the node-exporter. Hence suggested course of action here is to fetch static binary, extract and move it to /usr/local/bin/node_exporter and set up systemd service:
```
wget https://github.com/prometheus/node_exporter/releases/download/v1.9.0/node_exporter-1.9.0.linux-amd64.tar.gz
tar xvzf node_exporter-1.9.0.linux-amd64.tar.gz
cp node_exporter-1.9.0.linux-amd64/node_exporter /usr/local/bin/node_exporter
cat << \EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter

[Service]
# Make sure you don't make it available to whole world by adding listen address
# --web.listen-address="172.20.8.XXX:9100"
RuntimeDirectory=node-exporter
ExecStart=/usr/local/bin/node_exporter --collector.textfile.directory /run/node-exporter
User=nobody

[Install]
WantedBy=multi-user.target
EOF
systemctl enable --now node_exporter
Enable k10temp for Opterons:

echo k10temp >> /etc/modules
modprobe k10temp
For disks you need additional textfile metrics:

apt install -y nvme-cli smartmontools
echo > /usr/local/bin/node-exporter-textfile-collectors
curl https://raw.githubusercontent.com/prometheus-community/node-exporter-textfile-collector-scripts/master/nvme_metrics.sh >> /usr/local/bin/node-exporter-textfile-collectors
curl https://raw.githubusercontent.com/prometheus-community/node-exporter-textfile-collector-scripts/master/smartmon.sh >> /usr/local/bin/node-exporter-textfile-collectors
chmod +x /usr/local/bin/node-exporter-textfile-collectors
cat << \EOF > /etc/systemd/system/node_exporter_textfile_collectors.service
[Unit]
Description=Node Exporter textfile collectors

[Service]
Restart=always
RestartSec=30s
ExecStart=/bin/bash -c '/usr/local/bin/node-exporter-textfile-collectors > /run/node-exporter/disks.part; mv /run/node-exporter/disks.part /run/node-exporter/disks.prom'

[Install]
WantedBy=multi-user.target
EOF
systemctl enable --now node_exporter_textfile_collectors
```
