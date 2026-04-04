#!/bin/bash
set -e

VM_NAME="ai-box"
SHARE_NAME="projects"
MOUNT_POINT="/home/vagrant/projects"

NEW_PATH="${1:?Usage: $0 /path/to/host/folder}"
NEW_PATH=$(cd "$(dirname "$NEW_PATH")" && pwd)/$(basename "$NEW_PATH") # resolve to absolute path

if [ ! -d "$NEW_PATH" ]; then
  echo "❌ Directory not found: $NEW_PATH"
  exit 1
fi
echo "🔄 Swapping shared folder to: $NEW_PATH"

# unmount, remove old share, add new share, remount — all in one vagrant ssh call
# to avoid VBoxManage lock conflicts with Vagrant's session
vagrant ssh -c "
  sudo umount $MOUNT_POINT 2>/dev/null || true
  sudo VBoxControl sharedfolder remove $SHARE_NAME 2>/dev/null || true
" 

# use VBoxManage with --transient while no vagrant ssh session holds the lock
VBoxManage sharedfolder remove "$VM_NAME" --name "$SHARE_NAME" --transient 2>/dev/null || true
VBoxManage sharedfolder add "$VM_NAME" --name "$SHARE_NAME" --hostpath "$NEW_PATH" --transient

vagrant ssh -c "sudo mount -t vboxsf -o uid=\$(id -u vagrant),gid=\$(id -g vagrant) $SHARE_NAME $MOUNT_POINT && echo '✅ Mounted $NEW_PATH -> $MOUNT_POINT'"
