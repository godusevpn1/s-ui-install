#!/usr/bin/env bash
set -e

VER="v1.4.1"
USER="fangjunsheng555"
REPO="s-ui-install"

ARCH_RAW="$(uname -m)"
case "$ARCH_RAW" in
  x86_64|amd64) ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  armv7l|armv7) ARCH="armv7" ;;
  i386|i686) ARCH="386" ;;
  *)
    echo "不支持的架构: $ARCH_RAW"
    exit 1
    ;;
esac

URL="https://github.com/${USER}/${REPO}/releases/download/${VER}/s-ui-linux-${ARCH}.tar.gz"

echo "[1/6] 安装依赖"
apt-get update -y
apt-get install -y wget tar

echo "[2/6] 下载"
cd /tmp || exit 1
rm -rf s-ui s-ui-linux-*.tar.gz
wget -O "s-ui-linux-${ARCH}.tar.gz" "$URL"

echo "[3/6] 解压"
tar zxf "s-ui-linux-${ARCH}.tar.gz"

echo "[4/6] 安装"
chmod +x s-ui/sui s-ui/s-ui.sh
cp s-ui/s-ui.sh /usr/bin/s-ui
cp -rf s-ui /usr/local/
cp -f s-ui/*.service /etc/systemd/system/

echo "[5/6] 启动"
systemctl daemon-reload
systemctl enable s-ui --now

echo "[6/6] 完成"
systemctl status s-ui --no-pager -l
