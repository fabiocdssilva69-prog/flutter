@echo off
echo Iniciando build do APK...
flutter build apk --debug > build_output.log 2>&1
echo Build finalizado! Verifique build_output.log
pause
