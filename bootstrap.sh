#!/bin/bash

set -e
set -o pipefail

ROOT_DIR=$(pwd)
DEPS_DIR="$ROOT_DIR/Thirdparties"

PYTHON_VER=3.9.12
YT_DLP_VER=2024.08.01

YTDL_PLIST="$ROOT_DIR/YTDLKit/Resources/YTDL.plist"

rm -rf $DEPS_DIR/

# https://github.com/beeware/Python-Apple-support

PYTHON_SUPPORT="Python-iOS-support"
echo "[*] downloading $PYTHON_SUPPORT..."
curl -L -o "$DEPS_DIR/$PYTHON_SUPPORT.tar.gz" --create-dirs \
	https://github.com/beeware/Python-Apple-support/releases/download/3.9-b7/Python-3.9-iOS-support.b7.tar.gz

mkdir -p $DEPS_DIR/$PYTHON_SUPPORT/
echo "[*] extracting $PYTHON_SUPPORT..."
tar xzf $DEPS_DIR/$PYTHON_SUPPORT.tar.gz \
	-C $DEPS_DIR/$PYTHON_SUPPORT/

rm "$DEPS_DIR/$PYTHON_SUPPORT.tar.gz"

echo "[*] compressing Python..."
cd $DEPS_DIR/$PYTHON_SUPPORT/Python/Resources/
zip -r -q python.zip lib/

echo "[*] updating Python version to $PYTHON_VER inside YTDLKit's plist..."
plutil -replace PYTHON_VER -string $PYTHON_VER "$YTDL_PLIST"

# https://github.com/yt-dlp/yt-dlp

echo "[*] downloading yt-dlp-$YT_DLP_VER..."
curl -L -o "$DEPS_DIR/yt-dlp" --create-dirs \
	https://github.com/yt-dlp/yt-dlp/releases/download/$YT_DLP_VER/yt-dlp

echo "[*] compressing yt-dlp..."
cd $DEPS_DIR/
zip -r -q yt-dlp.zip yt-dlp

echo "[*] updating yt-dlp version to $YT_DLP_VER inside YTDLKit's plist..."
plutil -replace YT_DLP_VER -string $YT_DLP_VER "$YTDL_PLIST"

rm "$DEPS_DIR/yt-dlp"
