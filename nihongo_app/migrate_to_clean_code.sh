#!/bin/bash

# Script để migrate từ code cũ sang code mới đã refactor

echo "🚀 Bắt đầu migration..."

# Backup các file cũ
echo "📦 Backup các file cũ..."
cd /Users/minhkhai/Desktop/NihongoMobileApp/nihongo_app

# Tạo thư mục backup
mkdir -p backup/$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backup/$(date +%Y%m%d_%H%M%S)"

# Backup main.dart
cp lib/main.dart $BACKUP_DIR/main.dart.bak

# Backup register_page.dart nếu tồn tại
if [ -f "lib/features/auth/presentation/pages/register_page.dart" ]; then
    cp lib/features/auth/presentation/pages/register_page.dart $BACKUP_DIR/register_page.dart.bak
fi

# Backup login_page.dart nếu tồn tại
if [ -f "lib/features/auth/presentation/pages/login_page.dart" ]; then
    cp lib/features/auth/presentation/pages/login_page.dart $BACKUP_DIR/login_page.dart.bak
fi

echo "✅ Backup hoàn tất tại: $BACKUP_DIR"

# Thay thế các file
echo "🔄 Thay thế các file..."

# Thay thế main.dart
cp lib/main_new.dart lib/main.dart
echo "✅ Đã thay thế main.dart"

# Thay thế register_page.dart
cp lib/features/auth/presentation/pages/register_page_new.dart lib/features/auth/presentation/pages/register_page.dart
echo "✅ Đã thay thế register_page.dart"

# Thay thế login_page.dart
cp lib/features/auth/presentation/pages/login_page_new.dart lib/features/auth/presentation/pages/login_page.dart
echo "✅ Đã thay thế login_page.dart"

# Xóa các file _new
rm lib/main_new.dart
rm lib/features/auth/presentation/pages/register_page_new.dart
rm lib/features/auth/presentation/pages/login_page_new.dart

echo "🎉 Migration hoàn tất!"
echo "📚 Đọc REFACTOR_GUIDE.md để hiểu về các thay đổi"
echo "🧪 Chạy 'flutter test' để kiểm tra"
echo "🏃 Chạy 'flutter run' để test app"
