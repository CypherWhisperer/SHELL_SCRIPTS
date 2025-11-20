#!/bin/bash

# =============================================================================
# SystemD-Homed User Configuration Update Commands
# =============================================================================

# =============================================================================
# Brief Explaination:
# =============================================================================
# 1. UID Consistency:     Set to 60001 and 60002 (systemd-homed recommended range)
# 2. Image Path:          Updated to /home/USERNAME.home (standard location after move)
# 3. Performance:         Enabled luks-discard for SSD optimization
# 4. Memory:              Conservative limits for 8GB RAM system with ZRAM
# 5. Sessions:            Hyprland for cypher-whisperer, GNOME for cephas-mambo
# 6. Auto-resize:         Enabled for btrfs space optimization
# 7. Recovery:            Enabled recovery keys for multi-boot safety
# 8. Avatar/Background:   Placeholders - update paths to your actual files


echo "Updating cypher-whisperer (Hyprland user)..."

# Comprehensive update for cypher-whisperer
sudo homectl update cypher-whisperer \
    --real-name="Cypher Whisperer" \
    --uid=60001 \
    --shell=/usr/bin/zsh \
    --member-of=wheel,shareddata \
    --storage=luks \
    --disk-size=30G \
    --fs-type=btrfs \
    --image-path=/home/cypher-whisperer.home \
    --home-dir=/home/cypher-whisperer \
    --access-mode=0700 \
    --language=en_US.UTF-8 \
    --session-type=wayland \
    --session-launcher=Hyprland \
    --auto-resize-mode=shrink-and-grow \
    --luks-discard=yes \
    --luks-offline-discard=yes \
    --drop-caches=no \
    --tasks-max=4096 \
    --memory-high=6G \
    --memory-max=7G \
    --rebalance-weight=100 \
    --recovery-key=yes \
    --avatar=/mnt/HOME/SYSTEMS_FILES/HYPRLAND/Pictures/cypher-whisperer-avatar.jpg \
    --login-background=/mnt/HOME/SYSTEMS_FILES/HYPRLAND/Pictures/cypher-whisperer-background.jpg

echo "Updating cephas-mambo (GNOME user)..."

# Comprehensive update for cephas-mambo
sudo homectl update cephas-mambo \
    --real-name="Cephas Mambo" \
    --uid=60002 \
    --shell=/usr/bin/zsh \
    --member-of=wheel,shareddata \
    --storage=luks \
    --disk-size=30G \
    --fs-type=btrfs \
    --image-path=/home/cephas-mambo.home \
    --home-dir=/home/cephas-mambo \
    --access-mode=0700 \
    --language=en_US.UTF-8 \
    --session-type=wayland \
    --session-launcher=gnome \
    --auto-resize-mode=shrink-and-grow \
    --luks-discard=yes \
    --luks-offline-discard=yes \
    --drop-caches=no \
    --tasks-max=4096 \
    --memory-high=6G \
    --memory-max=7G \
    --rebalance-weight=100 \
    --recovery-key=yes \
    --avatar=/mnt/HOME/SYSTEMS_FILES/GNOME/Pictures/cephas-mambo-avatar.jpg \
    --login-background=/mnt/HOME/SYSTEMS_FILES/GNOME/Pictures/cephas-mambo-background.jpg

echo "Verification commands:"
echo "sudo homectl inspect cypher-whisperer"
echo "sudo homectl inspect cephas-mambo"
echo "sudo btrfs subvolume list /mnt"
