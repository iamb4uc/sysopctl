#!/bin/bash

BIN_DIR="/usr/bin"
MAN_DIR="/usr/share/man/man1"
SCRIPT_NAME="sysopctl"
MANUAL_FILE="sysopctl.1"

command_exists() {
    command -v "$1" &>/dev/null
}

if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run as root."
    exit 1
fi

if [ ! -f "./$SCRIPT_NAME" ]; then
    echo "Error: $SCRIPT_NAME script not found."
    exit 1
fi

if [ ! -f "./$MANUAL_FILE" ]; then
    echo "Error: $MANUAL_FILE not found."
    exit 1
fi

echo "Installing $SCRIPT_NAME to $BIN_DIR..."
cp "./$SCRIPT_NAME" "$BIN_DIR"
chmod +x "$BIN_DIR/$SCRIPT_NAME"

echo "Installing $MANUAL_FILE to $MAN_DIR..."
cp "./$MANUAL_FILE" "$MAN_DIR"
gzip "$MAN_DIR/$MANUAL_FILE"

if command_exists mandb; then
    mandb
elif command_exists mandoc; then
    mandoc -Tutf8 <"$MAN_DIR/$MANUAL_FILE.gz" >/dev/null
else
    echo "Error: Neither mandb nor mandoc is available. Manual page might not be properly updated."
    exit 1
fi

echo "Installation completed. You can now use the $SCRIPT_NAME command."
