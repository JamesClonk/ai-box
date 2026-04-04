#!/bin/bash
set -e

VM_NAME="ai-box"
SHARE_NAME="projects"
MOUNT_POINT="/home/vagrant/projects"

NEW_PATH="${1:?Usage: $0 /path/to/host/folder}"
NEW_PATH=$(eval echo "$NEW_PATH") # expand ~

if [ ! -d "$NEW_PATH" ]; then
  echo "❌ Directory not found: $NEW_PATH"
  exit 1
fi
echo "🔄 Swapping shared folder to: $NEW_PATH"

# unmount inside VM
vagrant ssh -c "sudo umount $MOUNT_POINT 2>/dev/null || true"

# swap VBoxManage share
VBoxManage sharedfolder remove "$VM_NAME" --name "$SHARE_NAME" 2>/dev/null || true
VBoxManage sharedfolder add "$VM_NAME" --name "$SHARE_NAME" --hostpath "$NEW_PATH" --transient

# remount inside VM
vagrant ssh -c "sudo mount -t vboxsf $SHARE_NAME $MOUNT_POINT && echo '✅ Mounted $NEW_PATH -> $MOUNT_POINT'"
