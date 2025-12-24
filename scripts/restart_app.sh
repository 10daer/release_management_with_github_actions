
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