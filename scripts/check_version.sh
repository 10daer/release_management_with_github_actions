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
