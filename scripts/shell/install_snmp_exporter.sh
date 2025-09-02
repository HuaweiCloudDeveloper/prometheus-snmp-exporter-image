#!/bin/bash

# SNMP Exporter 安装脚本
set -e

# 配置参数
VERSION="0.28.0"
ARCH="linux-arm64"
DOWNLOAD_URL="https://github.com/prometheus/snmp_exporter/releases/download/v${VERSION}/snmp_exporter-${VERSION}.${ARCH}.tar.gz"
INSTALL_DIR="/opt/snmp_exporter"
CONFIG_DIR="/etc/snmp_exporter"
SERVICE_USER="snmp_exporter"

# 检查是否以root用户运行
if [ "$(id -u)" -ne 0 ]; then
    echo "请以root用户运行此脚本"
    exit 1
fi

# 创建用户和目录
echo "创建用户和目录..."
if ! id -u ${SERVICE_USER} >/dev/null 2>&1; then
    useradd --system --no-create-home --shell /bin/false ${SERVICE_USER}
fi

mkdir -p ${INSTALL_DIR}
mkdir -p ${CONFIG_DIR}
chown ${SERVICE_USER}:${SERVICE_USER} ${INSTALL_DIR} ${CONFIG_DIR}

# 下载并解压
echo "下载snmp_exporter..."
cd /tmp
curl -LO ${DOWNLOAD_URL} || wget ${DOWNLOAD_URL}

echo "解压文件..."
tar -xzf snmp_exporter-${VERSION}.${ARCH}.tar.gz
cd snmp_exporter-${VERSION}.${ARCH}

# 安装文件
echo "安装文件..."
cp snmp_exporter ${INSTALL_DIR}/
cp snmp.yml ${CONFIG_DIR}/

# 设置权限
chown ${SERVICE_USER}:${SERVICE_USER} ${INSTALL_DIR}/snmp_exporter
chown ${SERVICE_USER}:${SERVICE_USER} ${CONFIG_DIR}/snmp.yml
chmod 755 ${INSTALL_DIR}/snmp_exporter
chmod 644 ${CONFIG_DIR}/snmp.yml

# 创建systemd服务文件
echo "创建systemd服务..."
cat > /etc/systemd/system/snmp_exporter.service << EOF
[Unit]
Description=SNMP Exporter
Documentation=https://github.com/prometheus/snmp_exporter
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=${SERVICE_USER}
Group=${SERVICE_USER}
ExecStart=${INSTALL_DIR}/snmp_exporter --config.file=${CONFIG_DIR}/snmp.yml
Restart=always
RestartSec=5
TimeoutStopSec=10

[Install]
WantedBy=multi-user.target
EOF

# 重新加载systemd并启动服务
echo "启动服务..."
systemctl daemon-reload
systemctl enable snmp_exporter
systemctl start snmp_exporter

# 检查服务状态
echo "检查服务状态..."
sleep 3
systemctl status snmp_exporter --no-pager

# 清理临时文件
echo "清理临时文件..."
rm -rf /tmp/snmp_exporter-${VERSION}.${ARCH}*
rm -f /tmp/snmp_exporter-${VERSION}.${ARCH}.tar.gz

echo "安装完成！"
echo "SNMP Exporter 已安装到: ${INSTALL_DIR}"
echo "配置文件位置: ${CONFIG_DIR}/snmp.yml"
echo "服务管理命令:"
echo "  sudo systemctl start snmp_exporter    # 启动服务"
echo "  sudo systemctl stop snmp_exporter     # 停止服务"
echo "  sudo systemctl restart snmp_exporter  # 重启服务"
echo "  sudo systemctl status snmp_exporter   # 查看状态"
echo ""
echo "默认监听端口: 9116"
echo "可以通过浏览器访问: http://服务器IP:9116"