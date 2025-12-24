
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
