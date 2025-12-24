
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
