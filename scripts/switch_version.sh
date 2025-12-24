
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
