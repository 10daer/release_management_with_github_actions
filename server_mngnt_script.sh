#!/bin/bash
# Save these scripts on your server for manual management

# ============================================
# File: /var/www/nest-app/check-version.sh
# Usage: ./check-version.sh
# ============================================
check_version() {
    echo "========================================="
    echo "Application Version Information"
    echo "========================================="
    
    if [ -f /var/www/nest-app/current-version.txt ]; then
        echo "Current Version:"
        cat /var/www/nest-app/current-version.txt
        echo ""
    fi
    
    echo "Available Versions:"
    ls -lt /var/www/nest-app/releases | grep "^d" | awk '{print $9, $6, $7, $8}'
    echo ""
    
    echo "Current Symlink Points To:"
    readlink /var/www/nest-app/current
    echo ""
    
    echo "Application Status:"
    pm2 list
    echo "========================================="
}

# ============================================
# File: /var/www/nest-app/switch-version.sh
# Usage: ./switch-version.sh v1.0.0
# ============================================
switch_version() {
    if [ -z "$1" ]; then
        echo "Usage: ./switch-version.sh <version>"
        echo "Example: ./switch-version.sh v1.0.0"
        exit 1
    fi
    
    VERSION=$1
    APP_DIR="/var/www/nest-app"
    TARGET_DIR="$APP_DIR/releases/$VERSION"
    
    if [ ! -d "$TARGET_DIR" ]; then
        echo "Error: Version $VERSION does not exist"
        echo "Available versions:"
        ls -1 $APP_DIR/releases
        exit 1
    fi
    
    echo "Switching to version $VERSION..."
    
    # Stop application
    pm2 delete nest-app 2>/dev/null || true
    
    # Update symlink
    ln -sfn $TARGET_DIR $APP_DIR/current
    
    # Start application
    cd $APP_DIR/current
    pm2 start ecosystem.config.js
    pm2 save
    
    # Update version file
    echo "$VERSION" > $APP_DIR/current-version.txt
    date >> $APP_DIR/current-version.txt
    
    echo "Successfully switched to version $VERSION"
    sleep 3
    pm2 list
}

# ============================================
# File: /var/www/nest-app/list-versions.sh
# Usage: ./list-versions.sh
# ============================================
list_versions() {
    echo "========================================="
    echo "Available Versions"
    echo "========================================="
    
    cd /var/www/nest-app/releases
    for dir in */; do
        version=${dir%/}
        size=$(du -sh "$dir" | cut -f1)
        echo "Version: $version (Size: $size)"
    done
    
    echo ""
    echo "Current Version:"
    cat /var/www/nest-app/current-version.txt 2>/dev/null || echo "Unknown"
    echo "========================================="
}

# ============================================
# File: /var/www/nest-app/cleanup-old-versions.sh
# Usage: ./cleanup-old-versions.sh 3
# Keeps only the specified number of versions
# ============================================
cleanup_old_versions() {
    KEEP=${1:-3}
    
    echo "Keeping the $KEEP most recent versions..."
    
    cd /var/www/nest-app/releases
    CURRENT_VERSION=$(readlink /var/www/nest-app/current | xargs basename)
    
    # List versions to delete
    TO_DELETE=$(ls -t | tail -n +$((KEEP + 1)))
    
    if [ -z "$TO_DELETE" ]; then
        echo "No old versions to clean up"
        exit 0
    fi
    
    echo "Versions to be deleted:"
    echo "$TO_DELETE"
    
    read -p "Are you sure you want to delete these versions? (y/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for version in $TO_DELETE; do
            if [ "$version" != "$CURRENT_VERSION" ]; then
                echo "Deleting $version..."
                rm -rf "$version"
            else
                echo "Skipping $version (currently active)"
            fi
        done
        echo "Cleanup completed"
    else
        echo "Cleanup cancelled"
    fi
}

# ============================================
# File: /var/www/nest-app/restart-app.sh
# Usage: ./restart-app.sh
# ============================================
restart_app() {
    echo "Restarting application..."
    pm2 restart nest-app
    sleep 2
    pm2 list
    echo "Application restarted"
}

# Make scripts executable after creating them:
# chmod +x /var/www/nest-app/*.sh