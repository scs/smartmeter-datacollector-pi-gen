#!/bin/bash -e

# Setup InfluxDB
install -m 644 files/create-smartmeter-db.service "${ROOTFS_DIR}/lib/systemd/system/"
on_chroot << EOF
systemctl daemon-reload
systemctl unmask influxdb.service
systemctl enable create-smartmeter-db.service
EOF

# Setup Telegraf
install -m 644 files/telegraf/telegraf.conf "${ROOTFS_DIR}/etc/telegraf/"
install -m 644 files/telegraf/input_mqtt.conf "${ROOTFS_DIR}/etc/telegraf/telegraf.d/"
install -m 644 files/telegraf/output_influxdb.conf "${ROOTFS_DIR}/etc/telegraf/telegraf.d/"
on_chroot << EOF
EOF

# Setup Grafana
install -d "${ROOTFS_DIR}/var/lib/grafana/dashboards"
install -m 644 files/grafana/ekz_smartmeter_cii.json "${ROOTFS_DIR}/var/lib/grafana/dashboards/"
install -m 644 files/grafana/schema_overview.json "${ROOTFS_DIR}/var/lib/grafana/dashboards/"
install -m 644 files/grafana/datasources.yaml "${ROOTFS_DIR}/etc/grafana/provisioning/datasources/"
install -m 644 files/grafana/dashboards.yaml "${ROOTFS_DIR}/etc/grafana/provisioning/dashboards/"

on_chroot << EOF
systemctl enable grafana-server.service
EOF
