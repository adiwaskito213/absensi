#!/bin/sh
# ================================================
# Deploy Script adiwaskito213 Presensi - FreeBSD
# ================================================

echo "🚀 Memulai deploy Dewakoding Presensi ke FreeBSD..."

# Pull latest changes
echo "📥 Pulling latest changes from GitHub..."
git pull origin main

# Install Composer dependencies (production)
echo "📦 Installing Composer dependencies..."
composer install --no-dev --optimize-autoloader --no-interaction

# Install & build frontend
echo "📦 Installing npm dependencies & building assets..."
npm ci --no-audit --prefer-offline
npm run build

# Laravel optimizations
echo "⚡ Optimizing Laravel & Filament..."
php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan filament:upgrade
php artisan filament:optimize

# Storage link
echo "🔗 Creating storage link..."
php artisan storage:link

# Database migration
echo "🗄️ Running migrations..."
php artisan migrate --force

echo "✅ Deploy selesai!"
echo ""
echo "Langkah selanjutnya di server:"
echo "1. chown -R www:www /usr/local/www/presensi"
echo "2. chmod -R 775 storage bootstrap/cache"
echo "3. Restart php-fpm dan nginx"
echo ""
echo "Project siap diakses di /admin"