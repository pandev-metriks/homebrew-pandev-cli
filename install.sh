#!/bin/bash
# The PanDev CLI installer has moved. Everything public about the CLI now
# lives in one repository: https://github.com/pandev-metriks/pandev-cli
# This stub keeps old bookmarks working. New URL:
#   curl -fsSL https://raw.githubusercontent.com/pandev-metriks/pandev-cli/main/install.sh | bash
set -e
echo "The PanDev CLI installer moved to https://github.com/pandev-metriks/pandev-cli — redirecting..."
exec bash <(curl -fsSL https://raw.githubusercontent.com/pandev-metriks/pandev-cli/main/install.sh)
