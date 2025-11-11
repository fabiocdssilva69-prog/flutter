@echo off
echo Building APK...
flutter build apk --release
if %ERRORLEVEL% EQU 0 (
    echo Build successful!
    echo Installing...
    flutter install -d uwbekb8hpf6lamts
) else (
    echo Build failed!
)
pause
