@echo off
echo Instalando e executando app...
flutter install -d uwbekb8hpf6lamts --debug
echo.
echo App instalado! Abra manualmente no dispositivo.
echo Pressione Enter após abrir o app para ver os logs...
pause
flutter logs -d uwbekb8hpf6lamts > app_logs.txt
