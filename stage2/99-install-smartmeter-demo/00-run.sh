#!/bin/bash -e

on_chroot << EOF
wget -qO - https://repos.influxdata.com/influxdata-archive.key | \
    gpg --dearmor -o /etc/apt/keyrings/influxdata-archive.gpg
wget -qO - https://apt.grafana.com/gpg.key | \
    gpg --dearmor -o /etc/apt/keyrings/grafana.gpg
EOF

install -m 644 files/influxdata.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"
install -m 644 files/grafana.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"

on_chroot << EOF
apt-get update
EOF

# Download Smart Meter Data Collector
wget \
    -O "${ROOTFS_DIR}/tmp/smartmeter-datacollector.deb" \
    "https://github.com/scs/smartmeter-datacollector/releases/download/v2.0.0/smartmeter-datacollector_v2.0.0-1_all.deb"

# Download Smart Meter Data Collector Configurator
wget \
    -O "${ROOTFS_DIR}/tmp/smartmeter-datacollector-configurator.deb" \
    "https://github.com/scs/smartmeter-datacollector-configurator/releases/download/v2.0.0/smartmeter-datacollector-configurator_v2.0.0-1_arm64.deb"
